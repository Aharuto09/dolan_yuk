import 'package:dolan_yuk/data/data.dart';
import 'package:http/http.dart' as http;

class MessageService {
  static String Url = '${API}/message';

  static Future<http.Response> getMessage(int id) async {
    var url = "$Url/$id";
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    });
    // var data = jsonDecode(response.body);
    return response;
  }
}
