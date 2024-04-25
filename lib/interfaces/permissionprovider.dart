import 'package:permission_handler/permission_handler.dart';

abstract class PermissionProvider {
  Future<void> request(List<Permission> permissions);
}
