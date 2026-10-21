import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';
import 'analytics_page.dart';
import 'profile_page.dart';
import 'login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
int _selectedIndex = 0;
bool _isLoggingOut = false;

static const Color backgroundColor = Color(0xFF101827);
static const Color surfaceColor = Color(0xFF1D293B);
static const Color primaryColor = Color(0xFFA78BFA);
static const Color accentColor = Color(0xFF67E8F9);
static const Color textColor = Color(0xFFF8FAFC);
static const Color mutedTextColor = Color(0xFFA9B6C9);


final List<Widget> _pages = const [
HomePage(),
AnalyticsPage(),
ProfilePage(),
];

Future<void> _confirmLogout() async {
if (_isLoggingOut) return;

final shouldLogout = await showDialog<bool>(
context: context,
builder: (dialogContext) {
return AlertDialog(
backgroundColor: surfaceColor,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(20),
),
icon: const Icon(
Icons.logout_rounded,
color: primaryColor,
size: 36,
),
title: const Text(
'Confirm Logout',
style: TextStyle(
color: textColor,
fontWeight: FontWeight.bold,
),
),
content: const Text(
'Are you sure you want to log out?',
textAlign: TextAlign.center,
style: TextStyle(color: mutedTextColor),
),
actionsAlignment: MainAxisAlignment.spaceEvenly,
actions: [
TextButton(
onPressed: () {
Navigator.pop(dialogContext, false);
},
child: const Text(
'Cancel',
style: TextStyle(color: mutedTextColor),
),
),
ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: primaryColor,
foregroundColor: backgroundColor,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
onPressed: () {
Navigator.pop(dialogContext, true);
},
child: const Text('Yes, Logout'),
),
],
);
},
);

if (shouldLogout != true || !mounted) return;

setState(() {
_isLoggingOut = true;
});

try {
await FirebaseAuth.instance.signOut();

if (!mounted) return;

Navigator.pushAndRemoveUntil(
context,
MaterialPageRoute(
builder: (context) => const LoginPage(),
),
(route) => false,
);
} catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Logout failed: $e'),
backgroundColor: surfaceColor,
behavior: SnackBarBehavior.floating,
),
);
} finally {
if (mounted) {
setState(() {
_isLoggingOut = false;
});
}
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: backgroundColor,

appBar: _selectedIndex == 2
? null
: AppBar(
backgroundColor: backgroundColor,
foregroundColor: textColor,
elevation: 0,
centerTitle: true,
title: Text(
_selectedIndex == 0 ? 'Home' : 'Analytics',
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    letterSpacing: 0.4,
  ),
),
  actions: [
    IconButton(
      tooltip: 'Logout',
      onPressed: _isLoggingOut ? null : _confirmLogout,
      icon: const Icon(
        Icons.logout_rounded,
        color: accentColor,
      ),
    ),
    const SizedBox(width: 8),
  ],
),

  body: IndexedStack(
    index: _selectedIndex,
    children: _pages,
  ),

  bottomNavigationBar: NavigationBarTheme(
    data: NavigationBarThemeData(
      backgroundColor: surfaceColor,
      indicatorColor: primaryColor.withValues(alpha: 0.22),
      height: 72,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }

          return const TextStyle(
            color: mutedTextColor,
            fontSize: 12,
          );
        },
      ),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
            (states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: primaryColor,
              size: 25,
            );
          }

          return const IconThemeData(
            color: mutedTextColor,
            size: 23,
          );
        },
      ),
    ),
    child: NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics_rounded),
          label: 'Analytics',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    ),
  ),
);
}
}