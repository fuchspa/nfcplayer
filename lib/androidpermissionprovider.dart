import 'package:nfcplayer/interfaces/permissionprovider.dart';
import 'package:permission_handler/permission_handler.dart';

class AndroidPermissionProvider extends PermissionProvider {
  @override
  Future<void> request(List<Permission> permissions) async {
    await permissions.request();
  }
}
