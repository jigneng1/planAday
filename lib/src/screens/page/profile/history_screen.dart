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
  List<Map<String, dynamic>> _filteredPlans = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory; // Selected category
  final List<String> _categories = [
    'All', // Option to show all categories
    'Restaurant',
    'Cafe',
    'Park',
    'Store',
    'Gym',
    'Art_gallery',
    'Movie_theater',
    'Museum',
  ];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _searchController.addListener(_searchPlans);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadBookmarks() async {
    final List<Map<String, dynamic>> savedPlans = await apiService.getPlanHistory();

    setState(() {
      _isLoading = false;
      if (savedPlans.isEmpty) {
        _errorMessage = 'No saved plans';
      } else {
        _savedPlans = savedPlans;
        _filteredPlans = savedPlans; // Initialize filtered plans
      }
    });
  }

  void _searchPlans() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPlans = _savedPlans.where((plan) {
        final planName = (plan['planName'] ?? '').toLowerCase();
        final matchesSearch = planName.contains(query);
        final matchesCategory = _selectedCategory == null || _selectedCategory == 'All' 
            ? true 
            : (plan['category'] as List<dynamic>).any((cat) => cat.toString().toLowerCase() == _selectedCategory!.toLowerCase());

        return matchesSearch && matchesCategory; // Combine search and category filters
      }).toList();
    });
  }

  void _filterByCategory(String? category) {
    setState(() {
      _selectedCategory = category;
      _searchPlans(); // Reapply search and filter when category changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "History",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            Icon(Icons.history), // Add history icon
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            widget.onClose();
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Search Plans',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.grey),
                        onPressed: () {
                          _showCategoryMenu();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ),
                        )
                      : _filteredPlans.isEmpty
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
                              itemCount: _filteredPlans.length,
                              itemBuilder: (context, index) {
                                final plan = _filteredPlans[index];
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
                ),
              ],
            ),
    );
  }

  void _showCategoryMenu() {
    showMenu<String>(
      color: Colors.white,
      context: context,
      position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width - 150, 120, 0, 0), // Adjust to right side
      items: _categories.map((String category) {
        return PopupMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        _filterByCategory(value);
      }
    });
  }
}
