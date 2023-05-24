import 'package:dio/dio.dart';

part "app_error.dart";

abstract class AuthInterceptor extends Interceptor {
  List<Map<String, String>> getAuthInfo(
      RequestOptions route, bool Function(Map<String, String> secure) handles) {
    if (route.extra.containsKey('secure')) {
      final auth = route.extra['secure'] as List<Map<String, String>>;
      return auth.where((secure) => handles(secure)).toList();
    }
    return [];
  }
}

class BearerAuthInterceptor extends AuthInterceptor {
  final Map<String, String?> headers = {};

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = headers['Token'];
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    final filteredParams = filterParams(options.data);
    if (filteredParams.isNotEmpty) {
      options.data = filteredParams;
    }
    headers.remove("Token");
    options.headers.addAll(headers);
    super.onRequest(options, handler);
  }
}

Map<String, dynamic> filterParams(dynamic params) {
  Map<String, dynamic> filteredParams = {};

  params.forEach((key, value) {
    if (value is Map<String, dynamic>) {
      Map<String, dynamic> filteredNestedParams = filterParams(value);

      if (filteredNestedParams.isNotEmpty) {
        filteredParams[key] = filteredNestedParams;
      }
    } else if (value != null) {
      filteredParams[key] = value;
    }
  });

  return filteredParams;
}

class AppService {
  late final Dio client;
  static final AppService _singleton = AppService._internal();

  factory AppService() {
    return _singleton;
  }

  AppService._internal();

  Future<void> initConfig(String url) async {
    client = Dio(BaseOptions(
      baseUrl: url,
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: {},
    ));

    client.interceptors.addAll([
      BearerAuthInterceptor(),
    ]);
  }

  void setBearerAuth(String? token) {
    if (client.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (client.interceptors.firstWhere((i) => i is BearerAuthInterceptor)
              as BearerAuthInterceptor)
          .headers["Token"] = token;
    }
  }

  void setHeaderOptions(String key, String value) {
    if (client.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (client.interceptors.firstWhere((i) => i is BearerAuthInterceptor)
              as BearerAuthInterceptor)
          .headers[key] = value;
    }
  }
}

Future<T> rpc<T, M>(
  String method, {
  Object? params,
  Map<String, dynamic>? headers,
  CancelToken? cancelToken,
}) async {
  var apiResponse = await AppService().client.post(
        "/rpc/business",
        data: {
          "method": method,
          "jsonrpc": "2.0",
          "id": 1,
          "params": params ?? {},
        },
        cancelToken: cancelToken,
      );

  // print("\n\n\n=========\n\n${apiResponse.data}\n\n\n=========\n\n\n");

  if (apiResponse.data?['error']?['code'] != null) {
    throw AppError(
      message: apiResponse.data['error']['message'],
      status: apiResponse.data['error']['status'] ?? "",
      code: apiResponse.data['error']['code'].toString(),
      statusCode: apiResponse.data['error']['statusCode']?.toString(),
    );
  }

  if (apiResponse.data != null) {
    return apiResponse.data['result'];
  }

  throw AppError(
    message: "server_error.401004",
    status: "",
    code: "401004",
    statusCode: "0",
  );
}
