import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tic_tac_toe/view/start_screen.dart';

import '../Widget/bg_container.dart';
import '../Widget/custom_button.dart';  // For RoundedGradientButton

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ],
);

class SignInDemo extends StatefulWidget {
  @override
  _SignInDemoState createState() => _SignInDemoState();
}

class _SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount? _currentUser;

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

  Future<void> _handleSignIn() async {
    try {
      final account = await _googleSignIn.signIn();
      //_googleSignIn.onCurrentUserChanged.listen((account) {
      //   setState(() {
      //     _currentUser = account;
      //   });
      //   if (account != null) {
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => const StartScreen()),
      //       );
      //     });
      //   }
      // });
      if (account != null) {
        setState(() {
          _currentUser = account;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StartScreen()),
          );
        });
      }
    } catch (error) {
      print('Sign in failed: $error');
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Google Sign-In Demo",
          style: TextStyle(
            fontFamily: 'Pridi',
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: BackgroundContainer(
        child: Center(
          // child: _currentUser != null
          //     ? Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     CircleAvatar(
          //       backgroundImage:
          //       NetworkImage(_currentUser!.photoUrl ?? ''),
          //       radius: 50.r,
          //     ),
          //     SizedBox(height: 20.h),
          //     Text(
          //       'Name: ${_currentUser!.displayName}',
          //       style: TextStyle(
          //         fontFamily: 'Pridi',
          //         fontWeight: FontWeight.w500,
          //         fontSize: 20.sp,
          //         color: Colors.white,
          //       ),
          //     ),
          //     SizedBox(height: 8.h),
          //     Text(
          //       'Email: ${_currentUser!.email}',
          //       style: TextStyle(
          //         fontFamily: 'Pridi',
          //         fontWeight: FontWeight.w400,
          //         fontSize: 16.sp,
          //         color: Colors.white70,
          //       ),
          //     ),
          //     SizedBox(height: 30.h),
          //     RoundedGradientButton(
          //       width: 180.w,
          //       // height: 50.h,
          //       text: 'Sign Out',
          //       onPressed: _handleSignOut,
          //     ),
          //   ],
          // )
          //     : RoundedGradientButton(
          //   width: 220.w,
          //   // height: 50.h,
          //   text: 'Sign in with Google',
          //   onPressed: _handleSignIn,
          // ),
          child: _currentUser != null
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
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const StartScreen()),
                  );
                },
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
            width: 240,
            text: 'Sign in with Google',
            onPressed: _handleSignIn,
          ),

        ),
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
