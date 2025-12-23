import 'package:drivvo/custom-widget/common/custom_app_bar.dart';
import 'package:drivvo/modules/more/plan/plan_controller.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanView extends GetView<PlanController> {
  const PlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      appBar: CustomAppBar(
        name: "premium_plans".tr,
        isUrdu: controller.isUrdu,
        bgColor: Utils.appColor,
        textColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Text(
                "Driving Pins",
                style: Utils.getTextStyle(
                  baseSize: 28,
                  isBold: true,
                  color: const Color(0xFF1E2E4B),
                  isUrdu: controller.isUrdu,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Complete Fleet Management Solution. Keep track of your vehicles with real-time monitoring, maintenance alerts, and detailed reporting.",
                textAlign: TextAlign.center,
                style: Utils.getTextStyle(
                  baseSize: 14,
                  isBold: false,
                  color: Colors.grey[600]!,
                  isUrdu: controller.isUrdu,
                ),
              ),
              const SizedBox(height: 30),
              _buildBillingToggle(),
              const SizedBox(height: 30),
              _buildPlanCard(
                title: "Free",
                price: "₹0",
                description:
                    "Perfect for individuals or small fleets getting started with fleet management.",
                buttonText: "Get Started Free",
                buttonColor: const Color(0xFF90A4AE),
                features: [
                  "Basic vehicle tracking",
                  "Up to 3 vehicles",
                  "Basic operation logging",
                  "Monthly reports",
                  {"Priority support": false},
                ],
              ),
              const SizedBox(height: 20),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildPlanCard(
                    title: "Individual",
                    price: "₹12,500",
                    description:
                        "Ideal for small businesses or fleet owners with up to 10 vehicles.",
                    buttonText: "Start 14-Day Trial",
                    buttonColor: const Color(0xFF3498DB),
                    isHighlighted: true,
                    features: [
                      "Everything from Free plan",
                      "User management & themes",
                      "Up to 10 vehicles",
                      "100 MB storage per vehicle",
                      "Data export (CSV/Excel)",
                      "Unlimited records",
                      "Priority support (24h response)",
                    ],
                  ),
                  Positioned(
                    top: -12,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3498DB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "MOST POPULAR",
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
              const SizedBox(height: 20),
              _buildPlanCard(
                title: "Corporate",
                price: "Custom",
                priceSuffix: " pricing",
                description:
                    "For enterprises with large fleets requiring advanced features and dedicated support.",
                buttonText: "Contact Sales",
                buttonColor: const Color(0xFF2C3E50),
                features: [
                  "Everything from Individual plan",
                  "Unlimited vehicles",
                  "Custom storage allocation",
                  "Advanced analytics & reports",
                  "API access & integrations",
                  "Dedicated account manager",
                  "24/7 phone & chat support",
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "All plans come with a 30-day money-back guarantee. No credit card required for free plan.",
                  textAlign: TextAlign.center,
                  style: Utils.getTextStyle(
                    baseSize: 12,
                    isBold: false,
                    color: Colors.grey[500]!,
                    isUrdu: controller.isUrdu,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBillingToggle() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Monthly Billing",
            style: Utils.getTextStyle(
              baseSize: 14,
              isBold: !controller.isYearlyBilling.value,
              color: controller.isYearlyBilling.value
                  ? Colors.grey
                  : const Color(0xFF1E2E4B),
              isUrdu: controller.isUrdu,
            ),
          ),
          const SizedBox(width: 10),
          Switch(
            value: controller.isYearlyBilling.value,
            onChanged: (value) => controller.toggleBilling(value),
            activeColor: const Color(0xFF2ECC71),
          ),
          const SizedBox(width: 10),
          Text(
            "Yearly Billing",
            style: Utils.getTextStyle(
              baseSize: 14,
              isBold: controller.isYearlyBilling.value,
              color: controller.isYearlyBilling.value
                  ? const Color(0xFF3498DB)
                  : Colors.grey,
              isUrdu: controller.isUrdu,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF2ECC71).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Save 20%",
              style: Utils.getTextStyle(
                baseSize: 10,
                isBold: true,
                color: const Color(0xFF2ECC71),
                isUrdu: controller.isUrdu,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    String? priceSuffix,
    required String description,
    required String buttonText,
    required Color buttonColor,
    required List<dynamic> features,
    bool isHighlighted = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isHighlighted
            ? Border.all(color: const Color(0xFF3498DB), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Utils.getTextStyle(
              baseSize: 22,
              isBold: true,
              color: const Color(0xFF1E2E4B),
              isUrdu: controller.isUrdu,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                price,
                style: Utils.getTextStyle(
                  baseSize: 32,
                  isBold: true,
                  color: const Color(0xFF1E2E4B),
                  isUrdu: controller.isUrdu,
                ),
              ),
              if (priceSuffix != null)
                Text(
                  priceSuffix,
                  style: Utils.getTextStyle(
                    baseSize: 14,
                    isBold: false,
                    color: Colors.grey[500]!,
                    isUrdu: controller.isUrdu,
                  ),
                )
              else
                Text(
                  "/year",
                  style: Utils.getTextStyle(
                    baseSize: 14,
                    isBold: false,
                    color: Colors.grey[500]!,
                    isUrdu: controller.isUrdu,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Utils.getTextStyle(
              baseSize: 13,
              isBold: false,
              color: Colors.grey[600]!,
              isUrdu: controller.isUrdu,
            ),
          ),
          const SizedBox(height: 24),
          ...features.map((feature) {
            bool isIncluded = true;
            String text = "";
            if (feature is String) {
              text = feature;
            } else if (feature is Map) {
              text = feature.keys.first;
              isIncluded = feature.values.first;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(
                    isIncluded ? Icons.check : Icons.close,
                    size: 18,
                    color: isIncluded
                        ? const Color(0xFF2ECC71)
                        : Colors.red[400],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: Utils.getTextStyle(
                        baseSize: 14,
                        isBold: false,
                        color: Colors.grey[700]!,
                        isUrdu: controller.isUrdu,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                buttonText,
                style: Utils.getTextStyle(
                  baseSize: 16,
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
