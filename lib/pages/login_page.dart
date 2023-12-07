import 'package:chat/components/my_button.dart';
import 'package:chat/components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailContoller = TextEditingController();
  final passwordController = TextEditingController();

void signIn() async {
  final authService = Provider.of<AuthService>(context, listen: false);

  try {
    await authService.signInWithEmailandPassword(
        emailContoller.text,
        passwordController.text,
    );
  }catch(e){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),),),);

  }


}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                      children: [
                        Icon(
                          Icons.message,
                          size: 80,
                        ),
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),

                        const SizedBox(height: 25),

                        MyTextFields(
                            controller: emailContoller,
                            hintText: 'email',
                            obscureText: false
                        ),

                        const SizedBox(height: 25),

                        MyTextFields(
                            controller: passwordController,
                            hintText: 'Password',
                            obscureText: true
                        ),

                        const SizedBox(height: 25),

                        MyButton(onTap: signIn, text: "sign in"),

                        const SizedBox(height: 25),

                        Row(
                          mainAxisAlignment:  MainAxisAlignment.center,
                          children: [
                            const Text('Not a member?'),
                            const SizedBox(width: 4,),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: Text(
                                'Register now',
                                style: TextStyle(fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        )
                      ]
                  ),
                )
            )
        )
    );
  }
}
