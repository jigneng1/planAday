import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Function to send planData to the API
  Future<void> sendJsonData(Map<String, dynamic> planData) async {
    final url = Uri.parse('https://localhost:3000');  // Replace with your API endpoint

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(planData),  // Sending the received planData
      );

      if (response.statusCode == 200) {
        print('Data sent successfully');
      } else {
        print('Failed to send data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
