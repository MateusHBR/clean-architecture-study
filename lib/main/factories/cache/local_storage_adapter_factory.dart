import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../infra/cache/cache.dart';

SecureLocalStorageAdapter makeSecureLocalStorageAdapter() {
  final secureStorage = FlutterSecureStorage();

  return SecureLocalStorageAdapter(
    secureStorage: secureStorage,
  );
}
