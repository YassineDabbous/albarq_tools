import 'package:albarq_tools/data/data.dart';
import 'package:albarq_tools/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc ctrl = LoginBloc();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  listener(context, state) {
    if (state is LoginSuccess) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ScannerScreen()));
    }
    // else if (state is LoginSuccess) {
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ScannerScreen()));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text("Login Page"),
      // ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => ctrl,
          child: BlocListener<LoginBloc, LoginState>(
            listener: listener,
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: Center(
                        child: SizedBox(width: 200, height: 150, child: Image.asset('assets/imgs/logo.png')),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Login",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text("Enter your credentials"),
                    const SizedBox(height: 10),
                    if (state is LoginFailed)
                      Container(
                        height: 50,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.red[800], borderRadius: BorderRadius.circular(4)),
                        child: const Center(child: const Text('Login failed', style: TextStyle(color: Colors.white))),
                      ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: phoneCtrl,
                        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Phone', hintText: 'Enter your phone number'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
                      child: TextField(
                        controller: passwordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Password', hintText: 'Enter your password'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                      child: (state is LoginLoading)
                          ? const Center(child: CircularProgressIndicator(color: Colors.white))
                          : TextButton(
                              onPressed: () => ctrl.login(phone: phoneCtrl.text, password: passwordCtrl.text),
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white, fontSize: 25),
                              ),
                            ),
                    ),
                    const SizedBox(height: 130),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
