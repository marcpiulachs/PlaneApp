import 'package:flutter/material.dart';

class CarouselWidget extends StatefulWidget {
  final List<Widget> items; // Los widgets que contendrá el carrusel
  final double indicatorSize; // Tamaño de los puntos del indicador

  const CarouselWidget({
    required this.items,
    this.indicatorSize = 8.0,
    super.key,
  });

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // El PageView toma todo el espacio disponible
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return widget.items[index];
            },
          ),
        ),
        const SizedBox(height: 10),
        // Indicador de puntos
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.items.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: widget.indicatorSize,
              height: widget.indicatorSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Colors.black // Color activo
                    : Colors.grey, // Color inactivo
              ),
            );
          }),
        ),
        const SizedBox(height: 10), // Espacio para el indicador
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
