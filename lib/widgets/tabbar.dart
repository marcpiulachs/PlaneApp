// Widget reutilizable
import 'package:flutter/material.dart';
import 'package:object_3d/models/menu_item.dart';

class AnimatedTabBar extends StatelessWidget {
  final TabController tabController;
  final List<MenuItem> menuItems;
  final Function(int) onTabSelected;

  const AnimatedTabBar({
    super.key,
    required this.tabController,
    required this.menuItems,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        AnimatedBuilder(
          animation: tabController.animation!,
          builder: (context, child) {
            double animationValue = tabController.animation!.value;
            double tabWidth =
                MediaQuery.of(context).size.width / menuItems.length;

            return Positioned(
              left: tabWidth * animationValue +
                  (tabWidth / 2 - 30), // Ajuste centrado
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              ),
            );
          },
        ),
        TabBar(
          controller: tabController,
          dividerColor: Colors.transparent,
          tabs: menuItems.map((icon) => _buildTab(icon.icon)).toList(),
          indicator: const BoxDecoration(color: Colors.transparent),
          onTap: onTabSelected,
        ),
      ],
    );
  }

  Widget _buildTab(IconData icon) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Center(
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
