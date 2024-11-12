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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<MechanicsBloc, MechanicsState>(
        builder: (context, state) {
          if (state is MechanicsInitialState) {
            return const Center();
          } else if (state is MechanicsLoadedVersionState) {
            return const Column(
              children: [
                Center(
                  child: Text(
                    "Fine tune your plane",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final category = state.categories[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                category.title,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            ...category.pages.map((page) {
                              return ListTile(
                                leading: Icon(
                                  page.icon,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: Text(page.title),
                                subtitle: Text(page.description),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  BlocProvider.of<MechanicsBloc>(context)
                                      .add(SelectSettingsPageEvent(page));
                                },
                              );
                            }),
                          ],
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
