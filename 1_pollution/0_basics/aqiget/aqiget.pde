/*
  Basic AQI JSON from waqi.info getting test based on jsonget example in http-requests library
  By: Mayank Joneja
  Date: 02-01-2019
*/

import http.requests.*;

String AQI_TOKEN = "ENTER-TOKEN-HERE"; // Token generated from waqi.info
int POLLING_INTERVAL = 2;
String city = "delhi";

public void setup() 
{
	size(400,400);
	smooth();
  println("Aqidata for " + city + " polled every " + POLLING_INTERVAL + " seconds:");
}

void draw() {
  println(getAqi(city));
  delay(POLLING_INTERVAL * 1000); // milliseconds
}

int getAqi(String city) {
  String AQI_URL = "https://api.waqi.info/feed/" + city + "/?token=" + AQI_TOKEN;
  GetRequest get = new GetRequest(AQI_URL);
  get.send(); // program will wait untill the request is completed
  //println("response: " + get.getContent());

  JSONObject response = parseJSONObject(get.getContent());
  
  String status = response.getString("status");
  if(!status.equals("ok")) {
    println("GET request to https://api.waqi.info/feed failed! Status: " + status);
    return -1;
  }
  
  JSONObject aqidata = response.getJSONObject("data");
  return aqidata.getInt("aqi");
}