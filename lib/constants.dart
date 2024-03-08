const APP_NAME = "nibblechange";

enum StorageKeys {
  accessToken("ACCESSTOKEN");

  final String value;

  const StorageKeys(this.value);

  @override
  String toString() => value;
}
