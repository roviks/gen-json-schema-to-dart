var a = '''static Future<{{resultModel}}> login({{paramsModel}} params) async {
    var res = await rpc(
      {{method}},
      {{params}},
    );

   return {{result}};
  }''';
