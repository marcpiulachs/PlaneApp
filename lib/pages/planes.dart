import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_3d/bloc/plane_carousel_bloc/plane_carousel_bloc.dart';
import 'package:object_3d/bloc/plane_carousel_bloc/plane_carousel_event.dart';
import 'package:object_3d/bloc/plane_carousel_bloc/plane_carousel_state.dart';
import 'package:object_3d/models/plane_item.dart';
import 'package:object_3d/widgets/circular.dart';
import 'package:object_3d/widgets/plane_carousel.dart';

// Define the ImageCarousel widget
class PlaneCarousel extends StatelessWidget {
  final PageController _pageController = PageController();

  PlaneCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recuperar el Bloc desde el contexto
    final planeCarouselBloc = BlocProvider.of<PlaneCarouselBloc>(context);

    return BlocBuilder<PlaneCarouselBloc, PlaneCarouselState>(
      bloc: planeCarouselBloc,
      builder: (context, state) {
        if (state is PlaneCarouselInitial) {
          // Al cargar el widget, llamar al evento para cargar los aviones
          planeCarouselBloc.add(LoadPlanesEvent());
          return const Center(child: CircularProgressIndicator());
        } else if (state is PlaneCarouselLoaded) {
          return Column(
            children: [
              Center(
                child: Container(
                  child: Center(
                    child: const Text(
                      "Choose your aircraft",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PlaneCarouselWidget(
                  planeItems: state.planeItems,
                  pageController: _pageController,
                  onPageChanged: (index) {
                    planeCarouselBloc.add(PlaneSelectedEvent(index));
                  },
                  currentIndex: state.currentIndex,
                ),
              ),
              _buildIndicators(state),
              const SizedBox(height: 10),
              _buildGoFlyButton(),
            ],
          );
        } else if (state is PlaneCarouselLoadFailed) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          return const Center(child: Text("Unexpected state."));
        }
      },
    );
  }

  Widget _buildGoFlyButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: () {
          // Add your action here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: const Text(
          'GO FLY!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildIndicators(PlaneCarouselLoaded state) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Text(
            "FEATURES",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressBar(
                progress: state.selectedPlane.progress1,
                icon: Icons.support,
                text: "Easy",
                backgroundColor: Colors.white,
                size: 100.0,
              ),
              const SizedBox(width: 16),
              CircularProgressBar(
                progress: state.selectedPlane.progress2,
                icon: Icons.airplane_ticket,
                text: "Expertise",
                backgroundColor: Colors.white,
                size: 100.0,
              ),
              const SizedBox(width: 16),
              CircularProgressBar(
                progress: state.selectedPlane.progress3,
                icon: Icons.timer,
                text: "Range",
                backgroundColor: Colors.white,
                size: 100.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Define the MyApp widget
class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Carousel App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.black, // Set background color of the Scaffold
        body: PlaneCarousel(),
      ),
    );
  }
}
