import 'dart:convert';

import 'package:http/http.dart' as http;


String  apikey =  "";
class API_services{




  static String baseURl = "https://chatgpt-api.shn.hk/v1/";

   static Map<String,String> header = {'Content-type': 'application/json', 'Authorization': 'Bearer $apikey'};

   static  send_message(String message) async {
    var res = await http.post(Uri.parse(baseURl), headers: header,body: jsonEncode({
      "model": "gpt-3.5-turbo",
      "prompt": "$message",
      "temperature": 0,
      "max_tokens": 1000,
      "top_p": 1,
      "frequency_penalty": 0.0,
      "presence_penalty": 0.0,
      "stop": ["Human:", "AI:"]

    })

    );
    if(res.statusCode == 200)
      {
        var data = jsonDecode(res.body.toString());
        var msg = data['choices'][0]['text'];

        return msg;
      }
    else
      {
        print("Failed to fetch data");
      }

  }




}