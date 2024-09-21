import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Function to send planData to the API and return the random places data
  Future<Map<String, dynamic>?> getRandomPlan(
      Map<String, dynamic> inputplanData) async {
    final url = Uri.parse('http://localhost:3000/nearby-search');
    // final url = Uri.parse('http://10.0.2.2:3000/nearby-search'); // Use this for Android Emulator

    try {
      // Sending the request to get the plan ID
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "lad": inputplanData['lad'],
          "lng": inputplanData['lng'],
          "category": inputplanData['categories'],
        }),
      );

      if (response.statusCode == 200) {
        print('Plan data sent successfully');

        // Parsing the response and getting the plan ID
        final responseData = jsonDecode(response.body);
        final String planID = responseData['id'];
        final numberOfPlace = inputplanData['numberOfPlaces'];

        // Fetching random places
        final placesUrl = Uri.parse(
            "http://localhost:3000/randomPlaces?id=$planID&places=$numberOfPlace");
        final placesResponse = await http.get(placesUrl);

        if (placesResponse.statusCode == 200) {
          print('Random places fetched successfully');

          // Parse the places data
          final planData = jsonDecode(placesResponse.body);
          final List<dynamic> places = planData['data'];
          final Map<String, dynamic> placesMap = {
            for (var place in places) place['id']: place
          };

          // If onlyPlace is false, return the full plan
          final Map<String, dynamic> fullPlan = {
            'planName': inputplanData['planName'],
            'startTime': inputplanData['startTime'],
            'startDate': inputplanData['startDate'],
            'numberOfPlaces': inputplanData['numberOfPlaces'],
            'planID' : planID,
            'selectedPlaces': placesMap,
          };
          return fullPlan;
        } else {
          print('Failed to fetch random places: ${placesResponse.statusCode}');
          return null;
        }
      } else {
        print('Failed to send data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getRandomPlaces(
      String planID, int numberOfPlace) async {
    final placesUrl = Uri.parse(
            "http://localhost:3000/randomPlaces?id=$planID&places=$numberOfPlace");
        final placesResponse = await http.get(placesUrl);

        if (placesResponse.statusCode == 200) {
          print('Random places fetched successfully');

          // Parse the places data
          final planData = jsonDecode(placesResponse.body);
          final List<dynamic> places = planData['data'];
          final Map<String, dynamic> placesMap = {
            for (var place in places) place['id']: place
          };

          return placesMap;
        } else {
          print('Failed to fetch random places: ${placesResponse.statusCode}');
          return null;
        }
  }

  Future<List<Map<String, String>>> getTimeTravel(List<String> placeIds) async {
  List<Map<String, String>> travelTimes = [];

  // Loop through the places to get travel times between consecutive places
  for (int i = 0; i < placeIds.length - 1; i++) {
    final String origin = placeIds[i];
    final String destination = placeIds[i + 1];
    
    final travelTimeUrl = Uri.parse(
        "http://localhost:3000/timeTravel?origin=$origin&destination=$destination");
    
    final travelTimeResponse = await http.get(travelTimeUrl);
    
    if (travelTimeResponse.statusCode == 200) {
      // print('Travel time fetched successfully between $origin and $destination');
      
      // Parse the travel time data
      final travelTimeData = jsonDecode(travelTimeResponse.body);
      
      // Add driving and walking times to the result list
      travelTimes.add({
        'driving': travelTimeData['driving'] ?? 'N/A',
        'walking': travelTimeData['walking'] ?? 'N/A',
      });
    } else {
      print('Failed to fetch travel time: ${travelTimeResponse.statusCode}');
      
      // Add a placeholder in case of failure
      travelTimes.add({
        'driving': 'N/A',
        'walking': 'N/A',
      });
    }
  }

  return travelTimes;
}
}
