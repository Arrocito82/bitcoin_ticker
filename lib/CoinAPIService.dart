import 'dart:convert';
import 'dart:io' show HttpStatus;

import 'package:http/http.dart' as http;

class CoinAPIService {
  static const _kCoinAPIDomainName = 'rest.coinapi.io';
  static const _kCoinAPIPath = 'v1/exchangerate';
  static const _kAPIKey = 'E4CE99DF-3B84-4644-992F-2F8B056AD193';
  static Future<Map?> getExchangeRate(
      String baseCurrency, String quoteCurrency) async {
    dynamic response = await http.get(
        Uri.https('$_kCoinAPIDomainName',
            '$_kCoinAPIPath/$baseCurrency/$quoteCurrency'),
        headers: {'X-CoinAPI-Key': _kAPIKey});
    if (response.statusCode == HttpStatus.ok) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      return decodedResponse;
    } else {
      return null;
    }
  }
}
