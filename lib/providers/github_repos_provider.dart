import 'dart:convert';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart' as http;
import '../support/db_helper.dart';

final githubReposProvider = FutureProvider<List<dynamic>>((ref) async {
  final dbHelper = DatabaseHelper.instance;
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    final response = await http.get(
      Uri.parse('https://api.github.com/search/repositories?q=created:>2022-04-29&sort=stars&order=desc'),
    );

    if (response.statusCode == 200) {
      await dbHelper.delete();
      Map<String, dynamic> data = {'data': response.body};
      await dbHelper.insert(data);
      return json.decode(response.body)['items'];
    } else {
      throw Exception('Failed to load GitHub repositories');
    }
  } else if (connectivityResult == ConnectivityResult.none) {
    List<Map<String, dynamic>> data = await dbHelper.queryAllRows();
    if (data.isNotEmpty) {
      log(data.toString());
      return json.decode(data[0]['data'])['items'];
    } else {
      throw Exception('Failed to load GitHub repositories');
    }
  }
  throw Exception('Failed to load GitHub repositories');
});
