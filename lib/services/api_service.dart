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
            "category": inputplanData['categories'],
            "lad": inputplanData['lad'],
            "lng": inputplanData['lng'],
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

          return placesMap;
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
}
