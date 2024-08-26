import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatePlanScreen extends StatefulWidget {
  final VoidCallback onClose;

  const CreatePlanScreen({super.key, required this.onClose});

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final TextEditingController _planNameController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _numberOfPlacesController =
      TextEditingController(text: '1');
  final List<String> _activities = [
    'Popular',
    'Cafe',
    'Food and Drink',
    'Shopping',
    'Sport',
    'Entertainment',
    'Museum',
    'Services'
  ];
  final Set<String> _selectedActivities = {}; // Initially empty

  @override
  void dispose() {
    _planNameController.dispose();
    _startTimeController.dispose();
    _numberOfPlacesController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new plan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            widget.onClose();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Plan name',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                controller: _planNameController,
                decoration: InputDecoration(
                  floatingLabelStyle: TextStyle(color: primaryColor),
                  hintText: 'What\'s your plan called?',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text('Select activity/plan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _activities.map((activity) {
                  final isSelected = _selectedActivities.contains(activity);
                  return FilterChip(
                    label: Text(activity,
                        style: TextStyle(
                            color: isSelected ? Colors.white : primaryColor)),
                    selected: isSelected,
                    selectedColor: primaryColor,
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                        color: isSelected ? primaryColor : primaryColor),
                    onSelected: (bool selected) {
                      _toggleActivity(activity);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              const Text('Location area',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
                child: const Center(
                  child: Icon(Icons.map, size: 100, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _selectStartTime(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _startTimeController,
                        decoration: const InputDecoration(
                          labelText: 'Start time',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.access_time),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 16.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Number of places',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      SizedBox(width: 8),
                      Text('(optional)',
                          style: TextStyle(fontSize: 15, color: Colors.grey)),
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
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                          ),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            final newValue = int.tryParse(value) ?? 1;
                            if (newValue < 1) {
                              _numberOfPlacesController.text = '1';
                            } else if (newValue > 10) {
                              _numberOfPlacesController.text = '10';
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _incrementNumberOfPlaces,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle plan generation logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Text(
                    'Generate plan',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
