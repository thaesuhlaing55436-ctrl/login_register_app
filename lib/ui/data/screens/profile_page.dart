import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_register_app/ui/data/auth_bloc/auth_cubit.dart';

import 'login_page.dart';

class ProfilePage extends StatelessWidget {
const ProfilePage({super.key});

static const Color backgroundColor = Color(0xFF101827);
static const Color surfaceColor = Color(0xFF1D293B);
static const Color lavenderColor = Color(0xFFA78BFA);
static const Color cyanColor = Color(0xFF67E8F9);
static const Color textColor = Color(0xFFF8FAFC);
static const Color mutedColor = Color(0xFFA9B6C9);


Future<void> _confirmLogout(BuildContext context) async {
final shouldLogout = await showDialog<bool>(
context: context,
builder: (dialogContext) {
return AlertDialog(
backgroundColor: surfaceColor,
title: const Text(
'Confirm Logout',
style: TextStyle(color: textColor),
),
content: const Text(
'Are you sure you want to log out?',
style: TextStyle(color: mutedColor),
),
actions: [
TextButton(
onPressed: () => Navigator.pop(dialogContext, false),
child: const Text(
'Cancel',
style: TextStyle(color: mutedColor),
),
),
ElevatedButton(
onPressed: () => Navigator.pop(dialogContext, true),
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFFEF4444),
foregroundColor: Colors.white,
),
child: const Text('Yes, Logout'),
),
],
);
},
);

if (shouldLogout != true || !context.mounted) return;

try {
await context.read<AuthCubit>().logout();

if (!context.mounted) return;

Navigator.of(context).pushAndRemoveUntil(
MaterialPageRoute(builder: (_) => const LoginPage()),
(route) => false,
);
} catch (e) {
if (!context.mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Logout failed: $e'),
backgroundColor: const Color(0xFFEF4444),
),
);
}
}

@override
Widget build(BuildContext context) {
final user = context.read<AuthCubit>().user;

if (user == null) {
return const Scaffold(
backgroundColor: backgroundColor,
body: Center(
child: Text(
'Please log in first',
style: TextStyle(color: textColor),
),
),
);
}

return Scaffold(
backgroundColor: backgroundColor,
appBar: AppBar(
title: const Text('My Profile'),
centerTitle: true,
backgroundColor: backgroundColor,
foregroundColor: textColor,
elevation: 0,
),
body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
stream: FirebaseFirestore.instance
.collection('users')
.doc(user.uid)
.snapshots(),
builder: (context, snapshot) {
if (snapshot.hasError) {
return Center(
child: Padding(
padding: const EdgeInsets.all(24),
child: Text(
'Failed to load profile data.\n\n${snapshot.error}',
textAlign: TextAlign.center,
style: const TextStyle(color: mutedColor),
),
),
);
}

if (snapshot.connectionState == ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(color: lavenderColor),
);
}

final data = snapshot.data?.data();

final firestoreName = data?['name']?.toString().trim();
final displayName = user.displayName?.trim();
final name = (firestoreName != null && firestoreName.isNotEmpty)
? firestoreName
: (displayName != null && displayName.isNotEmpty)
? displayName
: user.email?.split('@').first ?? 'User';

final email =
data?['email']?.toString() ?? user.email ?? 'No email available';

return SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.all(24),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
const SizedBox(height: 12),

// Profile avatar
Center(
child: Container(
padding: const EdgeInsets.all(5),
decoration: BoxDecoration(
shape: BoxShape.circle,
border: Border.all(
color: lavenderColor,
width: 2,
),
),
child: const CircleAvatar(
radius: 48,
backgroundColor: surfaceColor,
child: Icon(
Icons.person_rounded,
size: 54,
color: lavenderColor,
),
),
),
),

const SizedBox(height: 20),

Text(
'Welcome, $name!',
textAlign: TextAlign.center,
style: const TextStyle(
fontSize: 25,
fontWeight: FontWeight.bold,
color: textColor,
),
),

const SizedBox(height: 8),

Text(
email,
textAlign: TextAlign.center,
style: const TextStyle(
fontSize: 14,
color: mutedColor,
),
),

const SizedBox(height: 30),

const Text(
'Account Information',
style: TextStyle(
color: textColor,
fontSize: 18,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 14),

_ProfileInfoCard(
icon: Icons.person_outline_rounded,
title: 'Full Name',
value: name,
iconColor: lavenderColor,
),

const SizedBox(height: 14),

_ProfileInfoCard(
icon: Icons.email_outlined,
title: 'Email Address',
value: email,
iconColor: cyanColor,
),

const SizedBox(height: 30),

SizedBox(
height: 54,
child: ElevatedButton.icon(
onPressed: () => _confirmLogout(context),
icon: const Icon(Icons.logout_rounded),
label: const Text(
'Logout',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFFEF4444),
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
),
),
),
  const SizedBox(height: 20),
],
),
),
);
},
),
);
}
}

class _ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  const _ProfileInfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProfilePage.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF35445B),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: ProfilePage.mutedColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    color: ProfilePage.textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}