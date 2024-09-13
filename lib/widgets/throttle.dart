import 'dart:async';
import 'package:flutter/material.dart';

class MyApp4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Vertical Slider')),
        body: Center(
          child: Throttle(
            onStateChanged: (ThrottleState state) {
              print('Throttle state: ${state.toString()}');
            },
            onThrottleUpdated: (double value) {
              print('Armed throttle value: ${value.toInt()}');
            },
          ),
        ),
      ),
    );
  }
}

enum ThrottleState { locked, unlocked, armed }

class Throttle extends StatefulWidget {
  final double iconSize; // Tamaño del icono
  final void Function(ThrottleState)
      onStateChanged; // Callback para cambios de estado
  final void Function(double)
      onThrottleUpdated; // Callback para actualización del throttle

  const Throttle({
    super.key,
    this.iconSize = 80, // Tamaño del icono por defecto
    required this.onStateChanged,
    required this.onThrottleUpdated,
  });

  @override
  _ThrottleState createState() => _ThrottleState();
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
        return Colors.red;
      case ThrottleState.unlocked:
        return Colors.green;
      case ThrottleState.armed:
        return Colors.blue;
      default:
        return Colors.red;
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
      default:
        return Icons.lock;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black, // Fondo por defecto
            borderRadius: BorderRadius.circular(50), // Bordes redondeados
          ),
          padding:
              const EdgeInsets.all(4), // Padding entre el borde y el control
          child: LayoutBuilder(
            builder: (context, constraints) {
              _maxDrag = constraints.maxHeight -
                  widget
                      .iconSize; // Calcula el drag máximo según el tamaño del icono y el tamaño disponible

              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 80,
                    height: constraints.maxHeight,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  Positioned(
                    bottom: _dragPosition,
                    child: Container(
                      width: 80,
                      height: widget.iconSize, // Tamaño del control
                      decoration: BoxDecoration(
                        color: _getBackgroundColor(),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        _getIcon(),
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
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
