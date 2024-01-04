import 'dart:convert';

import 'package:dolan_yuk/data/data.dart';
import 'package:dolan_yuk/models/schedule.dart';
import 'package:http/http.dart' as http;

class ScheduleService {
  static String Url = '${API}/schedules';
  static Future<http.Response> getAll(int id) async {
    var url = "$Url/mine/$id";
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    });
    // var data = jsonDecode(response.body);
    return response;
  }

  static Future<http.Response> seacrhByName(String keywoard) async {
    var url = "$Url/search/$keywoard";
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    });
    // var data = jsonDecode(response.body);
    return response;
  }

  static Future<http.Response> join(int id_user, int id_schedule) async {
    var url = "$Url/joingroup";
    var body = jsonEncode({"id_user": id_user, "id_schedule": id_schedule});
    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: body);
    // var data = jsonDecode(response.body);
    return response;
  }

  static Future<http.Response> getMember(int id) async {
    var url = "$Url/member/$id";
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    });
    // var data = jsonDecode(response.body);
    return response;
  }

  static Future<http.Response> getDolan() async {
    var url = "$Url/getAll";
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    });
    // var data = jsonDecode(response.body);
    return response;
  }

  static Future<http.Response> addSchedule(Schedule schedule, int id) async {
    var url = '$Url/add/$id';
    var body = json.encode(schedule.toJson);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print(response.body);
    return response;
  }
}
