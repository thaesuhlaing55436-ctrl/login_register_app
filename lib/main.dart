import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:login_register_app/services/auth_service.dart';
import 'package:login_register_app/ui/data/auth_bloc/auth_cubit.dart';
import 'package:login_register_app/ui/data/screens/login_page.dart';
import 'package:login_register_app/ui/data/screens/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    BlocProvider(
      create: (_) => AuthCubit(AuthService()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

// Midnight Luxe Colour Palette
static const Color backgroundColor = Color(0xFF101827);
static const Color surfaceColor = Color(0xFF1D293B);
static const Color primaryColor = Color(0xFFA78BFA);
static const Color accentColor = Color(0xFF67E8F9);
static const Color textColor = Color(0xFFF8FAFC);
static const Color mutedTextColor = Color(0xFFA9B6C9);
static const Color borderColor = Color(0xFF35445B);

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Midnight Luxe',
theme: ThemeData(
useMaterial3: true,
brightness: Brightness.dark,
scaffoldBackgroundColor: backgroundColor,

colorScheme: const ColorScheme.dark(
primary: primaryColor,
onPrimary: backgroundColor,
secondary: accentColor,
onSecondary: backgroundColor,
surface: surfaceColor,
onSurface: textColor,
error: Color(0xFFFF6B81),
onError: backgroundColor,
),

appBarTheme: const AppBarTheme(
backgroundColor: backgroundColor,
foregroundColor: textColor,
centerTitle: true,
elevation: 0,
),

inputDecorationTheme: InputDecorationTheme(
filled: true,
fillColor: surfaceColor,
contentPadding: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 18,
),
labelStyle: const TextStyle(
color: mutedTextColor,
),
hintStyle: const TextStyle(
color: mutedTextColor,
),
prefixIconColor: primaryColor,
suffixIconColor: accentColor,

border: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: borderColor,
),
),

enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: borderColor,
),
),

focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: accentColor,
width: 1.5,
),
),

errorBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: Color(0xFFFF6B81),
),
),

focusedErrorBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: Color(0xFFFF6B81),
width: 1.5,
),
),
),

elevatedButtonTheme: ElevatedButtonThemeData(
style: ElevatedButton.styleFrom(
backgroundColor: primaryColor,
foregroundColor: backgroundColor,
minimumSize: const Size(double.infinity, 52),
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  ),
  textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
),
),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: accentColor,
    ),
  ),

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: accentColor,
  ),

  dividerTheme: const DividerThemeData(
    color: borderColor,
    thickness: 1,
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: surfaceColor,
    contentTextStyle: const TextStyle(
      color: textColor,
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),

  home: const AuthWrapper(),
);
}
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is Authenticated) {
          return const MainPage();
        }

        if (state is Unauthenticated) {
          return const LoginPage();
        }

        if (state is AuthError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Authentication error:\n${state.message}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}