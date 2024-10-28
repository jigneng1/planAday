import 'package:flutter/material.dart';
import 'package:plan_a_day/src/screens/components/plan_card.dart';

class SuggestScreen extends StatefulWidget {
  final VoidCallback onClose;

  const SuggestScreen({super.key, required this.onClose});

  @override
  _SuggestedPlansScreenState createState() => _SuggestedPlansScreenState();
}

class _SuggestedPlansScreenState extends State<SuggestScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.black,
            indicatorColor: primaryColor,
            tabs: [
              Tab(text: 'Restaurant'),
              Tab(text: 'Cafe'),
              Tab(text: 'Park'),
              Tab(text: 'Store'),
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPlanList(),
              Center(child: Text('Park')),
              Center(child: Text('Food')),
              Center(child: Text('Historical')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanList() {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: 8, // Number of plans to display
      itemBuilder: (context, index) {
        return const Padding(
          padding:  EdgeInsets.only(bottom: 24.0),
          child: PlanCard(
              imageUrl:
                  'https://media.triumphmotorcycles.co.uk/image/upload/f_auto/q_auto/sitecoremedialibrary/media-library/images/central%20marketing%20team/for%20the%20ride/experiences/fve%20update/cafe/fve-cafe-hero-1920x1080.jpg',
              title: 'Pet cafe',
              subtitle: "sss",
              time: "2"),
        );
      },
    );
  }
}
