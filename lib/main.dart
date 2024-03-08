import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nibblechange/constants.dart';
import 'package:nibblechange/global_handler.dart';
import 'package:nibblechange/routes/Home.dart';
import 'package:nibblechange/routes/Login.dart';
import 'package:provider/provider.dart';

/// Initialize secure storage
AndroidOptions _getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
final secureStorage = FlutterSecureStorage(aOptions: _getAndroidOptions());

ColorScheme defaultScheme({bool isDark = false}) {
  return ColorScheme.fromSeed(
    seedColor: const Color.fromRGBO(254, 215, 69, 255),
    secondary: const Color.fromRGBO(59, 209, 130, 255),
    onSecondary: const Color.fromRGBO(217, 232, 247, 255),
    brightness: isDark ? Brightness.dark : Brightness.light,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final accessToken = await secureStorage.read(key: "$StorageKeys.accessToken");

  final router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const Home(),
      ),
      GoRoute(
        path: "/login",
        builder: (context, state) => const Login(),
      ),
    ],
    initialLocation: accessToken == null || accessToken.isEmpty ? "/login" : "/",
  );

  runApp(NibbleChangeApp(router: router, accessToken: accessToken));
}

class NibbleChangeApp extends StatelessWidget {
  final GoRouter router;
  final String? accessToken;

  const NibbleChangeApp({
    super.key,
    required this.router,
    required this.accessToken,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalHandler()),
      ],
      child: DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          ColorScheme lightColorScheme;
          ColorScheme darkColorScheme;

          if (lightDynamic != null && darkDynamic != null) {
            // On Android S+ devices, use the provided dynamic color scheme.
            // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
            lightColorScheme = lightDynamic.harmonized();

            // Repeat for the dark color scheme.
            darkColorScheme = darkDynamic.harmonized();
          } else {
            // Otherwise, use fallback schemes.
            lightColorScheme = ColorScheme.fromSeed(
              seedColor: defaultScheme().primary,
            );
            darkColorScheme = ColorScheme.fromSeed(
              seedColor: defaultScheme(isDark: true).primary,
              brightness: Brightness.dark,
            );
          }
          return MaterialApp.router(
            title: APP_NAME,
            themeMode: ThemeMode.system,
            routerConfig: router,
            theme: ThemeData(
              colorScheme: lightColorScheme,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: darkColorScheme,
              useMaterial3: true,
            ),
          );
        },
      ),
    );
  }
}
