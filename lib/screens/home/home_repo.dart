import 'dart:convert';
import 'package:dio/dio.dart';

import '../../data/models/api_response.dart';

class HomeScreenRepo {
  final client = Dio();
  ApiResponse clientResponse = ApiResponse();

  Future<ApiResponse> getFoodMenu() async {
    var response;
    try {
      Options options = Options();
      options.method = "GET";
      var response = await client.getUri(
          Uri.parse("https://www.mocky.io/v2/5dfccffc310000efc8d2c1ad"));

      clientResponse.code = response.statusCode;
      clientResponse.isSuccessful = true;
      clientResponse.rawResponse = response.data;
      //

    } on DioError catch (e) {
      clientResponse.errorMsg = e.response!.statusMessage;
      clientResponse.code = e.response!.statusCode;
      clientResponse.isSuccessful = false;
      clientResponse.rawResponse = e.response!.data;
    } catch (e) {
      clientResponse.errorMsg = e.toString();
    }
    return clientResponse;
  }
}
