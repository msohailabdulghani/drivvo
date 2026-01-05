import 'package:circular_menu/circular_menu.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';

class HomeAddBtn extends StatelessWidget {
  final GlobalKey<CircularMenuState> circularMenuKey;
  final VoidCallback onTapRefueling;
  final VoidCallback onTapExpense;
  final VoidCallback onTapService;
  final VoidCallback onTapIncome;
  final VoidCallback onTapRoute;

  const HomeAddBtn({
    super.key,
    required this.circularMenuKey,
    required this.onTapRefueling,
    required this.onTapExpense,
    required this.onTapService,
    required this.onTapIncome,
    required this.onTapRoute,
  });

  @override
  Widget build(BuildContext context) {
    return CircularMenu(
      key: circularMenuKey,
      alignment: Alignment.bottomRight,
      curve: Curves.bounceOut,
      reverseCurve: Curves.bounceIn,
      animationDuration: Duration.zero,
      toggleButtonColor: Utils.appColor,
      toggleButtonIconColor: Colors.white,
      toggleButtonSize: 30.0,
      toggleButtonPadding: 10.0,
      toggleButtonMargin: 0.0,
      radius: 130,
      toggleButtonBoxShadow: [],
      items: [
        CircularMenuItem(
          iconSize: 20,
          icon: Icons.local_gas_station_outlined,
          color: const Color(0xFFFB9601),
          boxShadow: [],
          onTap: () => onTapRefueling(),
        ),
        CircularMenuItem(
          iconSize: 20,
          icon: Icons.receipt_long_outlined,
          color: Colors.red,
          boxShadow: [],
          onTap: () => onTapExpense(),
        ),
        CircularMenuItem(
          iconSize: 20,
          icon: Icons.build_outlined,
          color: Colors.brown,
          boxShadow: [],
          onTap: () => onTapService(),
        ),
        CircularMenuItem(
          iconSize: 20,
          icon: Icons.attach_money,
          color: Colors.green,
          boxShadow: [],
          onTap: () => onTapIncome(),
        ),
        CircularMenuItem(
          iconSize: 20,
          icon: Icons.route,
          color: const Color(0xFF5E7E8D),
          boxShadow: [],
          onTap: () => onTapRoute(),
        ),
      ],
    );
  }
}
