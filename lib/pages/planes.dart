import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/home_bloc/home_bloc.dart';
import 'package:paperwings/bloc/home_bloc/home_event.dart';
import 'package:paperwings/bloc/plane_carousel_bloc/plane_carousel_bloc.dart';
import 'package:paperwings/bloc/plane_carousel_bloc/plane_carousel_event.dart';
import 'package:paperwings/bloc/plane_carousel_bloc/plane_carousel_state.dart';
import 'package:paperwings/pages/widgets/connected_indicator.dart';
import 'package:paperwings/pages/widgets/plane_indicators.dart';
import 'package:paperwings/widgets/plane_carousel.dart';

class Planes extends StatefulWidget {
  const Planes({super.key});

  @override
  State<Planes> createState() => _PlanesState();
}

class _PlanesState extends State<Planes> {
  final PageController _pageController = PageController();
  late PlaneCarouselBloc planeCarouselBloc;

  @override
  void initState() {
    super.initState(); // Recuperar el Bloc desde el contexto
    planeCarouselBloc = BlocProvider.of<PlaneCarouselBloc>(context);
    planeCarouselBloc.add(LoadPlanesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaneCarouselBloc, PlaneCarouselState>(
      bloc: planeCarouselBloc,
      builder: (context, state) {
        if (state is PlaneCarouselInitial) {
          return const Center();
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
                  planeItems: state.planes,
                  pageController: _pageController,
                  onPageChanged: (index) {
                    planeCarouselBloc.add(PlaneSelectionChangedEvent(index));
                  },
                  currentIndex: state.currentIndex,
                ),
              ),
              ConnectedIndicator(isConnected: state.isConnected),
              const SizedBox(height: 10),
              PlaneIndicators(plane: state.selectedPlane),
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
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () {
          // Envía un evento para cambiar el tab activo a "COPKIT"
          context.read<HomeBloc>().add(const HomeTabChangedEvent(1));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text('GO FLY!'),
      ),
    );
  }
}
