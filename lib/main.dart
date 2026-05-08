import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
// import 'screens/financial_advice.dart';
import 'screens/auth_screen.dart';

// Backend
import 'providers/loan_provider.dart';

// UI Screens (Update these filenames if your team named them differently!)
import 'screens/budget_screen.dart';
import 'screens/dashboard.dart';
import 'screens/loans.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('budgetBox');

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://hvcaxyzzziqmotrkjbzz.supabase.co',
    anonKey: 'sb_publishable_A3r5J0XMWoBBb-h5ZPkXtg_X8Tlpysi',
  );

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LoanProvider())],
      child: const FinanceHubApp(),
    ),
  );
}

class FinanceHubApp extends StatelessWidget {
  const FinanceHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Hub',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0F14),
      ),
      debugShowCheckedModeBanner: false,
      // Check if user is already logged in!
      home: Supabase.instance.client.auth.currentUser == null
          ? const AuthScreen()
          : const MainNavigator(),
    );
  }
}

// ─── BOTTOM NAVIGATION WRAPPER ─────────────────────────────────────────────
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  // This is our "remote control" to switch tabs
  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // We pass the remote control into the Dashboard!
    final List<Widget> screens = [
      DashboardScreen(onNavigate: _switchTab),
      const LoansScreen(),
      BudgetingScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E2330),
        selectedItemColor: const Color(0xFF00E5A0),
        unselectedItemColor: const Color(0xFF8A90A2),
        currentIndex: _currentIndex,
        onTap: _switchTab, // Also works when tapping the bottom icons naturally
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Loans',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Budget'),
        ],
      ),
    );
  }
}
