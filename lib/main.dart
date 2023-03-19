import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:sample/dialogs/dialog_auth_error.dart';
import 'package:sample/firebase_options.dart';
import 'package:sample/loading/loading_screen.dart';
import 'package:sample/screens/login_screen.dart';
import 'package:sample/screens/register_screen.dart';
import 'package:sample/screens/reminders_screen.dart';
import 'package:sample/state/app_state.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Provider(
    create: (_) =>
      AppState()..initialize(),
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      debugShowCheckedModeBanner: false,
      home: ReactionBuilder(
          builder: (context){
            return autorun((_){
              //handling the loading screen
              final isLoading = context.read<AppState>().isLoading;
              if(isLoading){
                LoadingScreen.instance()
                    .show(context: context, text: 'Loading....');
              }else{
                LoadingScreen.instance().hide();
              }
              final authError = context.read<AppState>().authError;
              if (authError != null) {
                showAuthError(authError: authError, context: context);
              }
            });
          },
          child: Observer(
            name: "currentScreen",
            builder: (context){
              switch (context.read<AppState>().currentScreen){
                case AppScreen.login:
                  return const LoginScreen();
                case AppScreen.register:
                  return const RegistrationScreen();
                case AppScreen.reminders:
                  return const RemindersScreen();
              }
            },
          ),
      ),
    );
  }
}
