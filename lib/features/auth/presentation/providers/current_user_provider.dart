import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitsho/shared/domain/entities/user.dart';

part 'current_user_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  User? build() => null;

  void updateUser(User user) {
    state = user;
  }

  void clear() {
    state = null;
  }
}
