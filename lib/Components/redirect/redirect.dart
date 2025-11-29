import 'package:http/http.dart' as http;

class RedirectClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.followRedirects = true;
    request.maxRedirects = 5;
    return _inner.send(request);
  }
}
