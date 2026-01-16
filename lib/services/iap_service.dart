import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class IAPService extends GetxService with WidgetsBindingObserver {
  static IAPService get to => Get.find();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  final RxList<ProductDetails> products = <ProductDetails>[].obs;
  final RxBool isAvailable = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isPurchasing = false.obs;
  final RxBool isRestorePurchasing = false.obs;
  final RxString iapError = ''.obs;

  // Queue to hold purchases caught before login
  final List<PurchaseDetails> _queuedPurchases = [];

  // Getters for UI state
  bool get hasProducts => products.isNotEmpty;
  String? get errorMessage => iapError.value.isEmpty ? null : iapError.value;

  StreamSubscription<User?>? _authSubscription;

  // Define your Product IDs
  static const Set<String> _productIds = {
    'monthly_subscription',
    'yearly_subscription',
    'carlog_monthly_ios',
    'carlog_yearly_ios',
  };

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    // Listen for Auth changes to process queued purchases
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((
      User? user,
    ) {
      if (user != null && _queuedPurchases.isNotEmpty) {
        debugPrint(
          "User logged in. Processing ${_queuedPurchases.length} queued purchases.",
        );
        final pending = List<PurchaseDetails>.from(_queuedPurchases);
        _queuedPurchases.clear();
        _listenToPurchaseUpdated(pending);
        // Update AppService premium status based on subscription
      }
    });

    _initialize();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription.cancel();
    _authSubscription?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh subscription status when app resumes
      // This catches external cancellations or Play Store updates
      _refreshSubscriptionFromBackend();
      checkSubscriptionStatus();
      AppService.to.getUserProfile();
    }
  }

  Future<IAPService> init() async {
    // Ensure init is called if not auto-initialized
    if (!isAvailable.value) await _initialize();
    return this;
  }

  /// Initialize IAP
  Future<void> _initialize() async {
    isLoading.value = true;
    try {
      isAvailable.value = await _inAppPurchase.isAvailable();

      if (isAvailable.value) {
        // Listen to the stream
        final Stream<List<PurchaseDetails>> purchaseUpdated =
            _inAppPurchase.purchaseStream;

        _subscription = purchaseUpdated.listen(
          (purchaseDetailsList) {
            _listenToPurchaseUpdated(purchaseDetailsList);
          },
          onDone: () {
            _subscription.cancel();
          },
          onError: (error) {
            debugPrint('IAP Stream Error: $error');
            isPurchasing.value = false;
          },
        );

        await _loadProducts();
      }
    } catch (e) {
      debugPrint("IAP Initialization failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadProducts() async {
    try {
      ProductDetailsResponse response = await _inAppPurchase
          .queryProductDetails(_productIds);

      if (response.error != null) {
        debugPrint("IAP Query Error: ${response.error}");
      }

      if (response.productDetails.isNotEmpty) {
        products.assignAll(response.productDetails);
        products.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
      }
    } catch (e) {
      debugPrint("Failed to load products: $e");
    }
  }

  /// Initiate a purchase
  Future<void> buyProduct(ProductDetails product) async {
    // Guard: Check availability
    if (!isAvailable.value) {
      Utils.showSnackBar(message: "iap_not_available_device", success: false);
      return;
    }

    // Guard: Check authentication
    if (FirebaseAuth.instance.currentUser == null) {
      Utils.showSnackBar(message: "login_required_purchase", success: false);
      return;
    }

    isPurchasing.value = true;
    iapError.value = '';

    try {
      late PurchaseParam purchaseParam;

      // Use GooglePlayPurchaseParam for Android to handle upgrades/downgrades correctly
      if (Platform.isAndroid) {
        purchaseParam = GooglePlayPurchaseParam(productDetails: product);
      } else {
        purchaseParam = PurchaseParam(productDetails: product);
      }

      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      isPurchasing.value = false;
      iapError.value = "Purchase failed: ${e.toString()}";
      Utils.showSnackBar(message: "purchase_initiate_failed", success: false);
    }
  }

  /// Restore purchases
  /// This triggers the purchase stream, which will call refreshPlayPurchase for each restored purchase
  Future<void> restorePurchases() async {
    if (FirebaseAuth.instance.currentUser == null) {
      Utils.showSnackBar(message: "login_required_restore", success: false);
      return;
    }
    isRestorePurchasing.value = true;
    isPurchasing.value = true;
    iapError.value = '';

    try {
      // First, trigger the restore from the store
      await _inAppPurchase.restorePurchases();

      // Also directly refresh subscription status from backend
      // This handles cases where restorePurchases doesn't trigger the stream
      await _refreshSubscriptionFromBackend();
      isRestorePurchasing.value = false;
    } catch (e) {
      isRestorePurchasing.value = false;
      isPurchasing.value = false;
      debugPrint("Restore Error: $e");
      iapError.value = "Restore failed: ${e.toString()}";
      Utils.showSnackBar(message: "restore_failed", success: false);
    }
  }

  /// Refresh subscription status directly from backend using refreshPlayPurchase
  ///
  /// Contract: refreshPlayPurchase expects no data (just auth)
  /// Returns: { isEntitled: boolean, subscriptionState: string, expiryTimeMillis?: number, autoRenewing?: boolean }
  Future<void> _refreshSubscriptionFromBackend() async {
    if (FirebaseAuth.instance.currentUser == null) return;

    try {
      debugPrint("Refreshing subscription status from backend...");

      final String functionName = Platform.isIOS
          ? 'refreshAppStorePurchase'
          : 'refreshPlayPurchase';

      final HttpsCallableResult result = await _functions
          .httpsCallable(functionName)
          .call();

      final response = result.data as Map<String, dynamic>?;
      if (response != null) {
        final isEntitled = response['isEntitled'] as bool? ?? false;

        debugPrint("Subscription refreshed. Entitled: $isEntitled");
      }
    } catch (e) {
      debugPrint("Failed to refresh subscription from backend: $e");
      // Don't show error here as restorePurchases may still work via stream
    }
  }

  /// Handle updates from the store
  void _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    if (FirebaseAuth.instance.currentUser == null) {
      debugPrint(
        "User not logged in. Queuing ${purchaseDetailsList.length} purchases.",
      );
      _queuedPurchases.addAll(purchaseDetailsList);
      return;
    }

    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        isPurchasing.value = true;
        debugPrint("Purchase Pending...");
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        final errorCode = purchaseDetails.error?.code;
        final errorMessage = purchaseDetails.error?.message ?? '';

        // Fix: Handle "Item Already Owned" error (Code 7)
        if (errorMessage.contains('itemAlreadyOwned') ||
            errorMessage.contains('BillingResponse.itemAlreadyOwned') ||
            (errorCode == 'purchase_error' && errorMessage.contains('7'))) {
          debugPrint("Item already owned. verifying previous purchase...");
          // If already owned, we consider it a success and verify permissions
          await restorePurchases();
          // Clear error state so we don't show snackbar
          isPurchasing.value = false;
        } else {
          isPurchasing.value = false;
          if (Get.isSnackbarOpen == false) {
            Get.snackbar(
              "Purchase Error",
              "Transaction failed: ${purchaseDetails.error?.message}",
            );
          }
        }
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        bool valid = await _verifyPurchase(purchaseDetails);

        if (valid) {
          await _deliverProduct(purchaseDetails);
        } else {
          _handleInvalidPurchase(purchaseDetails);
        }
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  /// Verify purchase with Cloud Function
  ///
  /// Contract: verifyPlayPurchase expects { productId: string, purchaseToken: string }
  /// Returns: { isEntitled: boolean, subscriptionState: string, expiryTimeMillis?: number, autoRenewing?: boolean }
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // Guard: Check authentication before making the call
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint(
        "User not authenticated. Queuing purchase for later verification.",
      );
      _queuedPurchases.add(purchaseDetails);
      return false;
    }

    debugPrint(
      "Starting _verifyPurchase. Product: ${purchaseDetails.productID}, Type: ${purchaseDetails.runtimeType}",
    );

    // Guard: Ensure auth token is fresh
    try {
      // Refresh the token if it's about to expire (within 5 minutes)
      final tokenResult = await user.getIdTokenResult();
      final expirationTime = tokenResult.expirationTime;
      if (expirationTime != null) {
        final timeUntilExpiry = expirationTime.difference(DateTime.now());
        if (timeUntilExpiry.inMinutes < 5) {
          debugPrint("Auth token expiring soon. Refreshing...");
          await user.getIdToken(true); // Force refresh
        }
      }
    } catch (e) {
      debugPrint("Error checking/refreshing auth token: $e");
      // Continue anyway, the call will fail if token is invalid
    }

    try {
      debugPrint("Verifying purchase: ${purchaseDetails.productID}");
      iapError.value = '';

      // Match the payload exactly to what the Cloud Function expects
      final String functionName;
      final Map<String, dynamic> data;

      if (Platform.isIOS) {
        functionName = 'verifyAppStorePurchase';
        String? originalTransactionId;

        if (purchaseDetails is AppStorePurchaseDetails) {
          final appStoreDetails = purchaseDetails;
          final originalTransaction =
              appStoreDetails.skPaymentTransaction.originalTransaction;
          originalTransactionId =
              originalTransaction?.transactionIdentifier ??
              appStoreDetails.skPaymentTransaction.transactionIdentifier;
        } else {
          // Handle StoreKit 2 (SK2PurchaseDetails)
          // Extract originalTransactionId from JWS token in serverVerificationData
          try {
            final token =
                purchaseDetails.verificationData.serverVerificationData;
            debugPrint("Processing SK2 Token (Length: ${token.length})");

            final parts = token.split('.');
            if (parts.length == 3) {
              final payload = parts[1];
              final normalized = base64Url.normalize(payload);
              final jsonString = utf8.decode(base64Url.decode(normalized));
              final map = json.decode(jsonString);
              debugPrint("SK2 Payload: $map");
              originalTransactionId = map['originalTransactionId'] as String?;
            } else {
              debugPrint(
                "SK2 Token is not a valid JWT (parts: ${parts.length})",
              );
              // Fallback: Use string as is if looks like an ID? No, unsafe.
            }
          } catch (e) {
            debugPrint("Error parsing SK2 token: $e");
          }
        }

        if (originalTransactionId == null) {
          debugPrint("Failed to extract Original Transaction ID");
          iapError.value = "Verification failed: Transaction ID missing";
          return false;
        }

        debugPrint("Extracted Original Transaction ID: $originalTransactionId");

        data = {
          'productId': purchaseDetails.productID,
          'originalTransactionId': originalTransactionId,
        };
      } else {
        functionName = 'verifyPlayPurchase';
        data = {
          'productId': purchaseDetails.productID,
          'purchaseToken':
              purchaseDetails.verificationData.serverVerificationData,
        };
      }

      final HttpsCallableResult result = await _functions
          .httpsCallable(functionName)
          .call(data);

      debugPrint("Verification Result: ${result.data}");

      // Parse response according to the contract
      final response = result.data as Map<String, dynamic>?;
      if (response == null) {
        debugPrint("Verification failed: Null response");
        iapError.value = "Verification failed: Invalid response";
        return false;
      }

      // Check isEntitled field (primary indicator of success)
      final isEntitled = response['isEntitled'] as bool? ?? false;

      if (isEntitled) {
        // Update AppService premium status based on subscription
        debugPrint("Purchase verified successfully. User is now entitled.");
        return true;
      } else {
        final state = response['subscriptionState'] as String? ?? 'UNKNOWN';
        debugPrint(
          "Purchase verification returned not entitled. State: $state",
        );
        iapError.value = "Subscription not active. State: $state";
        return false;
      }
    } on FirebaseFunctionsException catch (e) {
      // Handle specific Firebase Functions errors
      if (e.code == 'unauthenticated') {
        debugPrint(
          "Authentication failed. Queuing purchase for later verification.",
        );
        _queuedPurchases.add(purchaseDetails);
        iapError.value = "Please log in to verify your purchase.";
        return false;
      }
      debugPrint("Verification failed: ${e.code} - ${e.message}");
      debugPrint("Error Details: ${e.details}");
      iapError.value = "Verification failed: ${e.message ?? e.code}";
      return false;
    } catch (e) {
      debugPrint("Verification failed: $e");
      iapError.value = "Verification failed: ${e.toString()}";
      return false;
    }
  }

  Future<void> _deliverProduct(PurchaseDetails purchaseDetails) async {
    try {
      // 1. Wait slightly to ensure Firestore triggers have processed the subscription document
      await Future.delayed(const Duration(seconds: 1));

      // 2. Refresh subscription status from backend to ensure AppService is updated
      await _refreshSubscriptionFromBackend();
      await checkSubscriptionStatus();
      AppService.to.getUserProfile();

      isPurchasing.value = false;

      // 3. Navigate back if on premium/plan screen
      if (Get.currentRoute.contains('premium') ||
          Get.currentRoute.contains('plan')) {
        Get.back();
      }

      Utils.showSnackBar(message: "premium_activated_success", success: true);
    } catch (e) {
      debugPrint("Error delivering product: $e");
      isPurchasing.value = false;
      // Still show success as verification passed
      Utils.showSnackBar(message: "premium_sync_delayed", success: false);
    }
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    isPurchasing.value = false;
    Utils.showSnackBar(
      message: iapError.value.isNotEmpty
          ? iapError.value
          : "purchase_verification_failed",
      success: false,
    );
  }

  /// Refresh user data from backend
  /// Uses checkSubscriptionStatus Cloud Function for lightweight check, or falls back to Firestore
  ///
  /// Contract: checkSubscriptionStatus expects no data (just auth)
  /// Returns: { isEntitled: boolean, subscriptionState: string, expiryTimeMillis?: number, autoRenewing?: boolean }
  Future<void> checkSubscriptionStatus() async {
    if (FirebaseAuth.instance.currentUser == null) return;

    try {
      // Try Cloud Function first (lightweight, cached check)
      try {
        final HttpsCallableResult result = await _functions
            .httpsCallable('checkSubscriptionStatus')
            .call();

        final response = result.data as Map<String, dynamic>?;
        if (response != null) {
          debugPrint(result.data.toString());

          final isEntitled = response['isEntitled'] as bool? ?? false;
          debugPrint(
            "Subscription status checked via Cloud Function. Entitled: $isEntitled",
          );
          return;
        }
      } catch (e) {
        debugPrint(
          "Cloud Function check failed, falling back to Firestore: $e",
        );
      }

      // Fallback: Refresh from Firestore directly
      await AppService.to.getUserProfile();
      debugPrint("Subscription status checked via Firestore.");
    } catch (e) {
      debugPrint("Failed to check subscription status: $e");
    }
  }
}
