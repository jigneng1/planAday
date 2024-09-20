import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plan_a_day/src/screens/data/place_details.dart';
import 'components/place_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EditPlanScreen extends StatefulWidget {
  final Map<String, dynamic> planData;
  final VoidCallback onClose;
  final Function(Map<String, dynamic>) onDone;
  final Function(Map<String, dynamic>) onCancel;

  const EditPlanScreen({
    super.key,
    required this.onClose,
    required this.planData,
    required this.onDone,
    required this.onCancel,
  });

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<EditPlanScreen> {
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

  void _editStartTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        DateTime.parse(
            updatedPlan['startTime'] ?? DateTime.now().toIso8601String()),
      ),
    );

    if (newTime != null) {
      final String newStartTime =
          '${newTime.hour}:${newTime.minute.toString().padLeft(2, '0')}';
      setState(() {
        updatedPlan['startTime'] = newStartTime;
      });
    }
  }

  void _restoreDismissedPlaces() {
    setState(() {
      for (var place in deletedPlaces) {
        String id = place['id'];
        updatedPlan['selectedPlaces'][id] = place;
      }

      deletedPlaces.clear();

      updatedPlan['numberOfPlaces'] = updatedPlan['selectedPlaces'].length;
    });
  }

  void _generateMorePlaces() {
    // Fetch new places; assuming getRandomizedPlaces returns a List<Map<String, String>>
    List<Map<String, String>> newPlaces =
        getRandomizedPlaces(1); // Number of places to add

    setState(() {
      // Ensure selectedPlaces is initialized as a Map
      if (updatedPlan['selectedPlaces'] == null) {
        updatedPlan['selectedPlaces'] = {}; // Initialize as an empty map
      }

      // Add new places to the selectedPlaces map
      for (var place in newPlaces) {
        if (place['id'] != null &&
            place['photoUrl'] != null &&
            place['title'] != null &&
            place['subtitle'] != null) {
          String id = place['id']!; // Assuming each place has a unique ID
          updatedPlan['selectedPlaces'][id] = {
            'photoUrl': place['photoUrl']!,
            'displayName': place['title']!,
            'primaryType': place['subtitle']!,
          };
        } else {
          print('One or more fields in the new place are null: $place');
        }
      }

      // Update the number of places
      updatedPlan['numberOfPlaces'] = updatedPlan['selectedPlaces'].length;
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      List<MapEntry<String, dynamic>> entries =
          updatedPlan['selectedPlaces'].entries.toList();
      if (newIndex > oldIndex) newIndex -= 1;

      final MapEntry<String, dynamic> movedEntry = entries.removeAt(oldIndex);

      entries.insert(newIndex, movedEntry);

      updatedPlan['selectedPlaces'] = Map.fromEntries(entries);
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('EditScreen Received plan data: ${widget.planData}');
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
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
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _editPlanName,
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
            icon: const Icon(Icons.share),
            onPressed: () {
              // Handle share plan action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, size: 25, color: primaryColor),
                const SizedBox(width: 10),
                const Text(
                  'Generated by  ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text('John Doe', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.timer, size: 25, color: primaryColor),
                const SizedBox(width: 10),
                const Text(
                  'Time duration  ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: _editStartTime,
                  child: Text(
                    '${updatedPlan['startTime'] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
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
                const Text(
                  '22 August 2024',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ReorderableListView(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Prevent scroll conflicts
              onReorder: _onReorder,
              buildDefaultDragHandles:
                  false, // Disable default drag handles on the right
              children:
                  List.generate(updatedPlan['selectedPlaces'].length, (index) {
                final key = updatedPlan['selectedPlaces'].keys.elementAt(index);
                var details = updatedPlan['selectedPlaces'][key];
                final startTimeString = updatedPlan['startTime'];
                DateTime startTime;

                try {
                  startTime = DateFormat('HH:mm').parse(startTimeString);
                } catch (e) {
                  startTime = DateTime(2024, 1, 1, 9, 0);
                }

                final placeTime = startTime.add(Duration(hours: index));
                final time = DateFormat('h:mm a').format(placeTime);

                return KeyedSubtree(
                  key: Key(key), // Add the unique key here
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
                          PlaceDetailCard(
                            imageUrl: details['photosUrl'] ?? 'No image',
                            title: details['displayName'] ?? 'No place name',
                            subtitle: details['primaryType'] ?? '',
                          ),
                          index == updatedPlan['selectedPlaces'].length - 1,
                          key,
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
                onTap: _generateMorePlaces,
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
            const SizedBox(height: 50),
            const Row(
              children: [
                Icon(Icons.location_on, size: 30),
                SizedBox(width: 8),
                Text(
                  'Routing Path',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade200,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 80),
                  SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 50),
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
                            widget.onCancel(originalPlan); // Close the screen
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
              height: isLast ? 190 : 220, // Height of the vertical line
              width: 2,
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
                        // Regenerate place logic
                        List<Map<String, String>> newPlace =
                            getRandomizedPlaces(1);
                        setState(() {
                          updatedPlan['selectedPlaces'][key] = {
                            'imageUrl': newPlace.first['photoUrl'] ?? '',
                            'title': newPlace.first['title'] ?? '',
                            'subtitle': newPlace.first['subtitle'] ?? '',
                          };
                        });
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
                          if (updatedPlan['selectedPlaces'].containsKey(key)) {
                            deletedPlaces
                                .add(updatedPlan['selectedPlaces'][key]);
                            updatedPlan['selectedPlaces'].remove(key);

                            updatedPlan['numberOfPlaces'] =
                                updatedPlan['selectedPlaces'].length;
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
}
