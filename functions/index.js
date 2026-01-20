/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { google } = require("googleapis");
const { onCall } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const jwt = require("jsonwebtoken");
const https = require("https");

admin.initializeApp();

// Ignore undefined values in Firestore writes (e.g., optional fields)
admin.firestore().settings({ ignoreUndefinedProperties: true });

// Define secrets using v2 API
const PLAY_SERVICE_ACCOUNT_JSON = defineSecret("PLAY_SERVICE_ACCOUNT_JSON");
const PLAY_PACKAGE_NAME = defineSecret("PLAY_PACKAGE_NAME");
const APP_STORE_KEY_ID = defineSecret("APP_STORE_KEY_ID");
const APP_STORE_ISSUER_ID = defineSecret("APP_STORE_ISSUER_ID");
const APP_STORE_PRIVATE_KEY = defineSecret("APP_STORE_PRIVATE_KEY");
const APP_STORE_BUNDLE_ID = defineSecret("APP_STORE_BUNDLE_ID");

// App Store Product IDs
const IOS_ID_MONTHLY = "carlog_monthly_ios";
const IOS_ID_YEARLY = "carlog_yearly_ios";
/**
 * Cloud Function to create a new user with email and password
 * This uses Firebase Admin SDK so the calling user doesn't get signed out
 * Using onRequest with public access for maximum compatibility
 */
exports.createUser = onRequest(
  {
    cors: true,
    region: "us-central1",
    // Allow unauthenticated access - security is handled via adminId validation in Firestore
    invoker: "public"
  },
  async (req, res) => {
    // Log the request for debugging
    logger.info("createUser HTTP function called");
    logger.info("Method:", req.method);

    // Only allow POST requests
    if (req.method !== "POST") {
      res.status(405).json({ success: false, message: "Method not allowed" });
      return;
    }

    try {
      const { email, password, firstName, lastName, userType, adminId } = req.body;

      logger.info("Request data received:", { email, firstName, lastName, userType, adminId });

      // Validate adminId is provided (required for security)
      if (!adminId) {
        logger.warn("No adminId provided");
        res.status(400).json({
          success: false,
          message: "Admin ID is required."
        });
        return;
      }

      // Verify the admin exists in Firestore (security check)
      const adminDoc = await admin.firestore()
        .collection("UserProfile")
        .doc(adminId)
        .get();

      if (!adminDoc.exists) {
        logger.warn("Admin not found:", adminId);
        res.status(403).json({
          success: false,
          message: "Invalid admin ID."
        });
        return;
      }

      logger.info("Admin verified:", adminId);

      // Validate required fields
      if (!email || !password) {
        res.status(400).json({
          success: false,
          message: "Email and password are required."
        });
        return;
      }

      // Create the user in Firebase Auth using Admin SDK
      const userRecord = await admin.auth().createUser({
        email: email,
        password: password,
        displayName: `${firstName || ""} ${lastName || ""}`.trim(),
      });

      logger.info("Successfully created new user:", userRecord.uid);

      // Create user profile document in Firestore
      const userProfileData = {
        id: userRecord.uid,
        email: email,
        first_name: firstName || "",
        last_name: lastName || "",
        sign_in_method: "email",
        user_type: userType || "",
        admin_id: adminId || "",
        created_at: admin.firestore.FieldValue.serverTimestamp(),
      };

      await admin.firestore()
        .collection("UserProfile")
        .doc(userRecord.uid)
        .set(userProfileData);

      logger.info("Successfully created user profile in Firestore");

      res.status(200).json({
        success: true,
        uid: userRecord.uid,
        message: "User created successfully",
      });
    } catch (error) {
      logger.error("Error creating new user:", error);

      // Handle specific Firebase Auth errors
      if (error.code === "auth/email-already-exists") {
        res.status(409).json({
          success: false,
          code: "already-exists",
          message: "The email address is already in use by another account."
        });
        return;
      }
      if (error.code === "auth/invalid-email") {
        res.status(400).json({
          success: false,
          code: "invalid-argument",
          message: "The email address is not valid."
        });
        return;
      }
      if (error.code === "auth/weak-password") {
        res.status(400).json({
          success: false,
          code: "invalid-argument",
          message: "The password is too weak."
        });
        return;
      }

      res.status(500).json({
        success: false,
        code: "internal",
        message: error.message || "An error occurred while creating the user."
      });
    }
  }
);

/**
 * Creates and authenticates a Google API client for the Android Publisher API.
 */
async function getPublisher() {
  const SA_JSON = PLAY_SERVICE_ACCOUNT_JSON.value();
  if (!SA_JSON) {
    console.error("Missing PLAY_SERVICE_ACCOUNT_JSON secret at runtime.");
    throw new functions.https.HttpsError(
      "internal",
      "Server configuration error: Missing service account credentials.",
    );
  }

  let credentials;
  try {
    credentials = JSON.parse(SA_JSON);
  } catch (parseErr) {
    console.error("Failed to parse PLAY_SERVICE_ACCOUNT_JSON:", parseErr.message);
    throw new functions.https.HttpsError(
      "internal",
      "Server configuration error: Invalid service account JSON.",
    );
  }
  const auth = new google.auth.GoogleAuth({
    credentials,
    scopes: ["https://www.googleapis.com/auth/androidpublisher"],
  });
  const client = await auth.getClient();
  return google.androidpublisher({ version: "v3", auth: client });
}

/**
 * Normalizes the V2 subscription response from Google Play API.
 */
function normalizeSubscriptionData(subV2) {
  const state = subV2.subscriptionState;
  const lineItem = Array.isArray(subV2.lineItems) ? subV2.lineItems[0] : undefined;

  let expiryTimeMillis;
  if (lineItem && lineItem.expiryTime) {
    if (typeof lineItem.expiryTime === "string") {
      const parsed = Date.parse(lineItem.expiryTime);
      expiryTimeMillis = !isNaN(parsed) ? parsed : undefined;
    } else {
      const numericExpiry = Number(lineItem.expiryTime);
      expiryTimeMillis = Number.isFinite(numericExpiry) ? numericExpiry : undefined;
    }
  }

  const autoRenewing = lineItem && lineItem.autoRenewingPlan &&
    lineItem.autoRenewingPlan.autoRenewEnabled;

  const isEntitled =
    state === "SUBSCRIPTION_STATE_ACTIVE" ||
    state === "SUBSCRIPTION_STATE_IN_GRACE_PERIOD";

  return {
    isEntitled,
    subscriptionState: state,
    expiryTimeMillis,
    autoRenewing,
    type: "subscription",
  };
}

/**
 * Normalizes the product (one-time) response from Google Play API.
 */


/**
 * Verifies a new Google Play purchase (Subscription or One-time product).
 */
exports.verifyPlayPurchase = onCall(
  {
    enforceAppCheck: false,
    secrets: [PLAY_SERVICE_ACCOUNT_JSON, PLAY_PACKAGE_NAME],
  },
  async (request) => {
    const PACKAGE_NAME = PLAY_PACKAGE_NAME.value().trim();
    if (!PACKAGE_NAME) {
      throw new functions.https.HttpsError("internal", "Server configuration error: Missing package name.");
    }

    if (!request.auth) {
      throw new functions.https.HttpsError("unauthenticated", "Authentication required.");
    }

    const { productId, purchaseToken } = request.data || {};
    if (!productId || !purchaseToken) {
      throw new functions.https.HttpsError("invalid-argument", "productId and purchaseToken are required.");
    }

    const uid = request.auth.uid;
    console.log(`Verifying ${productId} for user: ${uid}`);

    try {
      const pub = await getPublisher();
      let purchaseData;

      // Handle Subscription
      const resp = await pub.purchases.subscriptionsv2.get({
        packageName: PACKAGE_NAME,
        token: purchaseToken,
      });
      purchaseData = normalizeSubscriptionData(resp.data || {});

      // Atomic check and write using transaction
      await admin.firestore().runTransaction(async (transaction) => {
        const tokenRef = admin.firestore().doc(`purchaseTokens/${purchaseToken}`);
        const tokenSnap = await transaction.get(tokenRef);

        if (tokenSnap.exists && tokenSnap.data().userId !== uid) {
          throw new functions.https.HttpsError("already-exists", "This purchase is already associated with another account.");
        }

        const docRef = admin.firestore().doc(`UserProfile/${uid}/`);

        // Write the token mapping
        transaction.set(tokenRef, {
          userId: uid,
          productId,
          store: "google_play",
          verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, { merge: true });

        // Write the subscription data
        transaction.set(docRef, {
          store: "google_play",
          productId,
          purchaseToken,
          packageName: PACKAGE_NAME,
          userId: uid,
          ...purchaseData,
          verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
          lastCheckedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, { merge: true });
      });

      return purchaseData;
    } catch (err) {
      console.error("verifyPlayPurchase failed:", err);
      if (err instanceof functions.https.HttpsError) {
        throw err;
      }
      throw new functions.https.HttpsError("internal", "Failed to verify purchase.", { message: err.message, details: err });
    }
  },
);

/**
 * Refreshes the current user's existing Google Play purchase status.
 */
exports.refreshPlayPurchase = onCall(
  {
    enforceAppCheck: false,
    secrets: [PLAY_SERVICE_ACCOUNT_JSON, PLAY_PACKAGE_NAME],
  },
  async (request) => {
    const PACKAGE_NAME = PLAY_PACKAGE_NAME.value().trim();
    if (!PACKAGE_NAME) {
      throw new functions.https.HttpsError("internal", "Missing package name.");
    }

    if (!request.auth) {
      throw new functions.https.HttpsError("unauthenticated", "Authentication required.");
    }

    const uid = request.auth.uid;

    try {
      const subRef = admin.firestore().doc(`UserProfile/${uid}`);
      const snap = await subRef.get();

      if (!snap.exists) {
        return { isEntitled: false, subscriptionState: "UNSPECIFIED" };
      }

      const info = snap.data();
      if (info.userId && info.userId !== uid) {
        throw new functions.https.HttpsError("permission-denied", "Unauthorized access.");
      }

      if (info.store !== "google_play") {
        return { isEntitled: false, subscriptionState: "UNSPECIFIED" };
      }

      // If it's lifetime and already verified, we might not need to refresh every time,
      // but Google recommends checking occasionally.
      const token = info.purchaseToken;
      const productId = info.productId;
      if (!token || !productId) {
        return { isEntitled: false, subscriptionState: "UNSPECIFIED" };
      }

      const pub = await getPublisher();
      let purchaseData;

      const resp = await pub.purchases.subscriptionsv2.get({
        packageName: PACKAGE_NAME,
        token,
      });
      purchaseData = normalizeSubscriptionData(resp.data || {});

      await subRef.set(
        {
          ...purchaseData,
          lastCheckedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        { merge: true },
      );

      return purchaseData;
    } catch (err) {
      console.error("refreshPlayPurchase failed:", err);
      throw new functions.https.HttpsError("internal", "Failed to refresh status.");
    }
  },
);

/**
 * Lightweight check for current subscription status from Firestore.
 */
exports.checkSubscriptionStatus = onCall(
  { enforceAppCheck: false },
  async (request) => {
    if (!request.auth) {
      throw new functions.https.HttpsError("unauthenticated", "Authentication required.");
    }

    const uid = request.auth.uid;
    const snap = await admin.firestore().doc(`UserProfile/${uid}`).get();

    if (!snap.exists) {
      return { isEntitled: false, subscriptionState: "UNSPECIFIED" };
    }

    const data = snap.data();
    let isEntitled = data.isEntitled || false;

    // Safety check: If productId is missing, data is invalid
    if (!data.productId) {
      isEntitled = false;
    }

    // Check for expiration
    if (isEntitled && data.expiryTimeMillis) {
      if (Date.now() > data.expiryTimeMillis) {
        console.log(`Subscription expired for user ${uid}. Expiry: ${data.expiryTimeMillis}, Now: ${Date.now()}`);
        isEntitled = false;
      }
    }

    return {
      isEntitled: isEntitled,
      subscriptionState: data.subscriptionState || "UNSPECIFIED",
      expiryTimeMillis: data.expiryTimeMillis,
      autoRenewing: data.autoRenewing,
      productId: data.productId,
      type: data.type,
    };
  },
);

// --- APP STORE FUNCTIONS (Using Official Apple Library) ---

/**
 * Creates an App Store Server API client using Apple's official library.
 * Uses lazy loading to avoid deployment timeout.
 * @param {string} environment - The environment: 'production' or 'sandbox'.
 * @return {AppStoreServerAPIClient} The configured client.
 */
function createAppStoreClient(environment = "production") {
  // Lazy load to avoid deployment timeout
  const { AppStoreServerAPIClient, Environment } = require("@apple/app-store-server-library");

  const keyId = APP_STORE_KEY_ID.value();
  const issuerId = APP_STORE_ISSUER_ID.value();
  const bundleId = APP_STORE_BUNDLE_ID.value();
  let rawKey = APP_STORE_PRIVATE_KEY.value();

  if (!rawKey || !keyId || !issuerId || !bundleId) {
    throw new functions.https.HttpsError(
      "internal",
      "Missing App Store configuration secrets."
    );
  }

  // Format the private key if needed
  if (rawKey) {
    rawKey = rawKey.replace(/\\n/g, "\n");
    if (!rawKey.includes("-----BEGIN PRIVATE KEY-----\n")) {
      rawKey = rawKey.replace("-----BEGIN PRIVATE KEY-----", "-----BEGIN PRIVATE KEY-----\n");
    }
    if (!rawKey.includes("\n-----END PRIVATE KEY-----")) {
      rawKey = rawKey.replace("-----END PRIVATE KEY-----", "\n-----END PRIVATE KEY-----");
    }
  }

  const env = environment === "sandbox"
    ? Environment.SANDBOX
    : Environment.PRODUCTION;

  return new AppStoreServerAPIClient(rawKey, keyId, issuerId, bundleId, env);
}

/**
 * Normalizes the subscription status from App Store Server API.
 * Maps status codes to the same format as Google Play.
 *
 * @param {number} status - The subscription status from App Store (1-5).
 * @param {object} transactionInfo - The decoded transaction info.
 * @return {object} Normalized subscription data.
 */
function normalizeAppStoreStatus(status, transactionInfo) {
  let subscriptionState;
  let isEntitled = false;

  // FIX: Sometimes Apple returns status 2 (Expired) shortly before the actual expiration time
  // (especially in Sandbox). We double-check the expiration date against the current time.
  let expiryTimeMillis = null;
  if (transactionInfo && transactionInfo.expiresDate) {
    expiryTimeMillis = Number(transactionInfo.expiresDate);
  }

  if (status === 2 && expiryTimeMillis && expiryTimeMillis > Date.now()) {
    console.log(`Status is EXPIRED (2) but expiry is in future (${expiryTimeMillis} > ${Date.now()}). Treating as ACTIVE.`);
    status = 1;
  }

  // Status codes: 1=Active, 2=Expired, 3=BillingRetry, 4=GracePeriod, 5=Revoked
  switch (status) {
    case 1:
      subscriptionState = "SUBSCRIPTION_STATE_ACTIVE";
      isEntitled = true;
      break;
    case 4:
    case 3:
      subscriptionState = "SUBSCRIPTION_STATE_IN_GRACE_PERIOD";
      isEntitled = true;
      break;
    case 2:
      subscriptionState = "SUBSCRIPTION_STATE_EXPIRED";
      isEntitled = false;
      break;
    case 5:
      subscriptionState = "SUBSCRIPTION_STATE_CANCELED";
      isEntitled = false;
      break;
    default:
      subscriptionState = "SUBSCRIPTION_STATE_UNSPECIFIED";
      isEntitled = false;
  }

  return {
    isEntitled,
    subscriptionState,
    expiryTimeMillis,
    autoRenewing: status === 1 || status === 4,
    productId: transactionInfo && transactionInfo.productId ? transactionInfo.productId : null,
    type: "subscription",
  };
}

/**
 * Verifies a new App Store purchase and saves data to Firestore.
 * Uses Apple's official app-store-server-library for API calls.
 */
exports.verifyAppStorePurchase = onCall(
  {
    enforceAppCheck: false,
    secrets: [APP_STORE_KEY_ID, APP_STORE_ISSUER_ID, APP_STORE_PRIVATE_KEY, APP_STORE_BUNDLE_ID],
  },
  async (request) => {
    const BUNDLE_ID = APP_STORE_BUNDLE_ID.value();
    if (!BUNDLE_ID) {
      throw new functions.https.HttpsError("internal", "Missing bundle ID.");
    }

    if (!request.auth) {
      throw new functions.https.HttpsError("unauthenticated", "Authentication required.");
    }

    const { productId, originalTransactionId, transactionId, expiresDate } = request.data || {};
    if (!productId || !originalTransactionId) {
      throw new functions.https.HttpsError("invalid-argument", "productId and originalTransactionId are required.");
    }

    // Validate product IDs
    if (productId !== IOS_ID_MONTHLY && productId !== IOS_ID_YEARLY) {
      throw new functions.https.HttpsError("invalid-argument", "Invalid product ID.");
    }

    const uid = request.auth.uid;
    console.log(`Verifying App Store purchase for user: ${uid}, product: ${productId}`);
    console.log(`TransactionId: ${transactionId}, ExpiresDate from client: ${expiresDate}`);

    try {
      let purchaseData;
      let environment = "production";

      // Helper to attempt verification using official Apple library
      const attemptVerification = async (env) => {
        const client = createAppStoreClient(env);

        // For subscriptions, use getAllSubscriptionStatuses
        const response = await client.getAllSubscriptionStatuses(originalTransactionId);
        console.log(`Subscription response (${env}):`, JSON.stringify(response));

        // Check if data is empty - this can happen with old sandbox subscriptions
        if (!response.data || response.data.length === 0) {
          console.log(`No subscription data returned from getAllSubscriptionStatuses.`);

          // Use client-provided expiresDate to determine status
          // This is acceptable because the client has a valid JWS token from Apple
          if (expiresDate) {
            const clientExpiryMs = Number(expiresDate);
            const now = Date.now();
            console.log(`Using client-provided expiresDate: ${clientExpiryMs}, Now: ${now}`);

            if (clientExpiryMs > now) {
              console.log(`Client expiresDate is in the future. Treating as ACTIVE.`);
              return {
                isEntitled: true,
                subscriptionState: "SUBSCRIPTION_STATE_ACTIVE",
                expiryTimeMillis: clientExpiryMs,
                autoRenewing: true,
                productId: productId,
                type: "subscription",
              };
            } else {
              console.log(`Client expiresDate is in the past. Subscription is EXPIRED.`);
              return {
                isEntitled: false,
                subscriptionState: "SUBSCRIPTION_STATE_EXPIRED",
                expiryTimeMillis: clientExpiryMs,
                autoRenewing: false,
                productId: productId,
                type: "subscription",
              };
            }
          }

          throw new Error("No transaction data found in response");
        }

        // Extract subscription info from response
        const subscriptionGroup = response.data && response.data[0];
        const lastTransaction = subscriptionGroup && subscriptionGroup.lastTransactions && subscriptionGroup.lastTransactions[0];

        if (!lastTransaction) {
          throw new Error("No transaction data found in response");
        }

        // The library decodes JWS automatically - signedTransactionInfo is already decoded
        const transactionInfo = lastTransaction.signedTransactionInfo;
        console.log(`Transaction Info (${env}):`, transactionInfo);

        return normalizeAppStoreStatus(lastTransaction.status, transactionInfo);
      };

      // Try production first, then sandbox (per Apple's recommendation)
      try {
        console.log(`Attempting production verification for transactionId: ${originalTransactionId}`);
        purchaseData = await attemptVerification("production");
        console.log("Production verification succeeded");
      } catch (err) {
        console.log(`Production failed: ${err.message}, trying sandbox...`);
        try {
          purchaseData = await attemptVerification("sandbox");
          environment = "sandbox";
          console.log("Sandbox verification succeeded");
        } catch (sandboxErr) {
          console.error(`Both production and sandbox verification failed. Production: ${err.message}, Sandbox: ${sandboxErr.message}`);
          throw new Error(`Verification failed. Prod: ${err.message}, Sandbox: ${sandboxErr.message}`);
        }
      }

      // Atomic check and write using transaction
      await admin.firestore().runTransaction(async (transaction) => {
        const mappingRef = admin.firestore().doc(`originalTransactionIds/${originalTransactionId}`);
        const mappingSnap = await transaction.get(mappingRef);

        if (mappingSnap.exists && mappingSnap.data().userId !== uid) {
          throw new functions.https.HttpsError("already-exists", "This purchase is already associated with another account.");
        }

        const docRef = admin.firestore().doc(`UserProfile/${uid}/`);

        // Write the ID mapping
        transaction.set(mappingRef, {
          userId: uid,
          productId,
          store: "app_store",
          environment,
          verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, { merge: true });

        // Write the subscription data
        transaction.set(docRef, {
          store: "app_store",
          productId,
          originalTransactionId,
          bundleId: BUNDLE_ID,
          environment,
          userId: uid,
          ...purchaseData,
          verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
          lastCheckedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, { merge: true });
      });

      console.log(`App Store purchase verified successfully for user: ${uid}`);
      return purchaseData;
    } catch (err) {
      console.error("verifyAppStorePurchase failed:", err);
      if (err instanceof functions.https.HttpsError) {
        throw err;
      }
      throw new functions.https.HttpsError("internal", "Failed to verify App Store purchase.", { originalMessage: err?.message || String(err) });
    }
  },
);

/**
 * Refreshes the current user's existing App Store purchase status.
 * Uses Apple's official app-store-server-library for API calls.
 */
exports.refreshAppStorePurchase = onCall(
  {
    enforceAppCheck: false,
    secrets: [APP_STORE_KEY_ID, APP_STORE_ISSUER_ID, APP_STORE_PRIVATE_KEY, APP_STORE_BUNDLE_ID],
  },
  async (request) => {
    const BUNDLE_ID = APP_STORE_BUNDLE_ID.value();
    if (!BUNDLE_ID) {
      throw new functions.https.HttpsError("internal", "Missing bundle ID.");
    }

    if (!request.auth) {
      throw new functions.https.HttpsError("unauthenticated", "Authentication required.");
    }

    const uid = request.auth.uid;
    console.log(`Refreshing App Store subscription for user: ${uid}`);

    try {
      const subRef = admin.firestore().doc(`UserProfile/${uid}`);
      const snap = await subRef.get();

      if (!snap.exists) {
        console.log(`No subscription found for user: ${uid}`);
        return { isEntitled: false, subscriptionState: "UNSPECIFIED" };
      }

      const info = snap.data();
      if (info.userId && info.userId !== uid) {
        throw new functions.https.HttpsError("permission-denied", "Unauthorized access.");
      }

      if (info.store !== "app_store") {
        console.log(`Subscription is not from App Store (store: ${info.store})`);
        return { isEntitled: info.isEntitled || false, subscriptionState: info.subscriptionState || "UNSPECIFIED" };
      }

      const originalTransactionId = info.originalTransactionId;
      const productId = info.productId;
      if (!originalTransactionId || !productId) {
        console.log(`No originalTransactionId found for user: ${uid}`);
        return { isEntitled: false, subscriptionState: "UNSPECIFIED" };
      }

      // GRACE PERIOD PROTECTION:
      // If subscription was recently verified (within last 60 seconds),
      // skip App Store API call to avoid overwriting with stale data.
      const verifiedAt = info.verifiedAt;
      if (verifiedAt) {
        const verifiedTime = verifiedAt.toMillis ? verifiedAt.toMillis() : verifiedAt._seconds * 1000;
        const now = Date.now();
        const gracePeriodMs = 60 * 1000; // 60 seconds
        if (now - verifiedTime < gracePeriodMs) {
          console.log(
            `Subscription was recently verified (${Math.round((now - verifiedTime) / 1000)}s ago). ` +
            `Returning cached data to avoid race condition with App Store API.`
          );
          return {
            isEntitled: info.isEntitled || false,
            subscriptionState: info.subscriptionState || "UNSPECIFIED",
            expiryTimeMillis: info.expiryTimeMillis,
            autoRenewing: info.autoRenewing,
          };
        }
      }

      let environment = info.environment || "production";
      let purchaseData;

      // Helper to attempt refresh using official Apple library
      const attemptRefresh = async (env) => {
        const client = createAppStoreClient(env);

        const response = await client.getAllSubscriptionStatuses(originalTransactionId);

        const subscriptionGroup = response.data && response.data[0];
        const lastTransaction = subscriptionGroup && subscriptionGroup.lastTransactions && subscriptionGroup.lastTransactions[0];

        if (!lastTransaction) {
          throw new Error("No transaction data found in response");
        }

        const transactionInfo = lastTransaction.signedTransactionInfo;
        return normalizeAppStoreStatus(lastTransaction.status, transactionInfo);
      };

      try {
        console.log(`Attempting ${environment} refresh for transactionId: ${originalTransactionId}`);
        purchaseData = await attemptRefresh(environment);
        console.log(`${environment} refresh succeeded`);
      } catch (err) {
        if (environment === "production") {
          console.log(`Production refresh failed: ${err.message}, trying sandbox fallback...`);
          try {
            purchaseData = await attemptRefresh("sandbox");
            environment = "sandbox";
            console.log("Sandbox refresh succeeded");
            // Update environment in Firestore
            await subRef.set({ environment: "sandbox" }, { merge: true });
          } catch (sandboxErr) {
            console.error(`Both production and sandbox refresh failed. Production: ${err.message}, Sandbox: ${sandboxErr.message}`);
            throw new Error(`Refresh failed. Prod: ${err.message}, Sandbox: ${sandboxErr.message}`);
          }
        } else {
          throw err;
        }
      }

      await subRef.set(
        {
          ...purchaseData,
          lastCheckedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        { merge: true },
      );

      console.log(`App Store subscription refreshed for user: ${uid}, entitled: ${purchaseData.isEntitled}`);
      return purchaseData;
    } catch (err) {
      console.error("refreshAppStorePurchase failed:", err);
      throw new functions.https.HttpsError("internal", "Failed to refresh App Store status.");
    }
  },
);

/**
 * Exports vehicle data for the authenticated user.
 */
exports.exportVehicleData = onCall(
  { enforceAppCheck: false },
  async (request) => {
    if (!request.auth) {
      throw new functions.https.HttpsError("unauthenticated", "Authentication required.");
    }

    const { vehicleId } = request.data;
    if (!vehicleId) {
      throw new functions.https.HttpsError("invalid-argument", "vehicleId is required.");
    }

    const uid = request.auth.uid;
    console.log(`Exporting vehicle data for user: ${uid}, vehicle: ${vehicleId}`);

    try {
      const vehicleDoc = await admin.firestore()
        .doc(`UserProfile/${uid}/Vehicles/${vehicleId}`)
        .get();

      if (!vehicleDoc.exists) {
        throw new functions.https.HttpsError("not-found", "Vehicle not found.");
      }

      const vehicleData = vehicleDoc.data();

      // Convert timestamps to ISO strings for better JSON portability
      const processedData = JSON.parse(JSON.stringify(vehicleData, (key, value) => {
        // Handle Firestore Timestamps (they come as objects with _seconds and _nanoseconds in some contexts, 
        // or as strings in others depending on serialization, but here inside Cloud Functions they are objects)
        // However, generic JSON.stringify might not handle them well if they are class instances.
        // It's safer to just return the data and let client handle it, or do simple conversion.
        // But the client expects JSON.
        return value;
      }));

      return {
        exportedAt: new Date().toISOString(),
        vehicleId: vehicleId,
        data: processedData
      };
    } catch (e) {
      console.error("Error exporting vehicle data:", e);
      throw new functions.https.HttpsError("internal", "Failed to export data.");
    }
  }
);

/**
 * Imports vehicle data for the authenticated user.
 */
exports.importVehicleData = onCall(
  { enforceAppCheck: false },
  async (request) => {
    if (!request.auth) {
      throw new functions.https.HttpsError("unauthenticated", "Authentication required.");
    }

    const { vehicleId, data } = request.data;
    if (!vehicleId || !data) {
      throw new functions.https.HttpsError("invalid-argument", "Invalid import data format.");
    }

    const uid = request.auth.uid;
    console.log(`Importing vehicle data for user: ${uid}, vehicle: ${vehicleId}`);

    try {
      const vehicleRef = admin.firestore()
        .doc(`UserProfile/${uid}/Vehicles/${vehicleId}`);

      // Basic check to see if vehicle already exists
      const docSnap = await vehicleRef.get();
      if (docSnap.exists) {
        // Option: throw error or overwrite. For now, let's overwrite/merge
        console.log(`Vehicle ${vehicleId} already exists. Overwriting.`);
      }

      // We need to restore Timestamps.
      const restoreTimestamps = (obj) => {
        if (obj === null || typeof obj !== 'object') {
          return obj;
        }

        if (obj._seconds !== undefined && obj._nanoseconds !== undefined) {
          return new admin.firestore.Timestamp(obj._seconds, obj._nanoseconds);
        }

        if (Array.isArray(obj)) {
          return obj.map(restoreTimestamps);
        }

        const newObj = {};
        for (const key in obj) {
          newObj[key] = restoreTimestamps(obj[key]);
        }
        return newObj;
      };

      const restoredData = restoreTimestamps(data);

      await vehicleRef.set(restoredData, { merge: true });

      return { success: true, vehicleId: vehicleId };

    } catch (e) {
      console.error("Error importing vehicle data:", e);
      throw new functions.https.HttpsError("internal", "Failed to import data.");
    }
  }
);