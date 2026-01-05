import 'package:drivvo/model/timeline_entry.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeListItems extends StatelessWidget {
  final bool isUrdu;
  final bool isLoading;
  final Future<void> Function() onTapRefresh;
  final List<TimelineEntry> allEntries;
  final Map<String, List<TimelineEntry>> groupedEntries;
  final bool Function(String) isEntryExpanded;
  final void Function(String) toggleEntryExpansion;
  final String selectedCurrencySymbol;
  final void Function(TimelineEntry) onTapEdit;
  final void Function(TimelineEntry) onTapdelete;

  const HomeListItems({
    super.key,
    required this.isUrdu,
    required this.isLoading,
    required this.onTapRefresh,
    required this.allEntries,
    required this.groupedEntries,
    required this.isEntryExpanded,
    required this.toggleEntryExpansion,
    required this.selectedCurrencySymbol,
    required this.onTapEdit,
    required this.onTapdelete,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Utils.appColor),
      );
    }

    return RefreshIndicator(
      onRefresh: () => onTapRefresh(),
      color: Utils.appColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Build timeline entries grouped by month
          if (allEntries.isNotEmpty)
            ...groupedEntries.entries.map((monthGroup) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 56,
                      top: 20,
                      bottom: 8,
                    ),
                    child: Text(
                      monthGroup.key,
                      style: Utils.getTextStyle(
                        baseSize: 12,
                        isBold: true,
                        color: Colors.grey[500]!,
                        isUrdu: isUrdu,
                      ),
                    ),
                  ),
                  ...monthGroup.value.asMap().entries.map((entry) {
                    final index = entry.key;
                    final timelineEntry = entry.value;
                    final isLastInGroup = index == monthGroup.value.length - 1;
                    final isLastMonth =
                        monthGroup.key == groupedEntries.keys.last;
                    final isLastOverall = isLastMonth && isLastInGroup;

                    // Create a unique key for this entry
                    final entryKey = '${monthGroup.key}_$index';

                    return Column(
                      children: [
                        _buildTimelineItem(
                          entry: timelineEntry,
                          isLast: isLastOverall,
                          entryKey: entryKey,
                        ),
                        //! TimelineConnector
                        Row(
                          children: [
                            SizedBox(
                              width: 44,
                              child: Center(
                                child: Container(
                                  width: 3,
                                  height: 16,
                                  color: const Color(0xFF424242),
                                ),
                              ),
                            ),
                            const Expanded(child: SizedBox.shrink()),
                          ],
                        ),
                      ],
                    );
                  }),
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required TimelineEntry entry,
    required bool isLast,
    required String entryKey,
  }) {
    return Obx(() {
      final isExpanded = isEntryExpanded(entryKey);

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Line and Dot - using Stack to handle variable height
          SizedBox(
            width: 44,
            child: Column(
              children: [
                // Line above dot
                Container(width: 3, height: 20, color: const Color(0xFF424242)),
                // Dot
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: entry.iconBgColor,
                    borderRadius: BorderRadius.circular(120),
                  ),
                  child: Icon(entry.icon, color: Colors.white, size: 22),
                ),
              ],
            ),
          ),
          // Content Card
          Expanded(
            child: GestureDetector(
              onTap: () => toggleEntryExpansion(entryKey),
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(right: 10, left: 10, bottom: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: isExpanded
                        ? entry.iconBgColor
                        : Colors.grey.shade400,
                    width: isExpanded ? 1.5 : 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Main content row (always visible)
                    Row(
                      children: [
                        // Title and Odometer
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                entry.title,
                                style: Utils.getTextStyle(
                                  baseSize: 15,
                                  isBold: true,
                                  color: Colors.black87,
                                  isUrdu: isUrdu,
                                ),
                              ),
                              const SizedBox(height: 2),
                              entry.origin != null
                                  ? Text(
                                      "From: ${entry.origin!}",
                                      style: Utils.getTextStyle(
                                        baseSize: 12,
                                        isBold: false,
                                        color: Colors.grey[500]!,
                                        isUrdu: isUrdu,
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        Icon(
                                          Icons.speed,
                                          color: Colors.grey[500],
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${entry.odometer} km',
                                          style: Utils.getTextStyle(
                                            baseSize: 12,
                                            isBold: false,
                                            color: Colors.grey[500]!,
                                            isUrdu: isUrdu,
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                        // Date and Amount
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                entry.origin != null
                                    ? Text(
                                        "${entry.routeStartFormattedDate} - ${entry.routeEndFormattedDate}",
                                        style: Utils.getTextStyle(
                                          baseSize: 12,
                                          isBold: false,
                                          color: Colors.grey[500]!,
                                          isUrdu: isUrdu,
                                        ),
                                      )
                                    : Text(
                                        entry.formattedDate,
                                        style: Utils.getTextStyle(
                                          baseSize: 12,
                                          isBold: false,
                                          color: Colors.grey[500]!,
                                          isUrdu: isUrdu,
                                        ),
                                      ),
                                const SizedBox(width: 6),
                                AnimatedRotation(
                                  turns: isExpanded ? 0.5 : 0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 22,
                                    color: isExpanded
                                        ? entry.iconBgColor
                                        : Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            entry.origin != null
                                ? SizedBox(height: 14)
                                : Text(
                                    "$selectedCurrencySymbol ${entry.amount}",
                                    style: Utils.getTextStyle(
                                      baseSize: 14,
                                      isBold: true,
                                      color: entry.isIncome
                                          ? Utils.appColor
                                          : Colors.black87,
                                      isUrdu: isUrdu,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                    // Expanded content section - only show when expanded
                    if (isExpanded)
                      //!Expanded Content
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.only(right: 12, left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Entry type
                            _buildExpandedRow(
                              icon: entry.icon,
                              iconColor: entry.iconBgColor,
                              label: 'type'.tr.isNotEmpty ? 'type'.tr : 'Type',
                              value: entry.type.name,
                            ),
                            const SizedBox(height: 8),
                            // Full date
                            // _buildExpandedRow(
                            //   icon: Icons.calendar_today,
                            //   iconColor: Colors.blue,
                            //   label: 'date'.tr.isNotEmpty ? 'date'.tr : 'Date',
                            //   value: Utils.formatDate(date: entry.date),
                            // ),
                            // const SizedBox(height: 8),
                            // Odometer
                            _buildExpandedRow(
                              icon: Icons.speed,
                              iconColor: Colors.orange,
                              label: 'odometer'.tr.isNotEmpty
                                  ? 'odometer'.tr
                                  : 'Odometer',
                              value: entry.origin != null
                                  ? '${entry.routeOdometer} km'
                                  : '${entry.odometer} km',
                            ),
                            const SizedBox(height: 8),
                            // Amount
                            _buildExpandedRow(
                              icon: entry.isIncome
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              iconColor: entry.isIncome
                                  ? Colors.green
                                  : Colors.red,
                              label: entry.isIncome ? 'income'.tr : 'amount'.tr,
                              value: "$selectedCurrencySymbol ${entry.amount}",
                              valueColor: entry.isIncome
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(height: 8),
                            Divider(height: 1, color: Colors.grey.shade300),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Material(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  child: InkWell(
                                    onTap: () => Utils.showAlertDialog(
                                      confirmMsg: "are_you_sure_delete".tr,
                                      onTapYes: () => onTapdelete(entry),
                                      isUrdu: isUrdu,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8,
                                        top: 8,
                                      ),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                Material(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  child: InkWell(
                                    onTap: () => onTapEdit(entry),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8,
                                        top: 8,
                                      ),
                                      child: Icon(
                                        Icons.edit_note_outlined,
                                        color: Utils.appColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildExpandedRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: Utils.getTextStyle(
              baseSize: 13,
              isBold: false,
              color: Colors.grey[600]!,
              isUrdu: isUrdu,
            ),
          ),
        ),
        Text(
          value,
          style: Utils.getTextStyle(
            baseSize: 13,
            isBold: false,
            color: valueColor ?? Colors.black,
            isUrdu: isUrdu,
          ),
        ),
      ],
    );
  }
}
