import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sample/extensions/if_debugging.dart';
import 'package:sample/state/app_state.dart';
import 'package:provider/provider.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(text:
      'githuawaweru@gmail.com'.ifDebugging
    );
    final passwordController = useTextEditingController(text:
      '@1Yqzaxsw#'.ifDebugging
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Please enter your email'
                  ),
                  keyboardType: TextInputType.emailAddress,
                  keyboardAppearance: Brightness.dark,
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Please input your password'
                  ),
                  obscureText: true,
                  obscuringCharacter: '#',
                  keyboardAppearance: Brightness.dark,
                ),
                /*login button*/
                Center(
                  child: ElevatedButton(
                      onPressed: (){
                        final email =  emailController.text;
                        final password = passwordController.text;
                        context.read<AppState>().login(email:email, password: password);
                      },
                      child: const Text('Log In')
                  ),
                ),
                /*Text button to navigate to register screen*/
                TextButton(
                    onPressed: (){
                      context.read<AppState>().goTo(AppScreen.register);
                    },
                    child: const Text('Don\'t have an account? Register here')
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
