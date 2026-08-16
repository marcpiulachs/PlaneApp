import 'dart:async';
import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';

enum ThrottleState { locked, unlocked, armed }

class Throttle extends StatefulWidget {
  final double iconSize; // Tamaño del icono
  final void Function(ThrottleState) onStateChanged;
  final void Function(double) onThrottleUpdated;

  const Throttle({
    super.key,
    this.iconSize = 80, // Tamaño del icono por defecto
    required this.onStateChanged,
    required this.onThrottleUpdated,
  });

  @override
  State<Throttle> createState() => _ThrottleState();
}

class _ThrottleState extends State<Throttle>
    with SingleTickerProviderStateMixin {
  late double _dragPosition;
  late double _maxDrag;
  ThrottleState _swipeState = ThrottleState.locked;
  late AnimationController _animationController;
  Timer? _armedTimer;

  @override
  void initState() {
    super.initState();
    _dragPosition = 0.0;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animationController.addListener(() {
      setState(() {
        _dragPosition = _animationController.value * _maxDrag;
      });
    });
  }

  void _startArmedTimer() {
    _armedTimer?.cancel();
    _armedTimer = Timer(const Duration(seconds: 5), () {
      if (_swipeState == ThrottleState.armed) {
        _resetToLocked();
      }
    });
  }

  void _cancelArmedTimer() {
    _armedTimer?.cancel();
  }

  void _updateState(ThrottleState newState) {
    setState(() {
      _swipeState = newState;
    });
    widget.onStateChanged(_swipeState); // Notificar el cambio de estado
  }

  void _resetToLocked() {
    _updateState(ThrottleState.locked);
    _animationController.reverse(from: _dragPosition / _maxDrag);
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition -= details.delta.dy;
      if (_dragPosition < 0) _dragPosition = 0;
      if (_dragPosition > _maxDrag) _dragPosition = _maxDrag;
    });

    if (_swipeState == ThrottleState.locked && _dragPosition >= _maxDrag) {
      _updateState(ThrottleState.unlocked);
    }

    if (_swipeState == ThrottleState.armed) {
      _cancelArmedTimer(); // Cancela el temporizador en estado armed al arrastrar
      double value = (_dragPosition / _maxDrag) * 100;
      widget.onThrottleUpdated(value); // Notificar actualización del throttle
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_swipeState == ThrottleState.unlocked) {
      // Cambia a armed y vuelve a la posición inicial
      _animationController.reverse(from: _dragPosition / _maxDrag).then((_) {
        _updateState(ThrottleState.armed);
        _startArmedTimer(); // Inicia el temporizador de 5 segundos en estado armed
      });
    } else if (_swipeState == ThrottleState.locked) {
      // Si está en estado locked y se suelta, regresa al estado locked con animación
      _resetToLocked();
    } else if (_swipeState == ThrottleState.armed) {
      // Si está en estado armed y se suelta, regresa al estado locked con animación
      _resetToLocked();
      // Nos aseguramos de resetear el throttle a 0
      widget.onThrottleUpdated(0);
    }
  }

  Color _getBackgroundColor() {
    switch (_swipeState) {
      case ThrottleState.locked:
        return AppTheme.error;
      case ThrottleState.unlocked:
        return AppTheme.warning;
      case ThrottleState.armed:
        return AppTheme.success;
    }
  }

  String _getStateLabel() {
    switch (_swipeState) {
      case ThrottleState.locked:
        return 'LOCKED';
      case ThrottleState.unlocked:
        return 'SLIDE UP';
      case ThrottleState.armed:
        return 'ARMED';
    }
  }

  IconData _getIcon() {
    switch (_swipeState) {
      case ThrottleState.locked:
        return Icons.lock;
      case ThrottleState.unlocked:
        return Icons.lock_open;
      case ThrottleState.armed:
        return Icons.airplanemode_active;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateColor = _getBackgroundColor();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF5A5A62),
                      AppTheme.instrumentBezel,
                      Color(0xFF1C1C20),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.black45, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calcula el drag máximo según el tamaño del icono y el tamaño disponible
                    _maxDrag = constraints.maxHeight - widget.iconSize;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(19),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Pista oscura
                          Container(
                            width: widget.iconSize,
                            height: constraints.maxHeight,
                            color: AppTheme.instrumentFace,
                          ),
                          // Indicadores de dirección de la pista
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Icon(Icons.keyboard_arrow_up,
                                      color: Colors.white24, size: 18),
                                  Icon(Icons.keyboard_arrow_down,
                                      color: Colors.white24, size: 18),
                                ],
                              ),
                            ),
                          ),
                          // Palanca del throttle
                          Positioned(
                            bottom: _dragPosition,
                            child: Container(
                              width: widget.iconSize,
                              height: widget.iconSize,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.lerp(stateColor, Colors.white, 0.25)!,
                                    stateColor,
                                    Color.lerp(stateColor, Colors.black, 0.3)!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(22),
                                border:
                                    Border.all(color: Colors.white24, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: stateColor.withValues(alpha: 0.5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(_getIcon(),
                                  color: Colors.white, size: 36),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _getStateLabel(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _armedTimer?.cancel();
    super.dispose();
  }
}
