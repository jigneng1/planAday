import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:plan_a_day/services/auth_token.dart';

class ApiService {
  String apiKey = dotenv.env['API_URL'] ?? 'No API key found';
  // Function to send planData to the API and return the random places data
  Future<Map<String, dynamic>?> getRandomPlan(
      Map<String, dynamic> inputplanData) async {
    final url = Uri.parse('$apiKey/nearby-search');
    int hour = int.parse(inputplanData['startTime'].split(':')[0]);
    int minute = int.parse(inputplanData['startTime'].split(':')[1]);

    var token = await getToken();

    try {
      // Sending the request to get the plan ID
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "lad": inputplanData['lad'],
          "lng": inputplanData['lng'],
          "category": inputplanData['categories'],
          "startDay": inputplanData['startDay'],
          "startHour": hour,
          "startMinute": minute,
        }),
      );

      if (response.statusCode == 200) {
        print('Plan data sent successfully');
        print(response.body);

        // Parsing the response and getting the plan ID
        final responseData = jsonDecode(response.body);
        final String planID = responseData['id'];
        final numberOfPlace = inputplanData['numberOfPlaces'];

        // Fetching random places
        final placesUrl =
            Uri.parse("$apiKey/randomPlaces?id=$planID&places=$numberOfPlace");
        final placesResponse = await http
            .get(placesUrl, headers: {'Authorization': 'Bearer $token'});

        if (placesResponse.statusCode == 200) {
          print('Random places fetched successfully');

          // Parse the places data
          final planData = jsonDecode(placesResponse.body);
          final List<dynamic> places = planData['data'];
          final List<Map<String, dynamic>> placesList = [
            for (var place in places)
              {
                "id": place['id'],
                "displayName": place['displayName'],
                "primaryType": place['primaryType'],
                "shortFormattedAddress": place['shortFormattedAddress'],
                "photosUrl": place['photosUrl'],
                "time": place['time']
              }
          ];

          final Map<String, dynamic> fullPlan = {
            'planName': inputplanData['planName'],
            'startTime': inputplanData['startTime'],
            'startDate': inputplanData['startDate'],
            'category': inputplanData['categories'],
            'numberOfPlaces': inputplanData['numberOfPlaces'],
            'planID': planID,
            'selectedPlaces': placesList,
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

  Future<List<Map<String, dynamic>?>?> getRandomPlaces(
      String planID, int numberOfPlace) async {
    var token = await getToken();
    final placesUrl =
        Uri.parse("$apiKey/randomPlaces?id=$planID&places=$numberOfPlace");
    final placesResponse =
        await http.get(placesUrl, headers: {'Authorization': 'Bearer $token'});

    if (placesResponse.statusCode == 200) {
      print('Random places fetched successfully');

      // Parse the places data
      final planData = jsonDecode(placesResponse.body);
      final List<dynamic> places = planData['data'];

      // Convert the List<dynamic> to List<Map<String, dynamic>?>
      List<Map<String, dynamic>?> placesList = [
        for (var place in places) Map<String, dynamic>.from(place)
      ];

      return placesList; // Return the list instead of a map
    } else {
      print('Failed to fetch random places: ${placesResponse.statusCode}');
      return null;
    }
  }

  Future<List<Map<String, String>>> getTimeTravel(List<String> placeIds) async {
    List<Map<String, String>> travelTimes = [];
    var token = await getToken();

    // Loop through the places to get travel times between consecutive places
    for (int i = 0; i < placeIds.length - 1; i++) {
      final String origin = placeIds[i];
      final String destination = placeIds[i + 1];

      final travelTimeUrl = Uri.parse(
          "$apiKey/timeTravel?origin=$origin&destination=$destination");

      final travelTimeResponse = await http
          .get(travelTimeUrl, headers: {'Authorization': 'Bearer $token'});

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

  Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    var token = await getToken();

    try {
      final response = await http.get(Uri.parse('$apiKey/placeDetail/$placeId'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Check if the 'data' key exists and contains the place details
        if (jsonResponse['data'] != null) {
          return jsonResponse['data'];
        } else {
          throw Exception("Place details not found in response");
        }
      } else {
        throw Exception(
            "Failed to load place details, status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error fetching place details: $e');
      return {}; // Return an empty map in case of error
    }
  }

  Future<Map<String, dynamic>?> getPlanDetail(String planID) async {
    final url = Uri.parse('$apiKey/getPlanDetailByid/$planID');
    var token = await getToken();

    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('Failed to fetch plan details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching place details: $e');
      return {}; // Return an empty map in case of error
    }
  }

  //ส่งสถานที่ทั้งหมดไปให้ API
  Future<Map<String, dynamic>?> getNewPlace(
      String placeReplaceID, List<String> places) async {
    final url = Uri.parse('$apiKey/getNewPlace');
    var token = await getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          "placeReplaceId": placeReplaceID,
          "placesList": places,
        }),
      );

      if (response.statusCode == 200) {
        print('Place data sent successfully');
        final responseData = jsonDecode(response.body);
        final newPlace = responseData['data'];
        // print('++++++++++++');
        // print('responsData $responseData');
        return newPlace;
      } else {
        print('Failed to send data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching place details: $e');
      return {}; // Return an empty map in case of error
    }
  }

  Future<Map<String, dynamic>?> generateMorePlace(
      String planID, List<String> places) async {
    final url = Uri.parse("$apiKey/getGenMorePlace");
    var token = await getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          "planId": planID,
          "placesList": places,
        }),
      );

      if (response.statusCode == 200) {
        print('Place data sent successfully');
        final responseData = jsonDecode(response.body);
        final newPlace = responseData['data'];
        // print('++++++++++++');
        // print('responsData $responseData');
        return newPlace;
      } else {
        print('Failed to send data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching place details: $e');
      return {}; // Return an empty map in case of error
    }
  }

  Future<String> savePlan(Map<String, dynamic>? planData) async {
    final url = Uri.parse("$apiKey/createPlan");
    var token = await getToken();

    // Check if planData is null before proceeding
    if (planData == null) {
      print('Plan data is null');
      return ''; // Return false if no plan data is provided
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(planData), // Send the full planData as JSON
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] = true) {
          print('Plan saved successfully');
          return responseData['planId']; // Return the plan ID if successful
        } else {
          print('Failed to send data: ${response.statusCode}');
          return ''; // Return an empty string if there was an error
        }
      } else {
        print('Failed to send data: ${response.statusCode}');
        return ''; // Return false if there was an error
      }
    } catch (e) {
      print('Error fetching place details: $e');
      return ''; // Return false in case of error
    }
  }

  Future<List<Map<String, dynamic>>> getSuggestPlansbyCategory(
      String category) async {
    final url = Uri.parse('$apiKey/getPlanByInterest/$category');
    var token = await getToken();

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success']) {
        final List<dynamic> plansList = responseData['plansList'];
        final List<Map<String, dynamic>> suggestPlans =
            plansList.map((plan) => plan as Map<String, dynamic>).toList();

        return suggestPlans;
      }
    } else {
      print('Failed to fetch suggest plans: ${response.statusCode}');
      return [];
    }
    return [];
  }

  Future<List<Map<String, dynamic>>?> getHomeSuggestPlans() async {
    final url = Uri.parse('$apiKey/suggestPlan');
    var token = await getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // print(responseData);
      final List<dynamic> plansList = responseData['plansList'];

      // Convert each item in plansList to Map<String, dynamic>
      final List<Map<String, dynamic>> allPlans =
          plansList.map((plan) => plan as Map<String, dynamic>).toList();

      // Shuffle and get the first 3 items if the list is large enough
      if (allPlans.length > 3) {
        allPlans.shuffle(Random());
        return allPlans.take(3).toList();
      }

      // If less than or exactly 3 items, return the entire list
      return allPlans;
    } else {
      print('Failed to fetch suggest plans: ${response.statusCode}');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getPlanHistory() async {
    final url = Uri.parse('$apiKey/getPlanHistory');
    var token = await getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // Check if planHistory is present and is a list
      if (responseData['planHistory'] is List) {
        final List<dynamic> plansList = responseData['planHistory'];
        final List<Map<String, dynamic>> historyPlans =
            plansList.map((plan) => plan as Map<String, dynamic>).toList();
        // print('Response data: $responseData');
        return historyPlans;
      } else {
        print('planHistory is null or not a List');
        return [];
      }
    } else {
      print('Failed to fetch suggest plans: ${response.statusCode}');
      return [];
    }
  }

  Future<bool> sharePlan(String planID) async {
    final url = Uri.parse("$apiKey/createpublicPlan");
    var token = await getToken();

    // Check if planID is null or empty before proceeding
    if (planID == '') {
      print('Plan ID is empty');
      return false; // Return false if no plan ID is provided
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'planId': planID,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] = true) {
          print('Plan shared public successfully');
          return true; // Return true if the data was sent successfully
        } else {
          print('Failed to send data: ${response.statusCode}');
          return false; // Return false if there was an error
        }
      } else {
        print('Failed to send data: ${response.statusCode}');
        return false; // Handle non-200 status codes
      }
    } catch (e) {
      print('Error fetching place details: $e');
      return false; // Return false in case of error
    }
  }

  Future<bool> createBookmark(String planID) async {
    final url = Uri.parse("$apiKey/createBookmark/$planID");
    var token = await getToken();

    if (planID == '') {
      print('Plan ID is empty');
      return false;
    }

    try {
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == "success") {
          print('Bookmark $planID created successfully');
          return true;
        } else {
          print('Failed to send data: ${response.statusCode}');
          return false;
        }
      } else {
        print('Failed to send data: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error fetching place details: $e');
      return false;
    }
  }

  Future<bool> deleteBookmark(String planID) async {
    final url = Uri.parse("$apiKey/deleteBookmark/$planID");
    var token = await getToken();

    if (planID == '') {
      print('Plan ID is empty');
      return false;
    }

    try {
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == "success") {
          print('Bookmark $planID deleted successfully');
          return true;
        } else {
          print('Failed to delete bookmark: ${response.statusCode}');
          return false;
        }
      } else {
        print('Failed to send data: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error fetching delete bookmark: $e');
      return false;
    }
  }

Future<List<Map<String, dynamic>>> getBookmarkLists() async {
  final url = Uri.parse('$apiKey/getBookmark');
  var token = await getToken();

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      
      // Check if the response indicates success and contains the planList
      if (responseData['success']) {
        final List<dynamic> plansList = responseData['planList'];
        
        // Ensure that we correctly map the plansList to List<Map<String, dynamic>>
        final List<Map<String, dynamic>> historyPlans = 
            List<Map<String, dynamic>>.from(plansList.map((plan) => plan as Map<String, dynamic>));

        return historyPlans;
      } else {
        print('Failed to fetch Bookmark lists: No plan list found or not successful');
        return []; // Return an empty list if no plans found
      }
    } else {
      print('Failed to fetch Bookmark lists: ${response.statusCode}');
      return []; // Return an empty list on HTTP error
    }
  } catch (e) {
    print('Error fetching Bookmark lists: $e');
    return []; // Return an empty list on error
  }
}

  Future<bool> deletePlan(String planID) async {
    final url = Uri.parse("$apiKey/deletePlan/$planID");
    var token = await getToken();

    if (planID == '') {
      print('Plan ID is empty');
      return false;
    }

    try {
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] = true) {
          print('Plan $planID deleted successfully');
          return true;
        } else {
          print('Failed to send data: ${response.statusCode}');
          return false;
        }
      } else {
        print('Failed to send data: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error fetching place details: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserDetail() async {
    final url = Uri.parse('$apiKey/userDetail');
    var token = await getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Check if the request was successful and return the user data
      if (responseData['success']) {
        return responseData['user']; // Return the user data directly
      } else {
        print('Failed to fetch user details: No user data');
        return null;
      }
    } else {
      print('Failed to fetch user details: ${response.statusCode}');
      return null;
    }
  }

  Future<List<String>> getInterest() async {
  final url = Uri.parse('$apiKey/getInterest');
  var token = await getToken();

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);

    if (responseData['status'] == 'success' && responseData['interest'] is List) {
      // Explicitly cast to List<String>
      return List<String>.from(responseData['interest']);
    } else {
      print('Failed to fetch user interests: No user data');
      return [];
    }
  } else {
    print('Failed to fetch user interests: ${response.statusCode}');
    return [];
  }
}
}

class AuthService {
  String apiKey = dotenv.env['API_URL'] ?? 'No API key found';

  // Register API
  Future<Map<String, dynamic>> registerUser(
      String username, String password) async {
    final url = Uri.parse('$apiKey/register');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'Failed to register user'};
      }
    } catch (error) {
      return {'status': 'error', 'message': error.toString()};
    }
  }

  // Login API
  Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    final url = Uri.parse('$apiKey/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'Failed to login'};
      }
    } catch (error) {
      return {'status': 'error', 'message': error.toString()};
    }
  }
}
