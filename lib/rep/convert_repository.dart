import 'dart:convert';
import 'package:http/http.dart' as http;

class ConvertRepo {
  static final ConvertRepo _convertRepo = ConvertRepo._internal();

  factory ConvertRepo() {
    return _convertRepo;
  }
  ConvertRepo._internal();

  Future<double> convert(
      {required String fromCurr,
      required String toCurr,
      required double value}) async {
    final response = await http.get(
        'https://free.currconv.com/api/v7/convert?q=${fromCurr}_${toCurr}&compact=ultra&apiKey=233bbc91af572fb562f7');

    if (response.statuscode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      final rate = jsonResponse['${fromCurr}_${toCurr}'].toDouble();
      print(rate * value);
      return rate * value;
    } else {
      throw Exception('Failed to load result');
    }
  }
}
