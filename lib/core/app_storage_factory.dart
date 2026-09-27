import 'app_storage.dart';
import 'app_storage_factory_io.dart'
    if (dart.library.js_interop) 'app_storage_factory_web.dart' as platform;

/// SQLite on Android/iOS/desktop, key-value storage on the web where sqflite
/// has no implementation.
AppStorage createAppStorage() => platform.createAppStorage();
