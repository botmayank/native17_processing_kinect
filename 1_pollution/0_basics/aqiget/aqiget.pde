/*
  Basic AQI JSON from waqi.info getting test based on jsonget example in http-requests library
  https://github.com/acdean/HTTP-Requests-for-Processing
  By: Mayank Joneja
  Date: 02-01-2019
*/

import http.requests.*;

String AQI_TOKEN = "ENTER-TOKEN-HERE"; // Token generated from waqi.info
int POLLING_INTERVAL = 2; // Don't go faster than once per second preferably

//String city = "delhi"; //city name or @station-id
String city = "@2556"; //R.K. Puram

/* 
To search for station-id, change the keyword field in:
  https://api.waqi.info//search/?token=ENTER_TOKEN_HERE&keyword=rk puram
  Take the "uid" parameter.
*/

public void setup() 
{
	size(400,400);
	smooth();
  println("Aqidata for " + city + " polled every " + POLLING_INTERVAL + " seconds:");
}

void draw() {
  println("AQI value: " + getAqi(city));
  delay(POLLING_INTERVAL * 1000); // milliseconds
}

int getAqi(String city) {
  String AQI_URL = "https://api.waqi.info/feed/" + city + "/?token=" + AQI_TOKEN;
  GetRequest get = new GetRequest(AQI_URL);
  get.send(); // program will wait untill the request is completed

  JSONObject response = parseJSONObject(get.getContent());
  
  String status = response.getString("status");
  if(!status.equals("ok")) {
    println("GET request to " + AQI_URL + " failed! Status: " + status);
    println(response.getString("data"));
    return -1;
  }
  
  //println("response: " + get.getContent());
  
  // Parsing of response
  JSONObject aqidata = response.getJSONObject("data");
  return aqidata.getInt("aqi");
}