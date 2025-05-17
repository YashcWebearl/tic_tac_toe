import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/Widget/bg_container.dart';
import 'package:tic_tac_toe/Widget/custom_button.dart';
import 'package:tic_tac_toe/Widget/sound.dart';
import 'package:tic_tac_toe/view/start_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Widget/base.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() => _isLoading = true);

    final uri = Uri.parse('$LURL/api/game/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200 ) {
      final json = jsonDecode(response.body);
      final token = json['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('email', email);
      print('token login:- $token');


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StartScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Login failed. Try again."),
      ));
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
     appBar: AppBar(
        backgroundColor: Colors.transparent,
       automaticallyImplyLeading: false,

       centerTitle: true,
       title: Text(
       'Login',
       style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
    ),
     ),
       leading: Padding(
         padding:  EdgeInsets.all(8.0),
         child: _buildRoundedIcon(
           icon: Icons.arrow_back_ios_new_rounded,
           onTap: () => Navigator.pop(context),
         ),
       ),
     ),
      body: BackgroundContainer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : RoundedGradientButton(
                  text: 'Submit',
                  onPressed: _submitEmail,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildRoundedIcon({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: () {
        AudioHelper().playButtonClick();
        onTap();
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF400CB9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
