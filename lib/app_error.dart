part of "app_service.dart";

class AppError {
  AppError({
    required this.message,
    this.status,
    required this.code,
    this.statusCode,
  });

  final String message;
  final String? statusCode;
  final String? status;
  final String code;

  factory AppError.fromJson(Map<String, dynamic> json) => AppError(
        code: json["code"],
        message: json["message"],
        status: json["status"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "status": status,
        "code": code,
      };

  @override
  String toString() {
    return 'AppError(message: $message, statusCode: $statusCode, status: $status, code: $code)';
  }
}
