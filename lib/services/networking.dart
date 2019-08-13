
import 'package:http/http.dart';

class NetworkHelper {

  Future<Response> getUrl(var url) async {
    var response = await get(url);
    return response;
  }
}