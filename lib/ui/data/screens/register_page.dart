import 'package:flutter/material.dart';
import 'package:login_register_app/services/auth_service.dart';
import 'login_page.dart';
import 'main_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
final _formKey = GlobalKey<FormState>();

final _nameController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmPasswordController = TextEditingController();

final AuthService _authService = AuthService();

bool _hidePassword = true;
bool _hideConfirmPassword = true;
bool _isLoading = false;

static const Color primaryColor = Color(0xFFA78BFA);
static const Color accentColor = Color(0xFF67E8F9);
static const Color backgroundColor = Color(0xFF101827);
static const Color surfaceColor = Color(0xFF1D293B);
static const Color textColor = Color(0xFFF8FAFC);
static const Color mutedTextColor = Color(0xFFA9B6C9);

@override
void dispose() {
_nameController.dispose();
_emailController.dispose();
_passwordController.dispose();
_confirmPasswordController.dispose();
super.dispose();
}

Future<void> _register() async {
if (!_formKey.currentState!.validate()) return;

setState(() {
_isLoading = true;
});

try {
await _authService.register(
name: _nameController.text.trim(),
email: _emailController.text.trim(),
password: _passwordController.text,
);

if (!mounted) return;

Navigator.pushAndRemoveUntil(
context,
MaterialPageRoute(
builder: (context) => const MainPage(),
),
(route) => false,
);
} catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Registration failed: $e'),
backgroundColor: surfaceColor,
behavior: SnackBarBehavior.floating,
),
);
} finally {
if (mounted) {
setState(() {
_isLoading = false;
});
}
}
}

InputDecoration _inputDecoration({
required String hint,
required IconData icon,
Widget? suffixIcon,
}) {
return InputDecoration(
hintText: hint,
hintStyle: const TextStyle(color: mutedTextColor),
prefixIcon: Icon(icon, color: primaryColor),
suffixIcon: suffixIcon,
filled: true,
fillColor: surfaceColor,
contentPadding: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 18,
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: BorderSide.none,
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: BorderSide(
color: Colors.white.withValues(alpha: 0.08),
),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: accentColor,
width: 1.5,
),
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: backgroundColor,
appBar: AppBar(
title: const Text(
'Create Account',
style: TextStyle(
color: textColor,
fontWeight: FontWeight.w600,
),
),
centerTitle: true,
backgroundColor: backgroundColor,
foregroundColor: textColor,
),
body: SafeArea(
child: Center(
child: SingleChildScrollView(
padding: const EdgeInsets.symmetric(
horizontal: 24,
vertical: 20,
),
child: Form(
key: _formKey,
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Center(
child: Container(
width: 84,
height: 84,
decoration: BoxDecoration(
color: surfaceColor,
borderRadius: BorderRadius.circular(26),
border: Border.all(
color: primaryColor.withValues(alpha: 0.5),
),
),
child: const Icon(
Icons.person_add_alt_1_rounded,
size: 42,
color: primaryColor,
),
),
),

const SizedBox(height: 24),

const Text(
'Join Us Today',
textAlign: TextAlign.center,
style: TextStyle(
color: textColor,
fontSize: 28,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 10),

const Text(
'Create an account to get started',
textAlign: TextAlign.center,
style: TextStyle(
color: mutedTextColor,
fontSize: 14,
),
),

const SizedBox(height: 30),

const Text(
'Full Name',
style: TextStyle(
color: textColor,
fontWeight: FontWeight.w600,
),
),

const SizedBox(height: 8),

TextFormField(
controller: _nameController,
textCapitalization: TextCapitalization.words,
textInputAction: TextInputAction.next,
style: const TextStyle(color: textColor),
decoration: _inputDecoration(
hint: 'Enter your full name',
icon: Icons.person_outline_rounded,
),
validator: (value) {
if (value == null || value.trim().isEmpty) {
return 'Please enter your name';
}
return null;
},
),

const SizedBox(height: 18),

const Text(
'Email Address',
style: TextStyle(
color: textColor,
fontWeight: FontWeight.w600,
),
),

const SizedBox(height: 8),

TextFormField(
controller: _emailController,
keyboardType: TextInputType.emailAddress,
textInputAction: TextInputAction.next,
style: const TextStyle(color: textColor),
decoration: _inputDecoration(
hint: 'Enter your email',
icon: Icons.email_outlined,
),
validator: (value) {
if (value == null || value.trim().isEmpty) {
return 'Please enter your email';
}

if (!RegExp(
r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
).hasMatch(value.trim())) {
return 'Please enter a valid email';
}

return null;
},
),

const SizedBox(height: 18),
const Text(
'Password',
style: TextStyle(
color: textColor,
fontWeight: FontWeight.w600,
),
),

const SizedBox(height: 8),

TextFormField(
controller: _passwordController,
obscureText: _hidePassword,
textInputAction: TextInputAction.next,
style: const TextStyle(color: textColor),
decoration: _inputDecoration(
hint: 'Create a password',
icon: Icons.lock_outline_rounded,
suffixIcon: IconButton(
icon: Icon(
_hidePassword
? Icons.visibility_off_outlined
: Icons.visibility_outlined,
color: accentColor,
),
onPressed: () {
setState(() {
_hidePassword = !_hidePassword;
});
},
),
),
validator: (value) {
if (value == null || value.isEmpty) {
return 'Please enter your password';
}

if (value.length < 6) {
return 'Password must be at least 6 characters';
}

return null;
},
),

const SizedBox(height: 18),

const Text(
'Confirm Password',
style: TextStyle(
color: textColor,
fontWeight: FontWeight.w600,
),
),

const SizedBox(height: 8),

TextFormField(
controller: _confirmPasswordController,
obscureText: _hideConfirmPassword,
textInputAction: TextInputAction.done,
onFieldSubmitted: (_) {
if (!_isLoading) _register();
},
style: const TextStyle(color: textColor),
decoration: _inputDecoration(
hint: 'Re-enter your password',
icon: Icons.lock_reset_rounded,
suffixIcon: IconButton(
icon: Icon(
_hideConfirmPassword
? Icons.visibility_off_outlined
: Icons.visibility_outlined,
color: accentColor,
),
onPressed: () {
setState(() {
_hideConfirmPassword =
!_hideConfirmPassword;
});
},
),
),
validator: (value) {
if (value == null || value.isEmpty) {
return 'Please confirm your password';
}

if (value != _passwordController.text) {
return 'Passwords do not match';
}

return null;
},
),

const SizedBox(height: 28),

SizedBox(
height: 54,
child: ElevatedButton(
onPressed: _isLoading ? null : _register,
style: ElevatedButton.styleFrom(
  backgroundColor: primaryColor,
  foregroundColor: backgroundColor,
  disabledBackgroundColor:
  primaryColor.withValues(alpha: 0.5),
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  ),
),
  child: _isLoading
      ? const SizedBox(
    width: 24,
    height: 24,
    child: CircularProgressIndicator(
      strokeWidth: 2.5,
      color: backgroundColor,
    ),
  )
      : const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Create Account',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(width: 8),
      Icon(Icons.arrow_forward_rounded),
    ],
  ),
),
),

  const SizedBox(height: 20),

  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Flexible(
        child: Text(
          'Already have an account?',
          style: TextStyle(
            color: mutedTextColor,
            fontSize: 14,
          ),
        ),
      ),
      TextButton(
        onPressed: _isLoading
            ? null
            : () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
              const LoginPage(),
            ),
          );
        },
        child: const Text(
          'Login',
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  ),
],
),
),
),
),
),
);
}
}