import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

Future<http.Response> submitData(
    String name, String email, String message) async {
  var response = await http.post(
    Uri.parse('https://api.byteplex.info/api/test/contact/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'name': name, 'email': email, 'message': message}),
  );
  var data = response.body;
  print(data);

  if (response.statusCode == 201) {
    String responseString = response.body;
    jsonEncode(responseString);
    print("success");
  } else {
    print("error! response code !=201");
  }
  return response;
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5fd),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 20,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  'Contact us',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: 'Name', icon: Icon(Icons.lock_open_rounded)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email', icon: Icon(Icons.lock_open_rounded)),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Required*';
                    } else if (!EmailValidator.validate(email)) {
                      return 'Please enter a valid Email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: messageController,
                  decoration: const InputDecoration(
                      labelText: 'Message',
                      icon: Icon(Icons.lock_open_rounded)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 60),
                SizedBox(
                  height: 50,
                  width: 300,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromRGBO(144, 85, 112, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                    onPressed: () async {
                      String name = nameController.text;
                      String email = emailController.text;
                      String message = messageController.text;
                      if (_formKey.currentState!.validate()) {
                        nameController.clear();
                        emailController.clear();
                        messageController.clear();
                      }
                      http.Response response =
                          await submitData(name, email, message);
                    },
                    child: const Text('Send', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
