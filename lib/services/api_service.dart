import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Function to send planData to the API and return the random places data
  Future<Map<String, dynamic>?> sendJsonData(Map<String, dynamic> planData) async {
    final url = Uri.parse('http://localhost:3000/nearby-search'); // Replace with your API endpoint

    try {
      // Send the planData to the API
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(planData), // Sending the planData in JSON format
      );

      if (response.statusCode == 200) {
        print('Data sent successfully');

        // Parse the response body to extract the plan ID
        final responseData = jsonDecode(response.body);
        final String planID = responseData['id']; // Assuming 'id' is the field in the response

        if (planID != null) {
          // Fetch the random places using the planID
          final placesUrl = Uri.parse("http://localhost:3000/randomPlaces?id=$planID&places=4");
          final placesResponse = await http.get(placesUrl);

          if (placesResponse.statusCode == 200) {
            print('Random places fetched successfully');
            // Parse and return the places data
            return jsonDecode(placesResponse.body); 
          } else {
            print('Failed to fetch random places: ${placesResponse.statusCode}');
            return null;
          }
        } else {
          print('No planID found in the response');
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
