import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/plan_card.dart';

class BookmarkPlanScreen extends StatefulWidget {
  final List<Map<String, dynamic>> savedPlans;
  final Map<String, dynamic>? newPlan; // Add this parameter

  const BookmarkPlanScreen({super.key, required this.savedPlans, this.newPlan});

  @override
  State<BookmarkPlanScreen> createState() => _BookmarkPlanScreenState();
}

class _BookmarkPlanScreenState extends State<BookmarkPlanScreen> {
  List<Map<String, dynamic>> _savedPlans = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
      _loadBookmarks(); 
          if (widget.newPlan != null) {
      _savedPlans.add(widget.newPlan!);
    }
  }

  Future<void> _loadBookmarks() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> bookmarks = prefs.getStringList('bookmarkedPlans') ?? [];

      setState(() {
        _savedPlans = widget.savedPlans
            .where((plan) => bookmarks.contains(plan['planId']))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load bookmarks. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Bookmarks Plan"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                )
              : _savedPlans.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          'No saved plans',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _savedPlans.length,
                      itemBuilder: (context, index) {
                        final plan = _savedPlans[index];
                        return GestureDetector(
                          onTap: () => _onPlanTapped(plan['planId']),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: PlanCard(
                              imageUrl: plan['imageURL'] ?? '',
                              title: plan['planName'] ?? '',
                              subtitle: (plan['category'] as List<dynamic>)
                                  .map((e) => e.toString())
                                  .join(', '),
                              time: plan['numberofPlaces'].toString(),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }

  void _onPlanTapped(String planId) {
    Navigator.pop(context, planId);
  }
}
