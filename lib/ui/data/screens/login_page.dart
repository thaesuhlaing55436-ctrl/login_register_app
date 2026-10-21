import 'package:flutter/material.dart';
import 'package:login_register_app/services/auth_service.dart';
import 'register_page.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
final _formKey = GlobalKey<FormState>();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final AuthService _authService = AuthService();

bool _hidePassword = true;
bool _isLoading = false;

static const Color primaryColor = Color(0xFFA78BFA);
static const Color accentColor = Color(0xFF67E8F9);
static const Color backgroundColor = Color(0xFF101827);
static const Color surfaceColor = Color(0xFF1D293B);
static const Color textColor = Color(0xFFF8FAFC);
static const Color mutedTextColor = Color(0xFFA9B6C9);

@override
void dispose() {
_emailController.dispose();
_passwordController.dispose();
super.dispose();
}

Future<void> _login() async {
if (!_formKey.currentState!.validate()) return;

setState(() {
_isLoading = true;
});

try {
await _authService.login(
email: _emailController.text.trim(),
password: _passwordController.text,
);

debugPrint('LOGIN SUCCESS');

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
content: Text('Login failed: $e'),
backgroundColor: const Color(0xFF35445B),
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

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: backgroundColor,
body: SafeArea(
child: Center(
child: SingleChildScrollView(
padding: const EdgeInsets.symmetric(
horizontal: 24,
vertical: 32,
),
child: Form(
key: _formKey,
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
const SizedBox(height: 12),

// App logo
Center(
child: Container(
width: 92,
height: 92,
decoration: BoxDecoration(
color: surfaceColor,
borderRadius: BorderRadius.circular(28),
border: Border.all(
color: primaryColor.withValues(alpha: 0.5),
),
),
child: const Icon(
Icons.lock_person_rounded,
size: 48,
color: primaryColor,
),
),
),

const SizedBox(height: 28),

const Text(
'Welcome Back',
textAlign: TextAlign.center,
style: TextStyle(
color: textColor,
fontSize: 30,
fontWeight: FontWeight.bold,
letterSpacing: 0.3,
),
),

const SizedBox(height: 10),

const Text(
'Sign in to continue to your account',
textAlign: TextAlign.center,
style: TextStyle(
color: mutedTextColor,
fontSize: 14,
),
),

const SizedBox(height: 36),
const Text(
'Email Address',
style: TextStyle(
color: textColor,
fontSize: 14,
fontWeight: FontWeight.w600,
),
),

const SizedBox(height: 10),

TextFormField(
controller: _emailController,
keyboardType: TextInputType.emailAddress,
textInputAction: TextInputAction.next,
style: const TextStyle(color: textColor),
decoration: InputDecoration(
hintText: 'Enter your email',
prefixIcon: const Icon(
Icons.email_outlined,
color: primaryColor,
),
filled: true,
fillColor: surfaceColor,
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
),
validator: (value) {
if (value == null || value.trim().isEmpty) {
return 'Please enter your email';
}

final email = value.trim();

if (!RegExp(
r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
).hasMatch(email)) {
return 'Please enter a valid email';
}

return null;
},
),

const SizedBox(height: 22),

const Text(
'Password',
style: TextStyle(
color: textColor,
fontSize: 14,
fontWeight: FontWeight.w600,
),
),

const SizedBox(height: 10),

TextFormField(
controller: _passwordController,
obscureText: _hidePassword,
textInputAction: TextInputAction.done,
onFieldSubmitted: (_) {
if (!_isLoading) _login();
},
style: const TextStyle(color: textColor),
decoration: InputDecoration(
hintText: 'Enter your password',
prefixIcon: const Icon(
Icons.lock_outline_rounded,
color: primaryColor,
),
suffixIcon: IconButton(
tooltip: _hidePassword
? 'Show password'
: 'Hide password',
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
filled: true,
fillColor: surfaceColor,
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
),
validator: (value) {
if (value == null || value.isEmpty) {
return 'Please enter your password';
}

return null;
},
),

const SizedBox(height: 30),

SizedBox(
height: 54,
child: ElevatedButton(
onPressed: _isLoading ? null : _login,
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
'Login',
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

const SizedBox(height: 24),

Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Flexible(
child: Text(
"Don't have an account?",
style: TextStyle(
color: mutedTextColor,
fontSize: 14,
),
),
),
TextButton(
onPressed: () {
Navigator.push(
context,
  MaterialPageRoute(
    builder: (context) =>
    const RegisterPage(),
  ),
);
},
  child: const Text(
    'Register',
    style: TextStyle(
      color: accentColor,
      fontWeight: FontWeight.bold,
    ),
  ),
),
],
),

  const SizedBox(height: 12),
],
),
),
),
),
),
);
}
}
