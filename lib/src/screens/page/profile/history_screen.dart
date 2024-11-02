import 'package:flutter/material.dart';
import 'package:plan_a_day/services/api_service.dart';
import '../../components/plan_card.dart';

class HistoryPlanScreen extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String planId) onViewPlan;
  
  const HistoryPlanScreen({super.key, required this.onClose, required this.onViewPlan});

  @override
  State<HistoryPlanScreen> createState() => _HistoryPlanScreenState();
}

class _HistoryPlanScreenState extends State<HistoryPlanScreen> {
  ApiService apiService = ApiService();
  List<Map<String, dynamic>> _savedPlans = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBookmarks(); 
  }

  void _loadBookmarks() async {
    final List<Map<String, dynamic>> savedPlans = await apiService.getPlanHistory();
    
    setState(() {
      _isLoading = false;
      if (savedPlans.isEmpty) {
        _errorMessage = 'No saved plans'; // Show this message if no bookmarks exist
      } else {
        _savedPlans = savedPlans; // Populate saved plans with bookmarks
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Plan History", style: TextStyle(fontWeight: FontWeight.bold),),
        leading: 
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), // Close icon
            onPressed: () {
              widget.onClose(); // Call onClose callback when pressed
            },
          ),
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
                          'No plan history',
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
                          onTap: () {
                            widget.onViewPlan(plan['planId']);
                          },
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
}
