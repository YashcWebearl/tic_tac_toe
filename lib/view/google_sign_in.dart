// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tic_tac_toe/view/start_screen.dart';
//
// import '../Widget/bg_container.dart';
// import '../Widget/custom_button.dart';  // For RoundedGradientButton
//
// final GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: [
//     'email',
//     'https://www.googleapis.com/auth/userinfo.profile',
//   ],
// );
//
// class SignInDemo extends StatefulWidget {
//   @override
//   _SignInDemoState createState() => _SignInDemoState();
// }
//
// class _SignInDemoState extends State<SignInDemo> {
//   GoogleSignInAccount? _currentUser;
//
//   @override
//   void initState() {
//     super.initState();
//     _googleSignIn.onCurrentUserChanged.listen((account) {
//       setState(() {
//         _currentUser = account;
//       });
//     });
//     _googleSignIn.signInSilently(); // auto sign-in
//   }
//
//   Future<void> _handleSignIn() async {
//     try {
//       final account = await _googleSignIn.signIn();
//       //_googleSignIn.onCurrentUserChanged.listen((account) {
//       //   setState(() {
//       //     _currentUser = account;
//       //   });
//       //   if (account != null) {
//       //     WidgetsBinding.instance.addPostFrameCallback((_) {
//       //       Navigator.pushReplacement(
//       //         context,
//       //         MaterialPageRoute(builder: (context) => const StartScreen()),
//       //       );
//       //     });
//       //   }
//       // });
//       if (account != null) {
//         setState(() {
//           _currentUser = account;
//         });
//         print('User signed in: ${account.toString()}');
//         print('User signed in22222: ${account.displayName}, email: ${account.email}');
//         print('user signed in3333333: ${account.photoUrl}');
//         print('user sign in444444444444:- ${account.id}');
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           // Navigator.pushReplacement(
//           //   context,
//           //   MaterialPageRoute(builder: (context) => const StartScreen()),
//           // );
//         });
//       }
//     } catch (error) {
//       print('Sign in failed: $error');
//     }
//   }
//
//   Future<void> _handleSignOut() => _googleSignIn.disconnect();
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context);
//
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Text(
//           "Google Sign-In",
//           style: TextStyle(
//             fontFamily: 'Pridi',
//             fontWeight: FontWeight.w500,
//             fontSize: 24,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: BackgroundContainer(
//         child: Center(
//           // child: _currentUser != null
//           //     ? Column(
//           //   mainAxisSize: MainAxisSize.min,
//           //   children: [
//           //     CircleAvatar(
//           //       backgroundImage:
//           //       NetworkImage(_currentUser!.photoUrl ?? ''),
//           //       radius: 50.r,
//           //     ),
//           //     SizedBox(height: 20.h),
//           //     Text(
//           //       'Name: ${_currentUser!.displayName}',
//           //       style: TextStyle(
//           //         fontFamily: 'Pridi',
//           //         fontWeight: FontWeight.w500,
//           //         fontSize: 20.sp,
//           //         color: Colors.white,
//           //       ),
//           //     ),
//           //     SizedBox(height: 8.h),
//           //     Text(
//           //       'Email: ${_currentUser!.email}',
//           //       style: TextStyle(
//           //         fontFamily: 'Pridi',
//           //         fontWeight: FontWeight.w400,
//           //         fontSize: 16.sp,
//           //         color: Colors.white70,
//           //       ),
//           //     ),
//           //     SizedBox(height: 30.h),
//           //     RoundedGradientButton(
//           //       width: 180.w,
//           //       // height: 50.h,
//           //       text: 'Sign Out',
//           //       onPressed: _handleSignOut,
//           //     ),
//           //   ],
//           // )
//           //     : RoundedGradientButton(
//           //   width: 220.w,
//           //   // height: 50.h,
//           //   text: 'Sign in with Google',
//           //   onPressed: _handleSignIn,
//           // ),
//           child: _currentUser != null
//               ? Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircleAvatar(
//                 backgroundImage: NetworkImage(_currentUser!.photoUrl ?? ''),
//                 radius: 50.r,
//               ),
//               SizedBox(height: 20.h),
//               Text(
//                 'Name: ${_currentUser!.displayName}',
//                 style: TextStyle(
//                   fontFamily: 'Pridi',
//                   fontWeight: FontWeight.w500,
//                   fontSize: 20,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               Text(
//                 'Email: ${_currentUser!.email}',
//                 style: TextStyle(
//                   fontFamily: 'Pridi',
//                   fontWeight: FontWeight.w400,
//                   fontSize: 16,
//                   color: Colors.white70,
//                 ),
//               ),
//               SizedBox(height: 30.h),
//               RoundedGradientButton(
//                 width: 240,
//                 text: 'Play with this ID',
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => const StartScreen()),
//                   );
//                 },
//               ),
//               SizedBox(height: 15.h),
//               RoundedGradientButton(
//                 width: 200,
//                 text: 'Sign Out',
//                 onPressed: _handleSignOut,
//               ),
//             ],
//           )
//               : RoundedGradientButton(
//             width: 280,
//             text: 'Sign in with Google',
//             rightIcon: Image.asset(
//               'assets/google_logo.png',
//               width: 24,
//               height: 24,
//             ),
//             onPressed: _handleSignIn,
//           ),
//
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/Widget/base.dart';
import 'package:tic_tac_toe/view/start_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Widget/bg_container.dart';
import '../Widget/custom_button.dart';
import '../Widget/sound.dart';
import '../modal/reg_login_modal.dart';  // For RoundedGradientButton

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ],
);

class SignInDemo extends StatefulWidget {
  final bool isRegistration;
  const SignInDemo({Key? key, this.isRegistration = false}) : super(key: key);
  @override
  _SignInDemoState createState() => _SignInDemoState();
}

class _SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount? _currentUser;
  bool _isLoading = false;
  LoginResponse? _loginResponse;

  // @override
  // void initState() {
  //   super.initState();
  //   _googleSignIn.onCurrentUserChanged.listen((account) {
  //     setState(() {
  //       _currentUser = account;
  //     });
  //   });
  //   _googleSignIn.signInSilently(); // Auto sign-in
  // }
  //
  // Future<void> _handleSignIn() async {
  //   try {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     final account = await _googleSignIn.signIn();
  //     if (account != null) {
  //       setState(() {
  //         _currentUser = account;
  //       });
  //
  //       // Prepare form data for API
  //       var request = http.MultipartRequest(
  //         'POST',
  //         Uri.parse('https://game-6gy.onrender.com/api/game/google'),
  //       );
  //       request.fields['registeredID'] = account.id;
  //       request.fields['email'] = account.email;
  //       request.fields['userName'] = account.displayName ?? 'User';
  //       if (account.photoUrl != null) {
  //         request.fields['photo'] = account.photoUrl!;
  //       }
  //
  //       // Send the API request
  //       var response = await request.send();
  //       final responseBody = await response.stream.bytesToString();
  //       final jsonResponse = jsonDecode(responseBody);
  //       print('status code:-${response.statusCode}');
  //       print('response body:-$responseBody');
  //       print('json response:-${jsonResponse.toString()}');
  //       if (response.statusCode == 200) {
  //         setState(() {
  //           _loginResponse = LoginResponse.fromJson(jsonResponse);
  //         });
  //       } else {
  //         print('API error: ${response.statusCode}, $responseBody');
  //       }
  //     }
  //   } catch (error) {
  //     print('Sign in failed: $error');
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently(); // auto sign-in
  }

  // Future<void> _handleSignIn() async {
  //   try {
  //     final account = await _googleSignIn.signIn();
  //     //_googleSignIn.onCurrentUserChanged.listen((account) {
  //     //   setState(() {
  //     //     _currentUser = account;
  //     //   });
  //     //   if (account != null) {
  //     //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //     //       Navigator.pushReplacement(
  //     //         context,
  //     //         MaterialPageRoute(builder: (context) => const StartScreen()),
  //     //       );
  //     //     });
  //     //   }
  //     // });
  //     if (account != null) {
  //       setState(() {
  //         _currentUser = account;
  //       });
  //       print('User signed in: ${account.toString()}');
  //       print('User signed in22222: ${account.displayName}, email: ${account.email}');
  //       print('user signed in3333333: ${account.photoUrl}');
  //       print('user sign in444444444444:- ${account.id}');
  //
  //       final uri = Uri.parse('https://game-6g0j.onrender.com/api/game/google');
  //
  //       final response = await http.post(
  //         uri,
  //         headers: {
  //           'Content-Type': 'application/json',
  //         },
  //         body: jsonEncode({
  //           'registeredID': account.id,
  //           'email': account.email,
  //           'userName': account.displayName ?? 'User',
  //           'photo': account.photoUrl ?? '',
  //         }),
  //       );
  //
  //       print('status code:-${response.statusCode}');
  //       print('response body:-${response.body}');
  //
  //
  //       if (response.statusCode == 200) {
  //         final jsonResponse = jsonDecode(response.body);
  //         setState(() {
  //           _loginResponse = LoginResponse.fromJson(jsonResponse);
  //         });
  //       } else {
  //         print('API error: ${response.statusCode}, ${response.body}');
  //       }
  //
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         // Navigator.pushReplacement(
  //         //   context,
  //         //   MaterialPageRoute(builder: (context) => const StartScreen()),
  //         // );
  //       });
  //     }
  //   } catch (error) {
  //     print('Sign in failed: $error');
  //   }
  // }

  Future<void> _handleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('work:-');
      final account = await _googleSignIn.signIn();

      if (account != null) {
        setState(() {
          _currentUser = account;
        });
        print('work111111111111111:-');

        final email = account.email;
        print('email is:- ${account.email}');

        if (widget.isRegistration) {
          // ➤ REGISTRATION FLOW
          final uri = Uri.parse('$LURL/api/user/google');
          print('work22222222222222222:-');
          final response = await http.post(
            uri,
            headers: {
              'Content-Type': 'application/json',
            },

            body: jsonEncode({
              'registeredID': account.id,
              'email': email,
              'gameName': "XOXO",
              'userName': account.displayName ?? 'User',
              'photo': account.photoUrl ?? '',
            }),
          );
          print('response status code:-${response.statusCode}');
          print('response body :-${response.body}');
          if (response.statusCode == 200) {
            final jsonResponse = jsonDecode(response.body);
            print('work3333333333333:-');
            final token = jsonResponse['token'];
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', token);
            await prefs.setString('email', email);

            setState(() {
              _loginResponse = LoginResponse.fromJson(jsonResponse);
            });
            print('work444444444444:-');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => StartScreen(coinadd: true)),
              );
            });
          } else if (response.statusCode == 409) {
            print('work555555555555555555:-');
            final errorMessage = jsonDecode(response.body)['message'] ?? 'User already registered.';
            Fluttertoast.showToast(
              msg: errorMessage,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } else {
            print('work66666666666666:-');
            print('API error: ${response.statusCode}, ${response.body}');
          }
        } else {
          // ➤ LOGIN FLOW
          print('work7777777777777777:-');
          final uri = Uri.parse('$LURL/api/user/login');
          final response = await http.post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email}),
          );
          print('response status code login:-${response.statusCode}');
          print('response body login:-${response.body}');
          if (response.statusCode == 200) {
            final json = jsonDecode(response.body);
            final token = json['token'];
            print('work888888888888888:-');
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', token);
            await prefs.setString('email', email);

            print('token login:- $token');

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const StartScreen()),
              );
            });
          } else {
            print('work999999999999:-');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text("Login failed. Try again."),
            ));
          }
        }
      }
    } on PlatformException catch (e) {
      print('Google sign-in error: ${e.code}, ${e.message}, ${e.details}');
    } catch (error) {
      print('Sign in failed: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }




  // Future<void> _handleSignIn() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   try {
  //     final account = await _googleSignIn.signIn();
  //     print('data of goodle:-$account');
  //     print('data of goodle:-${account.toString()}');
  //     print('data of goodle:-${account!.id}');
  //     print('data of goodle:-${account!.displayName}');
  //
  //
  //     if (account != null) {
  //       setState(() {
  //         _currentUser = account;
  //       });
  //
  //       print('User signed in: ${account.displayName}, email: ${account.email}');
  //
  //       final uri = Uri.parse('$LURL/api/user/google');
  //
  //       final response = await http.post(
  //         uri,
  //         headers: {
  //           'Content-Type': 'application/json',
  //         },
  //         body: jsonEncode({
  //           'registeredID': account.id,
  //           'email': account.email,
  //           'gameName':"XOXO",
  //           'userName': account.displayName ?? 'User',
  //           'photo': account.photoUrl ?? '',
  //         }),
  //       );
  //
  //       print('status code:-${response.statusCode}');
  //       print('response body:-${response.body}');
  //
  //       if (response.statusCode == 200) {
  //         final jsonResponse = jsonDecode(response.body);
  //
  //         // Save token
  //         final token = jsonResponse['token'];
  //         final prefs = await SharedPreferences.getInstance();
  //         await prefs.setString('auth_token', token);
  //         print('Token saved to shared preferences');
  //
  //         setState(() {
  //           _loginResponse = LoginResponse.fromJson(jsonResponse);
  //         });
  //
  //         // Navigate to StartScreen after sign in
  //         WidgetsBinding.instance.addPostFrameCallback((_) {
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (context) =>  StartScreen(coinadd: true,)),
  //           );
  //         });
  //       }
  //       else if(response.statusCode == 409){
  //         final errorMessage = jsonDecode(response.body)['message'] ?? 'User already registered.';
  //
  //         // ScaffoldMessenger.of(context).showSnackBar(
  //         //   SnackBar(
  //         //     content: Text(errorMessage),
  //         //     backgroundColor: Colors.redAccent,
  //         //     behavior: SnackBarBehavior.floating,
  //         //   ),
  //         // );
  //         Fluttertoast.showToast(
  //           msg: errorMessage,
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           backgroundColor: Colors.redAccent,
  //           textColor: Colors.white,
  //           fontSize: 16.0,
  //         );
  //       }
  //       else {
  //         print('API error: ${response.statusCode}, ${response.body}');
  //       }
  //     }
  //   } catch (error) {
  //     print('Sign in failed: $error');
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  Future<void> _handleSignOut() async {
    await _googleSignIn.disconnect();
    setState(() {
      _currentUser = null;
      _loginResponse = null;
    });
  }

  void _handlePlayWithId() {
    if (_loginResponse != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StartScreen(),
        ),
      );
    }
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
          widget.isRegistration == true ?'Registration':'Login',
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
          child: _isLoading
              ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )

              : _currentUser != null && _loginResponse != null
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(_currentUser!.photoUrl ?? ''),
                radius: 50.r,
              ),
              SizedBox(height: 20.h),
              Text(
                'Name: ${_currentUser!.displayName}',
                style: TextStyle(
                  fontFamily: 'Pridi',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Email: ${_currentUser!.email}',
                style: TextStyle(
                  fontFamily: 'Pridi',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 30.h),
              RoundedGradientButton(
                width: 240,
                text: 'Play with this ID',
                onPressed: _handlePlayWithId,
              ),
              SizedBox(height: 15.h),
              RoundedGradientButton(
                width: 200,
                text: 'Sign Out',
                onPressed: _handleSignOut,
              ),
            ],
          )
              : RoundedGradientButton(
            width: 280,
            text: widget.isRegistration ?'Sign up with Google' : 'Sign in with Google',
            rightIcon: Image.asset(
              'assets/google_logo.png',
              width: 24,
              height: 24,
            ),
            onPressed: _handleSignIn,
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
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:tic_tac_toe/view/start_screen.dart';
//
// import '../Widget/bg_container.dart';
//
// final GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: [
//     'email',
//     'https://www.googleapis.com/auth/userinfo.profile',
//   ],
// );
//
//
// class SignInDemo extends StatefulWidget {
//   @override
//   _SignInDemoState createState() => _SignInDemoState();
// }
//
// class _SignInDemoState extends State<SignInDemo> {
//   GoogleSignInAccount? _currentUser;
//
//   @override
//   void initState() {
//     super.initState();
//     _googleSignIn.onCurrentUserChanged.listen((account) {
//       setState(() {
//         _currentUser = account;
//       });
//     });
//     _googleSignIn.signInSilently(); // auto sign-in
//   }
//
//   Future<void> _handleSignIn() async {
//     print('Work in progress2222222:-');
//     try {
//       final account = await _googleSignIn.signIn();
//       print('Work in progress:-');
//       if (account != null) {
//         print('Work in progress11111111111:-');
//         print('User signed in: ${account.displayName}, email: ${account.email}');
//         setState(() {
//           _currentUser = account;
//         });
//         // Navigate to StartScreen after successful sign-in
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const StartScreen()),
//           );
//         });
//       }
//     } catch (error) {
//       print('Sign in failed: $error');
//     }
//   }
//
//   // Future<void> _handleSignIn() async {
//   //   try {
//   //     await _googleSignIn.signIn();
//   //   } catch (error) {
//   //     print('Sign in failed: $error');
//   //   }
//   // }
//
//   Future<void> _handleSignOut() => _googleSignIn.disconnect();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//           title: Text("Google Sign-In Demo")
//       ),
//       body: BackgroundContainer(
//         child: Center(
//           child: _currentUser != null
//               ? Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircleAvatar(
//                 backgroundImage:
//                 NetworkImage(_currentUser!.photoUrl ?? ''),
//                 radius: 40,
//               ),
//               Text('Name: ${_currentUser!.displayName}'),
//               Text('Email: ${_currentUser!.email}'),
//               ElevatedButton(
//                 onPressed: _handleSignOut,
//                 child: Text('Sign Out'),
//               ),
//             ],
//           )
//               : ElevatedButton(
//             onPressed: _handleSignIn,
//             child: Text('Sign in with Google'),
//           ),
//         ),
//       ),
//     );
//   }
// }
