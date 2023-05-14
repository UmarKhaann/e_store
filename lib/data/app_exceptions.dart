class AppExceptions implements Exception{
  final String? _message;
  final String? _prefix;

  AppExceptions([this._message, this._prefix]);

  @override
  String toString(){
    return "$_prefix$_message";
  }
}

class UnauthorizedException extends AppExceptions{
  UnauthorizedException([String? message]) : super(message, "Unauthorized request: ");
}

class InvalidInputException extends AppExceptions{
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}