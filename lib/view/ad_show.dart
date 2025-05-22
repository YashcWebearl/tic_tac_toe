import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AdPlaybackPage extends StatefulWidget {
  final VoidCallback onAdComplete;

  const AdPlaybackPage({super.key, required this.onAdComplete});

  @override
  State<AdPlaybackPage> createState() => _AdPlaybackPageState();
}

class _AdPlaybackPageState extends State<AdPlaybackPage> {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() async {
    // Attempt connectivity check
    bool hasConnection = true;
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        hasConnection = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No internet connection. Try again.')),
        );
        widget.onAdComplete();
        Navigator.pop(context);
        return;
      }
    } catch (e) {
      print('Connectivity check failed: $e');
      // Proceed with ad loading even if connectivity check fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network check unavailable. Attempting to load ad.')),
      );
    }

    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test ID
      // adUnitId: 'ca-app-pub-7508634868293786/4776467304', // Real ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
            _isAdLoaded = true;
          });
          _showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          print('Error code: ${error.code}, Message: ${error.message}, Domain: ${error.domain}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ad failed to load: ${error.message}')),
          );
          // widget.onAdComplete();
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          print('Ad dismissed.');
          ad.dispose();
          widget.onAdComplete();
          Navigator.pop(context);
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print('Ad failed to show: $error');
          ad.dispose();
          // widget.onAdComplete();
          Navigator.pop(context);
        },
      );
      _interstitialAd!.show();
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: true,
      maintainBottomViewPadding: true,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.8),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Loading Ad...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pridi',
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!_isAdLoaded)
                    const CircularProgressIndicator(color: Colors.white),
                  if (_isAdLoaded)
                    const Text(
                      'Ad is loading. Please wait.',
                      style: TextStyle(color: Colors.white),
                    ),
                  const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // widget.onAdComplete();
                  //     Navigator.pop(context);
                  //   },
                  //   child: const Text('Skip'),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// import 'dart:async';
// import 'package:flutter/material.dart';
//
// import '../Widget/coin_add_service.dart';
// class AdPlaybackPage extends StatefulWidget {
//   final VoidCallback onAdComplete;
//
//   const AdPlaybackPage({super.key, required this.onAdComplete});
//
//   @override
//   State<AdPlaybackPage> createState() => _AdPlaybackPageState();
// }
//
// class _AdPlaybackPageState extends State<AdPlaybackPage> {
//   int _remainingSeconds = 15;
//   late Timer _timer;
//   bool _showCancelIcon = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }
//
//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_remainingSeconds > 0) {
//           _remainingSeconds--;
//         } else {
//           _showCancelIcon = true;
//           _timer.cancel();
//           widget.onAdComplete();
//         }
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     print('ad_show.dart');
//     return WillPopScope(
//       onWillPop: () async {
//         // Disable back until ad is done
//         return _showCancelIcon; // false = block back, true = allow
//       },
//       child: Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: Stack(
//             children: [
//               Center(
//                 child: Image.asset(
//                   'assets/SkipAd.png',
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               Positioned(
//                 top: 40,
//                 right: 20,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: _showCancelIcon
//                       ? GestureDetector(
//                     onTap: () {
//                       // _addCoins();
//                       Navigator.pop(context);
//                     },
//                     child: const Icon(
//                       Icons.close,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                   )
//                       : Text(
//                     '$_remainingSeconds',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }