import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/mechanics_bloc/mechanics_bloc.dart';
import 'package:paperwings/bloc/mechanics_bloc/mechanics_event.dart';
import 'package:paperwings/bloc/mechanics_bloc/mechanics_state.dart';
import 'package:paperwings/pages/connect.dart';

class Mechanics extends StatefulWidget {
  const Mechanics({super.key});

  @override
  State<Mechanics> createState() => _MechanicsState();
}

class _MechanicsState extends State<Mechanics> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // Verifica si está en una página seleccionada o en la pantalla principal de Mechanics
        final bloc = BlocProvider.of<MechanicsBloc>(context);
        if (bloc.state is SettingsPageSelectedState) {
          // Si estamos en una página interna, vuelve al estado inicial
          bloc.add(BackToMainSettingsEvent());
          //return false; // Evita que el botón de retroceso cierre la pantalla
        }
        //return true; // Permite salir si está en la pantalla principal de Mechanics
      },
      child: BlocBuilder<MechanicsBloc, MechanicsState>(
        builder: (context, state) {
          if (state is MechanicsInitialState) {
            return const Center();
          } else if (state is SettingsLoadedState) {
            return Column(
              children: [
                const Text(
                  "Fine tune your plane",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final page = state.categories[index];
                        return ListTile(
                          leading: Container(
                            width: 40, // Tamaño del círculo
                            height: 40,
                            decoration: const BoxDecoration(
                              color:
                                  Colors.black, // Fondo negro para el círculo
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              page.icon,
                              color:
                                  Colors.white, // Ícono blanco para contraste
                              size: 24,
                            ),
                          ),
                          title: Text(
                            page.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            page.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.black,
                          ),
                          onTap: () {
                            BlocProvider.of<MechanicsBloc>(context)
                                .add(SelectSettingsPageEvent(page));
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is SettingsPageSelectedState) {
            return state.selectedPage.page;
          } else if (state is MechanicsPlaneDisconectedState) {
            return const Connect();
          } else if (state is MechanicsErrorState) {
            return const Center();
          }
          return const Center();
        },
      ),
    );
  }
}
