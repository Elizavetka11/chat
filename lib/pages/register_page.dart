import 'package:chat/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final emailContoller = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp() async {

    if (passwordController.text != confirmPasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password don"t match'),
        ),
      );
        return;
    }
        final authService = Provider.of<AuthService>(context, listen: false);

    try {
      authService.signUpWithEmailandPassword(
          emailContoller.text,
          passwordController.text,
      );
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
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
                          "Let's create account",
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


                        MyTextFields(
                            controller: confirmPasswordController,
                            hintText: 'Confirm password',
                            obscureText: true
                        ),

                        const SizedBox(height: 25),

                        MyButton(onTap: signUp, text: "sign up"),

                        const SizedBox(height: 25),

                        Row(
                          mainAxisAlignment:  MainAxisAlignment.center,
                          children: [
                            const Text('Already a member?'),
                            const SizedBox(width: 4,),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: Text(
                                'Login now',
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