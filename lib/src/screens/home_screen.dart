import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:plan_a_day/services/api_service.dart';
import 'package:plan_a_day/src/screens/components/onGoingPlan_card.dart';
import 'package:plan_a_day/src/screens/components/plan_card.dart';
import 'package:plan_a_day/src/screens/data/place_details.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onCreatePlan;
  final VoidCallback onViewSuggestPlan;
  final Function(String id) onPlan;
  final Function(String id) onOtherPlan;
  final String ongoingPlanID;
  final Map<String, dynamic> onGoingPlan;
  final VoidCallback onEndGoingPlan;

  const HomeScreen({
    super.key,
    required this.onCreatePlan,
    required this.onPlan,
    required this.onOtherPlan,
    required this.ongoingPlanID,
    required this.onGoingPlan,
    required this.onEndGoingPlan,
    required this.onViewSuggestPlan,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> suggestPlans = [];
  List<Map<String, dynamic>> allPlans = [];
  int carousalActiveIndex = 0; // To track the current index
  final CarouselSliderController _controller = CarouselSliderController();  // Ensure this line is correct for your package version.

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getHomeSuggestPlans();
      getPlanHistory();
  });
  }

  void getHomeSuggestPlans() async {
    final response = await apiService.getHomeSuggestPlans();
    if (mounted) {
      setState(() {
        suggestPlans = response!;
      });
    }
  }

  void getPlanHistory() async {
    final List<Map<String, dynamic>>? plans = await apiService.getPlanHistory();
    if (mounted) {
      setState(() {
        allPlans = plans!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
  backgroundColor: Colors.white,
  body: SafeArea(
    top: false,
    child: SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Main scrollable content
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: widget.ongoingPlanID != '' ? 410 : 300,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xfffb9a4b), Color(0xffff6838)],
                        stops: [0.3, 0.7],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: widget.ongoingPlanID != ''
                        ? OngoingPlanWidget(
                            planID: widget.ongoingPlanID,
                            plan: widget.onGoingPlan,
                            onViewOngoingPlan: widget.onPlan,
                            onEndPlan: widget.onEndGoingPlan,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 75),
                              Center(
                                child: Image.asset(
                                  'assets/images/Asset_14x.png',
                                  height: 50,
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'Where you want to ',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Go?',
                                      style: TextStyle(
                                        fontSize: 55,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'SourceCodePro',
                                        shadows: [
                                          Shadow(
                                            offset: Offset(4.0, 4.0),
                                            blurRadius: 4.0,
                                            color:
                                                Color.fromARGB(178, 60, 60, 60),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                  Padding(
                    padding: widget.ongoingPlanID != ''
                        ? const EdgeInsets.only(top: 20)
                        : const EdgeInsets.only(top: 70),
                    child: Column(
                      children: [
                        _buildCarouselSlider(),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            widget.onViewSuggestPlan();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 10),
                            child: SizedBox(
                              width: 100,
                              child: Center(
                                child: Text(
                                  'View All',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'All Plans',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: allPlans.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(30),
                                child: Center(
                                  child: Text(
                                    'No recent plans',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            : Column(
                                children: allPlans.map((plan) {
                                  return GestureDetector(
                                    onTap: () =>
                                        widget.onPlan(plan['planId']),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
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
                                }).toList(),
                              ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ],
              ),
              // Overlay container for "Create new plan"
              if (widget.ongoingPlanID == '')
                Positioned(
                  top: 255,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: widget.onCreatePlan,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 5.0,
                        child: SizedBox(
                          height: 70.0,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.add, size: 35, color: primaryColor),
                              const SizedBox(width: 10),
                              Text(
                                'Create new plan',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 11),
                            ],
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
    ),
  ),
);
  }

  Widget _buildCarouselSlider() {
    if (suggestPlans.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Loading plan...',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Carousel Slider
        CarouselSlider.builder(
          itemCount: suggestPlans.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final plan = suggestPlans[index]; // Get current plan data
            return GestureDetector(
              onTap: () {
                widget.onOtherPlan(plan['planId']); // Send out planId
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 4,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        plan['imageURL'] ?? 'default_image_url_here', // Provide default
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan['planName'] ?? 'Unnamed Plan', // Check for null
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  (plan['category'].length > 3
                                      ? plan['category'].take(3).join(' • ') + ' • ...'
                                      : plan['category'].join(' • ')),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const Text(
                                  ' | ',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  "${plan['numberofPlaces']} Places",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 220,
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            onPageChanged: (index, reason) {
              setState(() {
                carousalActiveIndex = index; // Update active index when page changes
              });
            },
          ),
          carouselController: _controller, // Optional controller for manual control
        ),

        const SizedBox(height: 10),

        // Dot Indicator
        AnimatedSmoothIndicator(
          activeIndex: carousalActiveIndex,
          count: suggestPlans.length,
          effect: const SlideEffect(
            dotHeight: 10,
            dotWidth: 10,
            activeDotColor: Color(0xFFFF6838),
            dotColor: Colors.grey,
          ),
          onDotClicked: (index) {
            _controller.animateToPage(index);
          },
        ),
      ],
    );
  }
}
