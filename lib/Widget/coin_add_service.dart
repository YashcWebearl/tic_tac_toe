import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/Widget/base.dart';
import 'coin_noti.dart';

class CoinService {
  static Future<void> addCoins({required int coins}) async {
    print('Adding coins one by one...');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    // Get the current coin count
    final getUrl = Uri.parse('$LURL/api/coin/display');
    final getResponse = await http.get(getUrl, headers: {
      'Authorization': token,
      'Content-Type': 'application/json',
    });

    if (getResponse.statusCode != 200) {
      throw Exception('Failed to fetch current coins: ${getResponse.body}');
    }

    final currentCoins = jsonDecode(getResponse.body)['coins'];

    for (int i = 1; i <= coins; i++) {
      final newCoins = currentCoins + i;

      // Update global notifier (UI reacts here)
      CoinNotifier.coins.value = newCoins;

      // Optional: update shared preferences for caching
      await prefs.setInt('user_coins', newCoins);

      // Delay between each increment for visible animation effect
      await Future.delayed(const Duration(milliseconds: 150));
    }

    // 🔄 Final sync with server (send the full addition)
    final postUrl = Uri.parse('$LURL/api/coin/add');
    final postResponse = await http.post(
      postUrl,
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'coin': coins}),
    );

    if (postResponse.statusCode != 200) {
      throw Exception('Failed to sync added coins with server: ${postResponse.body}');
    }

    print('Coin addition complete.');
  }

  // static Future<void> addCoins({required int coins}) async {
  //   print('win the amount');
  //   final url = Uri.parse('$LURL/api/coin/add');
  //   print('win the amount11111');
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('auth_token');
  //   print('token is 2222222:-$token');
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Authorization': token!,
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({'coin': coins}),
  //   );
  //   print('win the amount33333333333');
  //   print('response is add coin :- ${response.statusCode}');
  //   print('response is add coin :- ${response.body}');
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final newCoins = data['coins'];
  //     print('newCoins :- $newCoins');
  //
  //     // Update global coins notifier
  //     CoinNotifier.coins.value = newCoins;
  //   } else {
  //     throw Exception('Failed to add coins: ${response.body}');
  //   }
  // }


  static Future<void> undoCoins({required int coins}) async {
    print('Lose the amount');
    final url = Uri.parse('$LURL/api/coin/undo');
    print('Lose the amount111111111111111');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('token is 2222222:-$token');
    print('Lose the amount token:-$token');
    final response = await http.post(
      url,
      headers: {
        'Authorization': token!,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'coin': coins}),
    );
    print('Response is undo coin :- ${response.statusCode}');
    print('Response is undo coin :- ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      CoinNotifier.coins.value = data['coins'];
    } else {
      throw Exception('Failed to undo coins: ${response.body}');
    }
  }
}
