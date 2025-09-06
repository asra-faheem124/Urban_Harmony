import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/signupController.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';
import 'package:laptop_harbor/userPanel/login.dart';

class SignUp extends StatefulWidget {
  final String role; // Accept role as named parameter
  const SignUp({Key? key, this.role = "user"}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController phoneController;

  final Signupcontroller signupcontroller = Get.put(Signupcontroller());

  // selected role state
  late String selectedRole;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();

    // initialize role from constructor (defaults to "user")
    selectedRole = widget.role;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 360,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    User_Heading(title: 'Create \nyour account'),
                    const SizedBox(height: 30),

                    // Name
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        if (value.length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Email
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email Address',
                        hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Please enter your email";
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Password
                    Obx(
                      () => TextFormField(
                        controller: passwordController,
                        obscureText: !signupcontroller.isVisible.value,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(fontSize: 16, color: Colors.black),
                          suffixIcon: GestureDetector(
                            onTap: () => signupcontroller.isVisible.toggle(),
                            child: signupcontroller.isVisible.value
                                ? const FaIcon(FontAwesomeIcons.eyeSlash)
                                : const FaIcon(FontAwesomeIcons.eye),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Phone
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        if (!RegExp(r'^\d{10,}$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Role selection (pre-selected by constructor)
                    const Text("Register as:", style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text("User"),
                            value: "user",
                            groupValue: selectedRole,
                            onChanged: (value) => setState(() => selectedRole = value!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text("Designer"),
                            value: "designer",
                            groupValue: selectedRole,
                            onChanged: (value) => setState(() => selectedRole = value!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),

                    // Signup button & other UI
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyButton(
                            title: 'SIGNUP',
                            height: 50.0,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String username = nameController.text.trim();
                                String useremail = emailController.text.trim();
                                String userpassword = passwordController.text.trim();
                                String userphoneNumber = phoneController.text.trim();

                                // CALL CONTROLLER: adjust method name if your controller uses a different name
                                // If your controller method is signUpMethod (lowercase), use that.
                                // If it's SignUpMethod (from previous code), change accordingly.
                                // Example below assumes signUpMethod (lowercase).
                                var userCredential = await signupcontroller.signUpMethod(
                                  username,
                                  useremail,
                                  userpassword,
                                  userphoneNumber,
                                  selectedRole,
                                );

                                if (userCredential != null) {
                                  greenSnackBar(
                                    '✅ Success!',
                                    'Signup Successful! Please verify your email address.',
                                  );
                                  Get.to(() => Login());
                                }
                              } else {
                                redSnackBar(
                                  '❌ Error!',
                                  'Please fill out all the fields correctly.',
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 30),
                          const Text('or signup with', style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircleAvatar(radius: 30, child: FaIcon(FontAwesomeIcons.apple, size: 40, color: Colors.black)),
                              SizedBox(width: 10),
                              CircleAvatar(radius: 30, child: FaIcon(FontAwesomeIcons.google, size: 40, color: Colors.black)),
                              SizedBox(width: 10),
                              CircleAvatar(radius: 30, child: FaIcon(FontAwesomeIcons.facebook, size: 40, color: Colors.black)),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Already have an account?', style: TextStyle(fontSize: 14)),
                              TextButton(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Login())),
                                child: const Text('Login', style: TextStyle(fontSize: 14, color: Colors.black)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
