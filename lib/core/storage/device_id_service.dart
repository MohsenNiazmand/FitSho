import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:fitsho/core/constants/storage_keys.dart';

class DeviceIdService {
  DeviceIdService(this._storage);

  final FlutterSecureStorage _storage;
  static const _uuid = Uuid();

  Future<String> getDeviceId() async {
    final existing = await _storage.read(key: StorageKeys.deviceId);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final deviceId = _uuid.v4();
    await _storage.write(key: StorageKeys.deviceId, value: deviceId);
    return deviceId;
  }
}
