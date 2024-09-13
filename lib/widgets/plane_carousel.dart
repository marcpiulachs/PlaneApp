import 'package:flutter/material.dart';
import 'package:object_3d/models/plane_item.dart';

class PlaneCarouselWidget extends StatelessWidget {
  final List<PlaneItem> planeItems;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final int currentIndex;

  const PlaneCarouselWidget({
    Key? key,
    required this.planeItems,
    required this.pageController,
    required this.onPageChanged,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: pageController,
          itemCount: planeItems.length,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) {
            final item = planeItems[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.60,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        item.description,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        // Flechas de navegación centradas verticalmente
        Positioned(
          left: 10,
          top: 0,
          bottom: 0,
          child: Center(
            child: Visibility(
              visible: currentIndex > 0,
              child: IconButton(
                icon:
                    const Icon(Icons.arrow_left, color: Colors.white, size: 40),
                onPressed: () {
                  pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 0,
          bottom: 0,
          child: Center(
            child: Visibility(
              visible: currentIndex < planeItems.length - 1,
              child: IconButton(
                icon: const Icon(Icons.arrow_right,
                    color: Colors.white, size: 40),
                onPressed: () {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
