import 'package:easypark/Presentation/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 100,
                width: deviceWidth,
                color: Colors.white,
                alignment: Alignment.bottomLeft,
                child: const Padding(
                  padding: EdgeInsets.only(left: 30.0, bottom: 10.0),
                  child: Text(
                    "Easy",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 100,
                  width: deviceWidth,
                  color: const Color.fromARGB(255, 6, 68, 119),
                  alignment: Alignment.topLeft,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 30.0, top: 10.0),
                    child: Text("Park",
                        style: TextStyle(fontSize: 24, color: Colors.white)),
                  ),
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                height: 200,
                width: deviceWidth,
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Transform.scale(
                            scale: 0.7,
                            child: Image.asset('assets/logo.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(75)),
                  ),
                  padding: const EdgeInsets.all(30.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'First Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                              controller: firstNameController,
                              decoration: InputDecoration(
                                hintText: "Enter your First name",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return "Please enter a valid value";
                              }),
                          SizedBox(height: 20),
                          Text(
                            'Last Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                hintText: "Enter your last name",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return "Please enter a valid value";
                              }),
                          SizedBox(height: 20),
                          Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: "Enter your email",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return "Please enter a valid value";
                              }),
                          SizedBox(height: 20),
                          Text(
                            'Password',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Password",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return "Please enter a valid value";
                              }),
                          SizedBox(height: 20),
                          Text(
                            'Confirm Password',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Password",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return "Please enter a valid value";
                              }),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: "Already have an account? ",
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: "Login",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[400]),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pushNamed(
                                          context, '/login'))
                              ])),
                            ],
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => home()));
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty
                                    .all<Color>(Color.fromARGB(255, 6, 68,
                                        119)), // Set button background color
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 253, 248,
                                            248)), // Set button text color
                              ),
                              child: loading
                                  ? Container(
                                      height: 10,
                                      width: 10,
                                      child: CircularProgressIndicator())
                                  : Text('REGISTER'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
