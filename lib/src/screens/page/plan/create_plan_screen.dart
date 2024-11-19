import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:plan_a_day/services/api_service.dart';
import 'package:plan_a_day/services/network_utility.dart';

class CreatePlanScreen extends StatefulWidget {
  final VoidCallback onClose;
  final Function(Map<String, dynamic>) onGeneratePlan;

  const CreatePlanScreen({
    super.key,
    required this.onClose,
    required this.onGeneratePlan,
  });

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  String googleapiKey = dotenv.env['GOOGLE_MAP_KEY']!;
  final TextEditingController _planNameController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _searchPlaceController = TextEditingController();
  final TextEditingController _startDateController =
      TextEditingController(); // New date controller
  final TextEditingController _numberOfPlacesController =
      TextEditingController(text: '1');
  final List<String> _activities = [
    'Restaurant',
    'Cafe',
    'Park',
    'Store',
    'Gym',
    'Art_gallery',
    'Movie_theater',
    'Museum',
  ];
  final Set<String> _selectedActivities = {};
  List<Map<String, String>> predictedPlaces = [];
  Map<String, dynamic> selectedSearchPlace = {};
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  LatLng? _currentLocation;
  bool _hasTriedSubmitting = false;
  String? _selectedPlaceName;
  int? _dayOfWeek;
  bool _showDropdown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });

    _planNameController.addListener(_onInputChange);
    _startTimeController.addListener(_onInputChange);
    _startDateController.addListener(_onInputChange);
    _numberOfPlacesController.addListener(_onInputChange);
  }

  @override
  void dispose() {
    _planNameController.removeListener(_onInputChange);
    _startTimeController.removeListener(_onInputChange);
    _startDateController.removeListener(_onInputChange);
    _numberOfPlacesController.removeListener(_onInputChange);

    _planNameController.dispose();
    _startTimeController.dispose();
    _startDateController.dispose();
    _numberOfPlacesController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onInputChange() {
    if (_hasTriedSubmitting) {
      setState(() {
        _hasTriedSubmitting = false;
      });
    }
  }

  void _toggleActivity(String activity) {
    setState(() {
      if (_selectedActivities.contains(activity)) {
        _selectedActivities.remove(activity);
      } else {
        _selectedActivities.add(activity);
      }
    });
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  Theme.of(context).primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface:
                  Theme.of(context).primaryColor, // Time picker dial color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Theme.of(context).primaryColor, // Button text color
              ),
            ),
            timePickerTheme: const TimePickerThemeData(
              helpTextStyle: TextStyle(
                fontSize: 24, // Increase the size of the "Select time" text
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formattedTime = picked.format(context);
      setState(() {
        _startTimeController.text = formattedTime;
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  Theme.of(context).primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface:
                  Theme.of(context).primaryColor, // Calendar picker color
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      int dayOfWeek = (picked.weekday % 7);
      final formattedDate = "${picked.day}/${picked.month}/${picked.year}";
      setState(() {
        _startDateController.text = formattedDate;
        _dayOfWeek = dayOfWeek;
      });
    }
  }

  void _incrementNumberOfPlaces() {
    final currentValue = int.tryParse(_numberOfPlacesController.text) ?? 1;
    if (currentValue < 10) {
      _numberOfPlacesController.text = (currentValue + 1).toString();
    }
  }

  void _decrementNumberOfPlaces() {
    final currentValue = int.tryParse(_numberOfPlacesController.text) ?? 1;
    if (currentValue > 1) {
      _numberOfPlacesController.text = (currentValue - 1).toString();
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, do not continue
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, do not continue
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, handle appropriately
      return Future.error('Location permissions are permanently denied.');
    }

    // Get the current location
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    // Move the camera to the current location
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(_currentLocation!),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(_currentLocation!),
      );
    }
  }

  void _onMapTap(LatLng location) async {
    setState(() {
      _selectedLocation = location;
    });

    await _getPlaceName(location);
  }

  void placeAutoComplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        '/maps/api/place/autocomplete/json',
        {"input": query, "key": googleapiKey, "components" : "country:th"});

    Map<String, dynamic>? response = await NetworkUtility.fetchUrl(uri);

    if (response != null && response['predictions'] != null) {
      predictedPlaces.clear();
      for (var data in response['predictions']) {
        Map<String, String> prediction = {
          'name': data['structured_formatting']['main_text'],
          'id': data['place_id']
        };
        setState(() {
          predictedPlaces.add(prediction);
        });
        print(prediction);
      }
    }
    else{
      setState(() {
      predictedPlaces.clear();
    });
    }
  }

  void setPlaceladlng(String placeId) async {
    final place = await apiService.getPlaceDetails(placeId);
    print(placeId);

    if(place != null){
      setState(() {
        _currentLocation = LatLng(place['location']['latitude'], place['location']['longitude']);
        _selectedLocation = LatLng(place['location']['latitude'], place['location']['longitude']);
        _selectedPlaceName = place['displayName'];
      });
    }

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(_currentLocation!),
      );
    }
    
  }

  Future<void> _getPlaceName(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        String placeName = '${place.name}, ${place.locality}, ${place.country}';

        setState(() {
          _selectedPlaceName = placeName;
        });
      }
    } catch (e) {
      print("Error getting place name: $e");
    }
  }

  void _generatePlan() {
    setState(() {
      _hasTriedSubmitting = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      final startTime =
          _startTimeController.text.replaceAll(RegExp(r'[^0-9:]'), '');
      List<String> errorMessages = [];

      if (_selectedLocation == null) {
        errorMessages.add('Please select a location on the map.');
      }
      if (_planNameController.text.isEmpty) {
        List<String> placeWords = _selectedPlaceName.toString().split(' ');
        String areaName = placeWords.take(3).join(' ');
        setState(() {
          _planNameController.text = "$areaName at $startTime";
        });
      }
      if (_startTimeController.text.isEmpty) {
        errorMessages.add('Please select the start time.');
      }
      if (_startDateController.text.isEmpty) {
        errorMessages.add('Please select the start date.');
      }
      if (_selectedActivities.isEmpty) {
        errorMessages.add('Please select at least one activity.');
      }

      // Show all errors if any
      if (errorMessages.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.white,
              content: Text(errorMessages.join('\n'),
                  style: const TextStyle(color: Color(0xFFFF6838))),
              behavior: SnackBarBehavior.floating),
        );
        return;
      }

      final Map<String, dynamic> planData = {
        'planName': _planNameController.text,
        'startTime': startTime,
        'startDate': _startDateController.text,
        'numberOfPlaces': int.tryParse(_numberOfPlacesController.text) ?? 1,
        'categories': _selectedActivities
            .map((activity) => activity.toLowerCase())
            .toList(),
        'startDay': _dayOfWeek,
        'lad': _selectedLocation?.latitude.toString(),
        'lng': _selectedLocation?.longitude.toString(),
        // 'lad': '13.651366869948392',
        // 'lng': '100.49641061073015',
      };

      // print(planData);
      widget.onGeneratePlan(planData); // Pass the data to the parent
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create new plan',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            widget.onClose();
          },
        ),
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context)
                    .unfocus(); // Dismiss the keyboard when tapping outside the TextField
              },
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Plan name',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _planNameController,
                      decoration: InputDecoration(
                        floatingLabelStyle: TextStyle(color: primaryColor),
                        hintText: 'What\'s your plan called?',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      // validator: (value) {
                      //   if (_hasTriedSubmitting &&
                      //       (value == null || value.isEmpty)) {
                      //     return 'Please enter a plan name';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Select place',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 5,
                      children: _activities.map((activity) {
                        final isSelected =
                            _selectedActivities.contains(activity);
                        return FilterChip(
                          label: Text(
                            activity,
                            style: TextStyle(
                                color:
                                    isSelected ? Colors.white : primaryColor),
                          ),
                          selected: isSelected,
                          selectedColor: primaryColor,
                          showCheckmark: false,
                          side: BorderSide(
                              color: isSelected ? primaryColor : primaryColor),
                          onSelected: (bool selected) {
                            _toggleActivity(activity);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Location area',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        TextField(
                          controller: _searchPlaceController,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              placeAutoComplete(value);
                              setState(() {
                                _showDropdown = true;
                              });
                            } else {
                              setState(() {
                                _showDropdown = false;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Search location...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                String searchQuery =
                                    _searchPlaceController.text;
                                placeAutoComplete(searchQuery);
                                setState(() {
                                  _showDropdown = true;
                                });
                              },
                            ),
                          ),
                        ),
                        if (_showDropdown && predictedPlaces.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: predictedPlaces.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      predictedPlaces[index]['name'] ?? ''),
                                  onTap: () {
                                    setState(() {
                                      _searchPlaceController.text =
                                          predictedPlaces[index]['name'] ?? '';
                                      _showDropdown = false;
                                    });
                                    setPlaceladlng(predictedPlaces[index]['id']!);
                                    predictedPlaces.clear();
                                  },
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade300,
                        ),
                        child: _currentLocation == null
                            ? const Center(child: CircularProgressIndicator())
                            : GoogleMap(
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: _currentLocation!,
                                  zoom: 14.0,
                                ),
                                onTap: _onMapTap,
                                markers: _selectedLocation != null
                                    ? {
                                        Marker(
                                          markerId: const MarkerId(
                                              'selected_location'),
                                          position: _selectedLocation!,
                                        ),
                                      }
                                    : {},
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                scrollGesturesEnabled: true,
                                zoomGesturesEnabled: true,
                                rotateGesturesEnabled: false,
                                tiltGesturesEnabled: false,
                                gestureRecognizers: Platform.isIOS
                                    ? <Factory<OneSequenceGestureRecognizer>>{
                                        Factory<OneSequenceGestureRecognizer>(
                                          () => EagerGestureRecognizer(),
                                        ),
                                      }
                                    : {},
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_selectedLocation != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on, color: primaryColor),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selected location',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                                  ),
                                  Text(
                                    _selectedPlaceName ?? 'No place selected',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectStartDate(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _startDateController,
                                decoration: const InputDecoration(
                                  labelText: 'Start date',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  prefixIcon: Icon(Icons.calendar_today),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 16.0),
                                ),
                                validator: (value) {
                                  if (_hasTriedSubmitting &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please select a start date';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectStartTime(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _startTimeController,
                                decoration: const InputDecoration(
                                  labelText: 'Start time',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  prefixIcon: Icon(Icons.access_time),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 16.0),
                                ),
                                validator: (value) {
                                  if (_hasTriedSubmitting &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please select a start time';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Number of places',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _decrementNumberOfPlaces,
                        ),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: _numberOfPlacesController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _incrementNumberOfPlaces,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _generatePlan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          child: const Text(
                            'Generate Plan',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
