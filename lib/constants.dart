const APP_NAME = "nibblechange";

enum StorageKeys {
  apiKey("APIKEY");

  final String value;

  const StorageKeys(this.value);

  @override
  String toString() => value;
}
