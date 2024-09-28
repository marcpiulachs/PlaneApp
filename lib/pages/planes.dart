import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_3d/bloc/home_bloc/home_bloc.dart';
import 'package:object_3d/bloc/home_bloc/home_event.dart';
import 'package:object_3d/bloc/plane_carousel_bloc/plane_carousel_bloc.dart';
import 'package:object_3d/bloc/plane_carousel_bloc/plane_carousel_event.dart';
import 'package:object_3d/bloc/plane_carousel_bloc/plane_carousel_state.dart';
import 'package:object_3d/widgets/circular.dart';
import 'package:object_3d/widgets/plane_carousel.dart';

class PlaneCarousel extends StatefulWidget {
  const PlaneCarousel({super.key});

  @override
  State<PlaneCarousel> createState() => _PlaneCarouselState();
}

class _PlaneCarouselState extends State<PlaneCarousel> {
  final PageController _pageController = PageController();
  late PlaneCarouselBloc planeCarouselBloc;
  @override
  void initState() {
    super.initState(); // Recuperar el Bloc desde el contexto
    planeCarouselBloc = BlocProvider.of<PlaneCarouselBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaneCarouselBloc, PlaneCarouselState>(
      bloc: planeCarouselBloc,
      builder: (context, state) {
        if (state is PlaneCarouselInitial) {
          planeCarouselBloc.add(LoadPlanesEvent());
          return const Center(child: CircularProgressIndicator());
        } else if (state is PlaneCarouselLoaded) {
          return Column(
            children: [
              const Center(
                child: Center(
                  child: Text(
                    "Choose your aircraft",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
              _buildConnectionStatus(state),
              const SizedBox(height: 10),
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
          // Envía un evento para cambiar el tab activo a "COPKIT"
          context.read<HomeBloc>().add(const HomeTabChangedEvent(1));
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

  Widget _buildConnectionStatus(PlaneCarouselLoaded state) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2), // Sombra hacia abajo
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              state.isConnected ? Icons.public : Icons.public_off,
              size: 18,
              color: Colors.black,
            ),
            const SizedBox(width: 8),
            Text(
              state.isConnected ? 'Connected' : 'Disconnected',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
                size: 90.0,
              ),
              const SizedBox(width: 16),
              CircularProgressBar(
                progress: state.selectedPlane.progress2,
                icon: Icons.airplane_ticket,
                text: "Expertise",
                backgroundColor: Colors.white,
                size: 90.0,
              ),
              const SizedBox(width: 16),
              CircularProgressBar(
                progress: state.selectedPlane.progress3,
                icon: Icons.timer,
                text: "Range",
                backgroundColor: Colors.white,
                size: 90.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
