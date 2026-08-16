import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/mechanics_bloc/mechanics_bloc.dart';
import 'package:paperwings/bloc/mechanics_bloc/mechanics_event.dart';
import 'package:paperwings/bloc/mechanics_bloc/mechanics_state.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/pages/connect.dart';
import 'package:paperwings/widgets/icon_circle.dart';

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
        }
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
                  style: AppTheme.heading3,
                ),
                const SizedBox(height: AppSpacing.spacingLg),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: AppSpacing.spacingSm,
                        left: AppSpacing.spacingSm,
                        right: AppSpacing.spacingSm),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final page = state.categories[index];
                        return ListTile(
                          leading: IconCircle(icon: page.icon),
                          title: Text(
                            page.title,
                            style: AppTheme.heading3,
                          ),
                          subtitle: Text(
                            page.description,
                            style: AppTheme.bodyMedium,
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: AppTheme.textTertiary,
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
