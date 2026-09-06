import 'package:flutter/material.dart';
import 'package:paperwings/clients/plane_transport.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/models/plane_transport_option.dart';
import 'package:paperwings/widgets/full_width_button.dart';
import 'package:paperwings/widgets/instruction_item.dart';

class Disconnected extends StatefulWidget {
  final ValueChanged<PlaneTransport> onConnect;

  const Disconnected({super.key, required this.onConnect});

  @override
  State<Disconnected> createState() => _DisconnectedState();
}

class _DisconnectedState extends State<Disconnected> {
  PlaneTransport _selected = PlaneTransport.wifi;

  // Solo se muestran las opciones habilitadas (mock solo en debug).
  List<PlaneTransportOption> get _options => [
        for (final option in PlaneTransportOption.all)
          if (option.enabled) option,
      ];

  PlaneTransportOption get _selectedOption =>
      _options.firstWhere((option) => option.transport == _selected);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _selectedOption.icon,
                  size: 80.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Disconnected',
                  style: AppTheme.heading1,
                ),
                const SizedBox(height: 24),
                SegmentedButton<PlaneTransport>(
                  showSelectedIcon: false,
                  segments: _options
                      .map((option) => ButtonSegment(
                            value: option.transport,
                            icon: Icon(option.icon, size: 18),
                            label: Text(option.label),
                          ))
                      .toList(),
                  selected: {_selected},
                  onSelectionChanged: (selection) {
                    setState(() {
                      _selected = selection.first;
                    });
                  },
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: AppTheme.buttonColor,
                    selectedForegroundColor: Colors.white,
                    backgroundColor:
                        AppTheme.buttonColor.withValues(alpha: 0.3),
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white24),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Suggestions:',
                        style: AppTheme.heading3,
                      ),
                      const SizedBox(height: 16),
                      ..._selectedOption.instructions
                          .map((text) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: InstructionItem(text: text),
                              )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: AppSpacing.pagePadding,
          child: FullWidthButton(
            label: 'CONNECT',
            onPressed: () => widget.onConnect(_selected),
          ),
        ),
      ],
    );
  }
}