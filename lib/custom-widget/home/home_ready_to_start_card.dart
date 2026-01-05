import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeReadyToStartCard extends StatelessWidget {
  final bool isUrdu;
  final String initialSelection;
  final Function(String label) onTap;

  const HomeReadyToStartCard({
    super.key,
    required this.isUrdu,
    required this.initialSelection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Utils.appColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.rocket_launch_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ready_to_start'.tr,
                    style: Utils.getTextStyle(
                      baseSize: 17,
                      isBold: true,
                      color: Colors.black87,
                      isUrdu: isUrdu,
                    ),
                  ),
                  Text(
                    'add_your_first_entry'.tr,
                    style: Utils.getTextStyle(
                      baseSize: 13,
                      isBold: false,
                      color: Colors.grey[600]!,
                      isUrdu: isUrdu,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Action Buttons Row
          Row(
            children: [
              _buildActionButton(
                // icon: Icons.local_gas_station_outlined,
                image: "assets/images/more/fuel.png",
                label: 'fuel'.tr,
                isSelected: initialSelection == "Fuel" ? true : false,
              ),

              const SizedBox(width: 12),
              _buildActionButton(
                // icon: Icons.build_outlined,
                image: "assets/images/more/services.png",
                label: 'service'.tr,
                isSelected: initialSelection == "Service" ? true : false,
              ),

              const SizedBox(width: 12),
              _buildActionButton(
                // icon: Icons.receipt_long_outlined,
                image: "assets/images/more/expenses.png",
                label: 'expense'.tr,
                isSelected: initialSelection == "Expense" ? true : false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String image,
    required String label,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? Utils.appColor.withValues(alpha: 0.08)
                : Colors.grey[50],
            border: Border.all(
              color: isSelected ? Utils.appColor : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Image.asset(image, height: 36),
              const SizedBox(height: 8),
              Text(
                label,
                style: Utils.getTextStyle(
                  baseSize: 13,
                  isBold: isSelected,
                  color: isSelected ? Utils.appColor : Colors.grey[700]!,
                  isUrdu: isUrdu,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
