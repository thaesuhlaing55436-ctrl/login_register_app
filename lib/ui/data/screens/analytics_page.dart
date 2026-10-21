import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
const AnalyticsPage({super.key});

static const Color backgroundColor = Color(0xFF101827);
static const Color surfaceColor = Color(0xFF1D293B);
static const Color lavenderColor = Color(0xFFA78BFA);
static const Color cyanColor = Color(0xFF67E8F9);
static const Color textColor = Color(0xFFF8FAFC);
static const Color mutedColor = Color(0xFFA9B6C9);
static const Color borderColor = Color(0xFF35445B);

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: backgroundColor,
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Dashboard Overview',
style: TextStyle(
fontSize: 26,
fontWeight: FontWeight.bold,
color: textColor,
),
),
const SizedBox(height: 8),
const Text(
'A quick overview of your application.',
style: TextStyle(
fontSize: 14,
color: mutedColor,
),
),
const SizedBox(height: 24),

// Dashboard summary
_buildAnalyticsCard(
icon: Icons.people_alt_outlined,
title: 'Total Users',
subtitle: 'Sample user count',
value: '1',
color: lavenderColor,
),
_buildAnalyticsCard(
icon: Icons.verified_user_outlined,
title: 'Login Status',
subtitle: 'Authentication overview',
value: 'Active',
color: cyanColor,
),
_buildAnalyticsCard(
icon: Icons.cloud_outlined,
title: 'Database',
subtitle: 'Application data storage',
value: 'Firestore',
color: const Color(0xFFFBBF24),
),

const SizedBox(height: 12),

// Application information
Container(
width: double.infinity,
padding: const EdgeInsets.all(18),
decoration: BoxDecoration(
color: surfaceColor,
borderRadius: BorderRadius.circular(18),
border: Border.all(color: borderColor),
),
child: const Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Icon(
Icons.info_outline,
color: cyanColor,
size: 28,
),
SizedBox(width: 14),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'About this Dashboard',
style: TextStyle(
color: textColor,
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 8),
Text(
'These values are sample dashboard data. '
'They are not live Firebase statistics yet.',
style: TextStyle(
color: mutedColor,
height: 1.5,
fontSize: 13,
),
),
],
),
),
],
),
),
  const SizedBox(height: 20),
],
),
),
),
);
}

Widget _buildAnalyticsCard({
  required IconData icon,
  required String title,
  required String subtitle,
  required String value,
  required Color color,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: borderColor),
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: color,
            size: 26,
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
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: mutedColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
}