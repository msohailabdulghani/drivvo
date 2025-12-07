import 'package:drivvo/custom-widget/common/custom_app_bar.dart';
import 'package:drivvo/modules/reports/reports_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        name: "reports".tr,
        isUrdu: controller.isUrdu,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.filter_list_alt, color: Color(0xFF00796B)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(
                width: double.maxFinite,
                height: 40,
                child: ListView.builder(
                  itemCount: controller.list.length,
                  scrollDirection: Axis.horizontal,
                  primary: true,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  itemBuilder: (_, index) {
                    final model = controller.list[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Obx(
                        () => ChoiceChip(
                          label: Text(
                            model.tr,
                            style: TextStyle(
                              fontFamily: "D-FONT-R",
                              fontSize: 15,
                              color: controller.selectedName.value == model
                                  ? Colors.white
                                  : Colors.black,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          visualDensity: VisualDensity.compact,
                          selected: controller.selectedName.value == model,
                          onSelected: (bool selected) {
                            if (selected) {
                              controller.selectedName(model);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // --- DATE CARD ---
              Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2F1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(Icons.tune, color: Colors.teal),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "2025-09-05 - 2025-12-05",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --- COST CARD ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2F1), // Light teal
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.tune,
                            color: Colors.teal,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Cost",
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text("Total", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    const Text(
                      "\$0.00",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSummaryItem("By day", "\$0.00"),
                        _buildSummaryItem("By km", "\$0.00"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --- CHARTS CARD ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Charts",
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "View All",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Select", style: TextStyle(color: Colors.grey)),
                          Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
      border: Border.all(color: Colors.grey.shade200),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
