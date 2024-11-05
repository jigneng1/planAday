import 'package:flutter/material.dart';
import 'package:plan_a_day/services/api_service.dart';
import 'package:plan_a_day/src/screens/components/plan_card.dart';

class SuggestScreen extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String planId) onViewPlan;

  const SuggestScreen({super.key, required this.onClose, required this.onViewPlan});

  @override
  _SuggestedPlansScreenState createState() => _SuggestedPlansScreenState();
}

class _SuggestedPlansScreenState extends State<SuggestScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  ApiService apiService = ApiService();
  List<String> _interest = [];
  final Map<String, List<Map<String, dynamic>>> _plansByCategory = {};
  final List<String> defaultCategories = [
    'Restaurant',
    'Cafe',
    'Park',
    'Store',
    'Gym',
    'Art_gallery',
    'Movie_theater',
    'Museum',
  ];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInterestAndPlans();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _fetchInterestAndPlans() async {
    final List<String> interest = await apiService.getInterest();
    if (mounted) {
      // Add "All" to the beginning of the interest list
      _interest = ['All'] + (interest.isNotEmpty ? interest : defaultCategories);
      _tabController = TabController(length: _interest.length, vsync: this);

      // Fetch all plans for the "All" tab
      final allPlans = await apiService.getAllSuggestPlans();
      if (mounted) {
        setState(() {
          _plansByCategory['All'] = allPlans ?? [];
        });
      }

      // Fetch plans for each category
      for (var category in _interest.skip(1)) { // Skip "All"
        final plans = await apiService.getSuggestPlansbyCategory(category.toLowerCase());
        if (mounted) {
          setState(() {
            _plansByCategory[category] = plans ?? [];
          });
        }
      }

      // Set loading to false once data is fetched
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            widget.onClose();
          },
        ),
        title: const Text(
          'Suggested for you',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: _isLoading
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(48.0),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: primaryColor,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: primaryColor,
                  tabs: _interest.map((category) => Tab(text: category.capitalize())).toList(),
                ),
              ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TabBarView(
                  controller: _tabController,
                  children: _interest.map((category) => _buildPlanList(category)).toList(),
                ),
              ),
            ),
    );
  }

  Widget _buildPlanList(String category) {
    final plans = _plansByCategory[category] ?? [];
    return plans.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: GestureDetector(
                  onTap: () {
                    widget.onViewPlan(plan['planId']);
                  },
                  child: PlanCard(
                    imageUrl: plan['imageURL'] ?? '',
                    title: plan['planName'] ?? '',
                    subtitle: (plan['category']
                                                as List<dynamic>)
                                            .map((e) => e.toString())
                                            .join(', '),
                    time: plan['numberofPlaces']
                                            .toString(),
                  ),
                ),
              );
            },
          )
        : const Center(child: Text('No plans available'));
  }
}

extension StringExtension on String {
  String capitalize() {
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  }
}
