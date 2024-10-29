import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plan_a_day/services/api_service.dart';
import '../../components/place_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EditPlanScreen extends StatefulWidget {
  final Map<String, dynamic> planData;
  final VoidCallback onClose;
  final Function(Map<String, dynamic>) onDone;
  final Function(String planID) onCancel;
  final Function(String placeID, String planID) onViewPlaceDetail;

  const EditPlanScreen({
    super.key,
    required this.onClose,
    required this.planData,
    required this.onDone,
    required this.onCancel,
    required this.onViewPlaceDetail,
  });

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<EditPlanScreen> {
  final ApiService apiService = ApiService();
  late Map<String, dynamic> updatedPlan;
  late Map<String, dynamic> originalPlan;
  List<Map<String, dynamic>> deletedPlaces = [];

  @override
  void initState() {
    super.initState();
    updatedPlan = Map<String, dynamic>.from(widget.planData);
    originalPlan = Map<String, dynamic>.from(widget.planData);
  }

  void _editPlanName() async {
    final newPlanName = await showDialog<String>(
      context: context,
      builder: (context) {
        final TextEditingController controller = TextEditingController(
          text: updatedPlan['planName'] ?? '',
        );
        return AlertDialog(
          title: const Text('Edit Plan Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter new plan name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newPlanName != null) {
      setState(() {
        updatedPlan['planName'] = newPlanName;
      });
    }
  }

  void _editStartDate() async {
    DateTime initialDate;

    // Attempt to parse the string date and fallback to current date on failure
    try {
      // Parsing the start date string assuming it's in 'dd/MM/yyyy' format
      initialDate = updatedPlan['startDate'] != null
          ? DateFormat('dd/MM/yyyy').parse(updatedPlan['startDate'])
          : DateTime.now();
    } catch (e) {
      // If the string format is invalid or parsing fails, fallback to current date
      initialDate = DateTime.now();
    }

    // Show the date picker with primaryColor
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
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

    if (pickedDate != null) {
      setState(() {
        // Save the picked date as a formatted string in 'dd/MM/yyyy' format
        updatedPlan['startDate'] = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  void _restoreDismissedPlaces() {
    setState(() {
      for (var place in deletedPlaces) {
        // Directly add the place to the selectedPlaces list
        updatedPlan['selectedPlaces']?.add(place);
      }
      deletedPlaces.clear();

      updatedPlan['numberOfPlaces'] =
          updatedPlan['selectedPlaces']?.length ?? 0;
    });
  }

  void _generateMorePlace() async {
    // Fetch new place; assuming it returns a Map<String, dynamic> representing the place
    final newPlace = await apiService.generateMorePlace(
      updatedPlan['planID'],
      updatedPlan['selectedPlaces']!
          .map<String>((place) => place['id'] as String)
          .toList(),
    );

    if (newPlace != null && newPlace.containsKey('id')) {
      setState(() {
        // Ensure selectedPlaces is initialized as a List
        if (updatedPlan['selectedPlaces'] == null) {
          updatedPlan['selectedPlaces'] = []; // Initialize as an empty list
        }

        // Add the new place to selectedPlaces
        updatedPlan['selectedPlaces']!.add({
          'id': newPlace['id'],
          'displayName': newPlace['displayName'] ?? 'No place name',
          'primaryType': newPlace['primaryType'] ?? 'No type',
          'shortFormattedAddress':
              newPlace['shortFormattedAddress'] ?? 'No location',
          'photosUrl': newPlace['photosUrl'] ?? 'Image not available',
        });

        // Update the number of places
        updatedPlan['numberOfPlaces'] = updatedPlan['selectedPlaces']!.length;
      });
    } else {
      print('Error: New place data is invalid or missing ID');
    }
  }

  void regenerateOnePlace(String placeID) async {
    List<String> places = updatedPlan['selectedPlaces']!
        .map<String>((place) => (place as Map<String, dynamic>)['id'] as String)
        .toList();
    print(places);

    try {
      final newPlace = await apiService.getNewPlace(placeID, places);

      // Update the plan with the new place data
      setState(() {
        // Find the index of the place to update
        int index = updatedPlan['selectedPlaces']!
            .indexWhere((place) => place['id'] == placeID);
        if (index != -1) {
          updatedPlan['selectedPlaces']![index] = {
            'id': newPlace?['id'],
            'displayName': newPlace?['displayName'] ?? 'No place name',
            'primaryType': newPlace?['primaryType'] ?? 'No type',
            'shortFormattedAddress':
                newPlace?['shortFormattedAddress'] ?? 'No location',
            'photosUrl': newPlace?['photosUrl'] ?? 'Image not available',
          };
        }
      });
    } catch (e) {
      print('Error regenerating place: $e');
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      List<Map<String, dynamic>> selectedPlacesList =
          updatedPlan['selectedPlaces']!;

      if (newIndex > oldIndex) newIndex -= 1;

      final Map<String, dynamic> movedPlace =
          selectedPlacesList.removeAt(oldIndex);

      selectedPlacesList.insert(newIndex, movedPlace);

      updatedPlan['selectedPlaces'] = selectedPlacesList;
    });
  }

  String formatType(String type) {
    return type
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    // print('EditScreen Received plan data: ${widget.planData}');
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  updatedPlan['planName'] ?? 'Plan',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: widget.onClose,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editPlanName,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     Icon(Icons.person, size: 25, color: primaryColor),
            //     const SizedBox(width: 10),
            //     const Text(
            //       'Generated by  ',
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //     ),
            //     const Text('John Doe', style: TextStyle(fontSize: 16)),
            //   ],
            // ),
            // const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.timer, size: 25, color: primaryColor),
                const SizedBox(width: 10),
                const Text(
                  'Time duration  ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  updatedPlan['numberOfPlaces'] != null
                      ? '${updatedPlan['numberOfPlaces']!} hours'
                      : 'Unknown',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 25, color: primaryColor),
                const SizedBox(width: 10),
                const Text(
                  'Start date  ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  updatedPlan['startDate'] ?? 'Unknown',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _editStartDate();
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            ReorderableListView(
              proxyDecorator: proxyDecorator,
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Prevent scroll conflicts
              onReorder: _onReorder,
              buildDefaultDragHandles:
                  false, // Disable default drag handles on the right
              children:
                  List.generate(updatedPlan['selectedPlaces'].length, (index) {
                var details = updatedPlan['selectedPlaces']
                    [index]; // Accessing using index
                final startTimeString = updatedPlan['startTime'];
                DateTime startTime;

                try {
                  startTime = DateFormat('HH:mm').parse(startTimeString);
                } catch (e) {
                  startTime = DateTime(
                      2024, 1, 1, 9, 0); // Default start time if parsing fails
                }

                // Calculate the time for this place based on its index
                final placeTime = startTime.add(Duration(hours: index));
                final time = DateFormat('h:mm a').format(placeTime);

                return KeyedSubtree(
                  key: Key(details['id']), // Use place ID for a unique key
                  child: Row(
                    children: [
                      // Reorder icon placed in front
                      ReorderableDragStartListener(
                        index: index,
                        child: const Icon(
                          Icons.drag_handle,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: buildRouting(
                          primaryColor,
                          time,
                          PlaceCard(
                            planID: widget.planData['planID'],
                            imageUrl: details['photosUrl'] ?? 'No image',
                            title: details['displayName'] ?? 'No place name',
                            type:
                                formatType(details['primaryType'] ?? 'No type'),
                            location: details['shortFormattedAddress'] ??
                                'No location',
                            placeID: details['id'] ?? 'No place ID',
                            onViewPlaceDetail: widget.onViewPlaceDetail,
                          ),
                          index ==
                              updatedPlan['selectedPlaces'].length -
                                  1, // Check if it's the last item
                          details['id'], // Using place ID for the routing
                          index,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: _generateMorePlace,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Generate more place?',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
            Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    double buttonWidth = constraints.maxWidth > 200
                        ? 90
                        : constraints.maxWidth * 0.4;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            _restoreDismissedPlaces();
                            widget.onCancel(
                                originalPlan['planID']); // Close the screen
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: primaryColor, width: 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: SizedBox(
                              width: buttonWidth,
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            widget.onDone(updatedPlan);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: SizedBox(
                              width: buttonWidth,
                              child: const Center(
                                child: Text(
                                  'Done',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRouting(Color primaryColor, String time, Widget placeCard,
      bool isLast, String key, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const CircleAvatar(
              radius: 10,
              backgroundColor: Colors.grey,
            ),
            Container(
              height: isLast ? 180 : 200, // Height of the vertical line
              width: 3,
              color: Colors.grey,
            ),
          ],
        ),
        const SizedBox(width: 16), // Spacing between point and card
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                time,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Slidable(
                key: ValueKey(key), // Unique key
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        print('Regenerating place $key');
                        regenerateOnePlace(key);
                      },
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      icon: Icons.refresh,
                      // label: 'Regenerate',
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        // Delete place logic
                        setState(() {
                          // Find the index of the place to delete
                          int index = updatedPlan['selectedPlaces']!.indexWhere(
                              (place) =>
                                  place['id'] ==
                                  key); // Assuming key is the place ID

                          if (index != -1) {
                            // Add the deleted place to deletedPlaces list
                            deletedPlaces
                                .add(updatedPlan['selectedPlaces']![index]);

                            // Remove the place from selectedPlaces
                            updatedPlan['selectedPlaces']!.removeAt(index);

                            // Update the number of places
                            updatedPlan['numberOfPlaces'] =
                                updatedPlan['selectedPlaces']!.length;
                          }
                        });
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      // label: 'Delete',
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0),
                      ),
                    ),
                  ],
                ),
                child: placeCard,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
  return AnimatedBuilder(
    animation: animation,
    builder: (BuildContext context, Widget? child) {
      final elevation = lerpDouble(0, 6, animation.value) ?? 0;
      return Material(
        elevation: elevation,
        color: Colors.white,
        shadowColor: Colors.black.withOpacity(0.2), // Reduced opacity for a subtler shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Adding rounded corners for a modern look
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12), // Clip the child to match the rounded corners
          child: child,
        ),
      );
    },
    child: child,
  );
}

}
