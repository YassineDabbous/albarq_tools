import 'package:albarq_tools/data/constants.dart';
import 'package:albarq_tools/data/data.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'auth_manager.dart';

extension FutureX<T extends BasicResponse> on Future {
  Future handleError(Function(String) onError) {
    return catchError((err) {
      print(err);
      print('-------------------------------------- HTTP ERROR --------------------------------------');
      String message = err.toString();
      print(err.runtimeType);
      if (err is DioError) {
        if (err.type == DioErrorType.response) {
          switch (err.response?.statusCode) {
            case 401:
              message = "error_401";
              break;
            case 403:
              message = "error_403";
              break;
            case 404:
              message = "error_404";
              break;
            case 409:
              message = "error_409";
              break;
            case 422:
              message = "error_422";
              break;
            case 429:
              message = "error_429";
              break;
            case 500:
              message = "error_500";
              break;
            default:
              message = 'HTTP error (${err.response?.statusCode})';
          }
        } else if (err.type == DioErrorType.other) {
          message = "verify_your_internet_connection";
        }
      } else {
        print('☺☺☺ Not DioError ☺☺☺');
        // SocketException?
        message = "verify_your_internet_connection";
      }
      print(message);
      onError(message);
      //return err;
    });
  }

  Future<T?> onSuccess(Function(dynamic) onSuccess) {
    return this.then((data) {
      print('☺ onSuccess');
      onSuccess(data.data);
    });
  }
}

class Repository {
  late RestClient _restClient;

  factory Repository() => _instance;
  static Repository _instance = Repository._();
  static void refreshApiClient() {
    print('@@@@@@@@@ RefreshApiClient @@@@@@@@@');
    _instance = Repository._();
  }

  Repository._() {
    final dio = Dio();

    //
    // Cache Interceptor
    //
    // dio.interceptors.add(DioCacheInterceptor(options: Cache.cacheOptions));

    //
    // Logger Interceptor
    //
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      //logPrint: (_) => log(_.toString())
    ));

    //
    // Headers
    //
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Access-Control-Allow-Origin"] = "*";
    if (AuthManager.currentUser != null) {
      dio.options.headers["Authorization"] = "Bearer ${AuthManager.currentUser!.token}";
    }
    dio.options.baseUrl = kUrlApi;
    _restClient = RestClient(dio);

    //print('ok');
  }

  static RestClient http() {
    return Repository._instance._restClient;
  }
}
