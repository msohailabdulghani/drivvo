import 'package:drivvo/modules/admin/more/plan/plan_controller.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PlanView extends GetView<PlanController> {
  const PlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Utils.appColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        // leading: IconButton(
        //   onPressed: () => Navigator.pop(context),
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        // ),
        title: Text(
          'premium_plans'.tr,
          style: Utils.getTextStyle(
            baseSize: 18,
            isBold: true,
            color: Colors.white,
            isUrdu: controller.isUrdu,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    // Header Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Utils.appColor.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        color: Utils.appColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      "everything_included".tr,
                      style: Utils.getTextStyle(
                        baseSize: 20,
                        isBold: true,
                        color: Colors.black,
                        isUrdu: controller.isUrdu,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Features List
                    _buildFeatureItem(
                      Icons.flight_takeoff,
                      "add_unlimited_vehicles".tr,
                    ),
                    _buildFeatureItem(
                      Icons.account_balance,
                      "upload_unlimited_pictures".tr,
                    ),
                    _buildFeatureItem(
                      Icons.color_lens,
                      "add_unlimited_drivers".tr,
                    ),

                    _buildFeatureItem(
                      Icons.category,
                      "assign_vehicles_to_drivers".tr,
                    ),
                    _buildFeatureItem(Icons.groups, "technical_support_24h".tr),
                    const SizedBox(height: 32),

                    // "Choose Your Plan" Header
                    Text(
                      "choose_your_plan".tr,
                      style: Utils.getTextStyle(
                        baseSize: 18,
                        isBold: true,
                        color: Colors.black,
                        isUrdu: controller.isUrdu,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Products List
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final products = controller.productsList;
                      if (products.isEmpty) {
                        return Center(child: Text("no_plans_available".tr));
                      }
                      return Column(
                        children: products.map((product) {
                          final isSelected =
                              controller.selectedProduct.value?.id ==
                              product.id;
                          return _buildSubscriptionCard(product, isSelected);
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Obx(
              () => Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: GestureDetector(
                  onTap:
                      controller.isPurchasing.value ||
                          !controller.isAvailable.value ||
                          !controller.hasProducts
                      ? null
                      : () => controller.buySelectedProduct(),

                  child: Opacity(
                    opacity:
                        controller.isPurchasing.value ||
                            !controller.isAvailable.value ||
                            !controller.hasProducts
                        ? 0.6
                        : 1.0,
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Utils.appColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: controller.isPurchasing.value
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  "subscribe_your_plan".tr,
                                  style: Utils.getTextStyle(
                                    baseSize: 16,
                                    isBold: true,
                                    color: Colors.white,
                                    isUrdu: controller.isUrdu,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Restore Button
            Obx(
              () => Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: TextButton(
                  onPressed:
                      controller.isPurchasing.value ||
                          controller.isRestoring.value
                      ? null
                      : () => controller.restore(),
                  child: controller.isRestoring.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          "restore_purchase".tr,
                          style: Utils.getTextStyle(
                            baseSize: 14,
                            isBold: true,
                            color: Colors.grey,
                            isUrdu: controller.isUrdu,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Utils.appColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: Utils.appColor),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: Utils.getTextStyle(
              baseSize: 14,
              isBold: false,
              color: Colors.black87,
              isUrdu: controller.isUrdu,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(ProductDetails product, bool isSelected) {
    // Determine badges based on ID or details
    bool sMostPopular = product.id.toLowerCase().contains('month');
    bool isBestValue = product.id.toLowerCase().contains('year');

    // If we can't determine by ID, maybe just default:
    // If strict match fails, we might just assume logic or leave it (no badges).
    // Or we could pass index if mapped with index.
    // For now, let's keep ID checks.

    // Color theme
    final borderColor = isSelected ? Utils.appColor : Colors.grey.shade300;

    return GestureDetector(
      onTap: () => controller.selectProduct(product),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: Utils.appColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title.replaceAll(
                          RegExp(r'\(.*\)'),
                          '',
                        ), // Clean title
                        style: Utils.getTextStyle(
                          baseSize: 16,
                          isBold: true,
                          color: Colors.black,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            product.price,
                            style: Utils.getTextStyle(
                              baseSize: 24,
                              isBold: true,
                              color: Colors.black,
                              isUrdu: controller.isUrdu,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isBestValue ? " per year" : " per month",
                            style: Utils.getTextStyle(
                              baseSize: 12,
                              isBold: false,
                              color: Colors.grey,
                              isUrdu: controller.isUrdu,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Daily calculate logic or static text can go here
                      Text(
                        isBestValue
                            ? "Rs 6.16/day"
                            : "Rs 9.33/day", // Placeholder calculation
                        style: Utils.getTextStyle(
                          baseSize: 10,
                          isBold: false,
                          color: Colors.grey,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                      if (isBestValue) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Save Rs 1110",
                            style: Utils.getTextStyle(
                              baseSize: 10,
                              isBold: true,
                              color: Utils.appColor,
                              isUrdu: controller.isUrdu,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Radio Button
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Utils.appColor : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Utils.appColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),

          // Badges
          if (sMostPopular)
            Positioned(
              top: -10,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0), // Purple
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "most_popular".tr,
                  style: Utils.getTextStyle(
                    baseSize: 10,
                    isBold: true,
                    color: Colors.white,
                    isUrdu: controller.isUrdu,
                  ),
                ),
              ),
            ),

          if (isBestValue)
            Positioned(
              top: -10,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF03A9F4), // Light Blue
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "best_value".tr,
                  style: Utils.getTextStyle(
                    baseSize: 10,
                    isBold: true,
                    color: Colors.white,
                    isUrdu: controller.isUrdu,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
