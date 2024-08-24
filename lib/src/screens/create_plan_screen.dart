import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatePlanScreen extends StatefulWidget {
  const CreatePlanScreen({super.key});

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
    'Entertainment',
    'Sport',
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
      title: const Text('Create new plan'),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _planNameController,
            decoration: InputDecoration(
              floatingLabelStyle: TextStyle(color: primaryColor),
              labelText: 'Plan name',
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
            height: 150,
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
                      ),
                    ),
                ),
              ),
              const SizedBox(height: 40),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Number of places',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(width: 5),
                  Text('(optional)',
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
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
                    width: 100, // Fixed width for number of places input
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
          const Spacer(),
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
  );
}


}
