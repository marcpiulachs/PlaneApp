import 'package:equatable/equatable.dart';

class UserAction extends Equatable {
  final int yoke;
  final int throttle;

  const UserAction({
    this.yoke = 0,
    this.throttle = 0,
  });

  UserAction copyWith({
    int? yoke,
    int? throttle,
  }) {
    return UserAction(
      yoke: yoke ?? this.yoke,
      throttle: throttle ?? this.throttle,
    );
  }

  @override
  List<Object?> get props => [yoke, throttle];
}
