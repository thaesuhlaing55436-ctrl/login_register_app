import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
const HomePage({super.key});

static const Color backgroundColor = Color(0xFF101827);
static const Color surfaceColor = Color(0xFF1D293B);
static const Color primaryColor = Color(0xFFA78BFA);
static const Color accentColor = Color(0xFF67E8F9);
static const Color textColor = Color(0xFFF8FAFC);
static const Color mutedTextColor = Color(0xFFA9B6C9);
static const Color borderColor = Color(0xFF35445B);

@override
Widget build(BuildContext context) {
final user = FirebaseAuth.instance.currentUser;

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
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
const Icon(
Icons.error_outline_rounded,
color: Color(0xFFFF6B81),
size: 48,
),
const SizedBox(height: 16),
const Text(
'Unable to load user information',
textAlign: TextAlign.center,
style: TextStyle(
color: textColor,
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 8),
Text(
'${snapshot.error}',
textAlign: TextAlign.center,
style: const TextStyle(
color: mutedTextColor,
fontSize: 12,
),
),
],
),
),
);
}

if (snapshot.connectionState == ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(
color: accentColor,
),
);
}

final data = snapshot.data?.data();

final firestoreName = data?['name']?.toString().trim();
final displayName = user.displayName?.trim();

final name = (firestoreName != null &&
firestoreName.isNotEmpty)
? firestoreName
: (displayName != null && displayName.isNotEmpty)
? displayName
: user.email?.split('@').first ?? 'User';

final email = data?['email']?.toString() ??
user.email ??
'No email available';

return SingleChildScrollView(
padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
// Welcome banner
Container(
padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
gradient: const LinearGradient(
colors: [
Color(0xFF302B63),
Color(0xFF1D293B),
],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
borderRadius: BorderRadius.circular(24),
border: Border.all(
color: primaryColor.withValues(alpha: 0.3),
),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'YOUR PERSONAL SPACE',
style: TextStyle(
color: accentColor,
fontSize: 11,
fontWeight: FontWeight.bold,
letterSpacing: 1.8,
),
),
const SizedBox(height: 18),
const Text(
'Welcome back,',
style: TextStyle(
color: mutedTextColor,
fontSize: 16,
),
),
const SizedBox(height: 6),
Text(
name,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
color: textColor,
fontSize: 28,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 12),
const Text(
'You have successfully logged in.',
style: TextStyle(
color: mutedTextColor,
fontSize: 14,
),
),
const SizedBox(height: 22),
Container(
width: 58,
height: 58,
decoration: BoxDecoration(
color: primaryColor.withValues(alpha: 0.18),
borderRadius: BorderRadius.circular(18),
),
child: const Icon(
Icons.waving_hand_rounded,
color: accentColor,
size: 32,
),
),
],
),
),

const SizedBox(height: 28),

const Text(
'Account Overview',
style: TextStyle(
color: textColor,
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 6),

const Text(
'Your account information at a glance.',
style: TextStyle(
color: mutedTextColor,
fontSize: 13,
),
),

const SizedBox(height: 18),

_InfoCard(
icon: Icons.person_outline_rounded,
title: 'Full Name',
value: name,
iconColor: primaryColor,
),

const SizedBox(height: 14),

_InfoCard(
icon: Icons.email_outlined,
title: 'Email Address',
value: email,
iconColor: accentColor,
),

const SizedBox(height: 14),

_InfoCard(
icon: Icons.verified_user_outlined,
title: 'Account Status',
value: 'Successfully logged in',
iconColor: const Color(0xFF6EE7B7),
),
  const SizedBox(height: 24),

  Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: borderColor),
    ),
    child: const Row(
      children: [
        Icon(
          Icons.shield_outlined,
          color: accentColor,
          size: 28,
        ),
        SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your account is active',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Manage your profile using the navigation below.',
                style: TextStyle(
                  color: mutedTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
],
),
);
},
),
);
}
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1D293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF35445B),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFA9B6C9),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFFF8FAFC),
                    fontSize: 14,
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