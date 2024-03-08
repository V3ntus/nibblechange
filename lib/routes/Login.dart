import 'package:flutter/material.dart';
import 'package:nibblechange/constants.dart';
import 'package:nibblechange/global_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final tokenController = TextEditingController();

  void tryLogin(String accessToken) async {
    final result = await Provider.of<GlobalHandler>(context, listen: false).login(accessToken);
    if (result["did_error"] && context.mounted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  /// True if the tokenController value is not empty
  bool isTokenFilled = false;

  /// True if attempting to log in
  bool isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.onPrimary,
              Theme.of(context).colorScheme.onSecondary,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.0),
          ),
        ),
        child: Center(
          child: Wrap(
            direction: Axis.vertical,
            spacing: 16,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                APP_NAME,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 48),
              ),
              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 240,
                    child: TextField(
                      controller: tokenController,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            isTokenFilled = false;
                          });
                        } else {
                          setState(() {
                            isTokenFilled = true;
                          });
                        }
                      },
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        hintText: "Token",
                      ),
                    ),
                  ),
                  IconButton.outlined(
                    onPressed: isTokenFilled
                        ? () async {
                            tryLogin(tokenController.text);
                            // await secureStorage.write(key: "${StorageKeys.accessToken}", value: tokenController.text);
                          }
                        : null,
                    icon: const Icon(
                      Icons.login_rounded,
                      size: 32,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => launchUrlString("https://my.lunchmoney.app/developers"),
                child: const Text("Register Token"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
