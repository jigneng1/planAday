import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final TextEditingController _planNameController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _startDateController =
      TextEditingController(); // New date controller
  final TextEditingController _numberOfPlacesController =
      TextEditingController(text: '1');
  final List<String> _activities = [
    'Restaurant',
    'Cafe',
    'Gym',
    'Art_gallery',
    'Movie_theater',
    'Park',
    'Museum',
    'Store'
  ];
  final Set<String> _selectedActivities = {}; // Initially empty
  GoogleMapController? _mapController; // Controller for Google Map
  LatLng? _selectedLocation; // Variable to store the selected location
  LatLng? _currentLocation; // Variable to store the current location
  bool _hasTriedSubmitting =
      false; // Flag to track if user has attempted submission
  String? _selectedPlaceName; // Variable to store the selected place name

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    // _selectedPlaceName = 'Default Current Place';

    // Add listeners to update `_hasTriedSubmitting` when input changes
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
      firstDate: DateTime(2000),
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
      final formattedDate = "${picked.day}/${picked.month}/${picked.year}";
      setState(() {
        _startDateController.text = formattedDate;
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
          // Store the place name to display later
          _selectedPlaceName = placeName;
        });
      }
    } catch (e) {
      print("Error getting place name: $e");
    }
  }

  void _generatePlan() {
    setState(() {
      _hasTriedSubmitting = true; // Set flag to true when generating plan
    });

    if (_formKey.currentState?.validate() ?? false) {
      // Check if location is selected before generating plan
      // if (_selectedLocation == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Please select a location on the map.')),
      //   );
      //   return;
      // }

      final Map<String, dynamic> planData = {
        'planName': _planNameController.text,
        'startTime': _startTimeController.text,
        'startDate': _startDateController.text,
        'numberOfPlaces': int.tryParse(_numberOfPlacesController.text) ?? 1,
        'categories': _selectedActivities
            .map((activity) => activity.toLowerCase())
            .toList(),
        'lad':
            _selectedLocation?.latitude.toString(), // Ensure this is non-null
        'lng': _selectedLocation?.longitude.toString(),
      };

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plan name',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                  validator: (value) {
                    if (_hasTriedSubmitting &&
                        (value == null || value.isEmpty)) {
                      return 'Please enter a plan name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                const Text(
                  'Select place',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _activities.map((activity) {
                    final isSelected = _selectedActivities.contains(activity);
                    return FilterChip(
                      label: Text(
                        activity,
                        style: TextStyle(
                            color: isSelected ? Colors.white : primaryColor),
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 220,
                  width: double.infinity,
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
                          markers: _selectedLocation != null
                              ? {
                                  Marker(
                                    markerId:
                                        const MarkerId('selected_location'),
                                    position: _selectedLocation!,
                                  ),
                                }
                              : {},
                          onTap: _onMapTap,
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
                          // Make the column expandable
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
                                maxLines: 1, // Ensures a single line
                                overflow:
                                    TextOverflow.ellipsis, // Truncates overflow
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              prefixIcon: Icon(Icons.calendar_today),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 16.0),
                            ),
                            // Validator for the start date
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
                    const SizedBox(
                        width: 16), // Adds space between the two fields
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectStartTime(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _startTimeController,
                            decoration: const InputDecoration(
                              labelText: 'Start time',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
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
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Number of places',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '(optional)',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _decrementNumberOfPlaces,
                    ),
                    SizedBox(
                      width: 80, // Fixed width for number of places input
                      child: TextField(
                        controller: _numberOfPlacesController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _generatePlan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 110,
                      ),
                    ),
                    child: const Text(
                      'Generate Plan',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
