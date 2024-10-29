import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plan_a_day/services/auth_token.dart';
import 'package:plan_a_day/src/app.dart';
import 'package:plan_a_day/src/screens/page/authen/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideUpAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Fade-in animation
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Slide-up animation for the text
    _slideUpAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start the animations when the screen loads
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Fixed token check function
  Future<bool> _checkTokenExistsAndExpire() async {
    try {
      String? token = await getToken();
      return token != null && token.isNotEmpty && !isTokenExpired(token);
    } catch (e) {
      print('Error checking token: $e');
      return false;
    }
  }

  void _handleAuthCheck(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      bool isAuthenticated = await _checkTokenExistsAndExpire();

      if (isAuthenticated) {
        // Navigate to home or dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainLayout()),
        );
      } else {
        // User is not authenticated
        // Navigate to login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfffb9a4b), Color(0xffff6838)],
            stops: [0.3, 0.7],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Logo with fade-in animation
            FadeTransition(
              opacity: _fadeInAnimation,
              child: Padding(
                padding: const EdgeInsets.only(top: 120.0),
                child: Image.asset(
                  'assets/images/Asset_14x.png',
                  height: 150,
                ),
              ),
            ),
            const SizedBox(height: 100),
            // Sliding-up Text animations
            SlideTransition(
              position: _slideUpAnimation,
              child: const Column(
                children: [
                  Text(
                    'Welcome to PlanADay',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Suggest trip in one day',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () => _handleAuthCheck(context),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: const Center(
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFFFF6838),
        primarySwatch: Colors.orange,
      ),
      home: const WelcomeScreen(),
    );
  }
}
