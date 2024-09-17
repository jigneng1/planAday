import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Function to send planData to the API and return the random places data
  Future<Map<String, dynamic>?> sendJsonData(
      Map<String, dynamic> inputplanData) async {
    final url = Uri.parse(
        'http://localhost:3000/nearby-search'); // Replace with your API endpoint
    // final url = Uri.parse('http://10.0.2.2:3000/nearby-search');

    try {
      // Send the planData to the API
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "lad": inputplanData['lad'],
          "lng": inputplanData['lng'],
          "category": ['restaurant'],
        }),
      );

      if (response.statusCode == 200) {
        print('Data sent successfully');

        // Parse the response body to extract the plan ID
        final responseData = jsonDecode(response.body);
        final String planID =
            responseData['id']; // Assuming 'id' is the field in the response

        final numberOfPlace = inputplanData['numberOfPlaces'];
        final placesUrl = Uri.parse(
            "http://localhost:3000/randomPlaces?id=$planID&places=$numberOfPlace");
        final placesResponse = await http.get(placesUrl);

        if (placesResponse.statusCode == 200) {
          print('Random places fetched successfully');
          // Parse and return the places data
          final planData = jsonDecode(placesResponse.body);
          final List<dynamic> places = planData['data'];
          final Map<String, dynamic> placesMap = {
            for (var place in places) place['id']: place
          };
          final Map<String, dynamic> finalPlan = {
            'planName': inputplanData['planName'],
            'startTime': inputplanData['startTime'],
            'startDate': inputplanData['startDate'],
            'numberOfPlaces': inputplanData['numberOfPlaces'],
            'selectedPlaces': placesMap,
          };
          print('Random places data: $finalPlan');
          return finalPlan;
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
