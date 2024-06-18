import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../News/home.dart';
import '../const/AppColor.dart';
import '../widgets/coustomButton.dart';
import 'login.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ConfirmpasswordController = TextEditingController();

  bool _obscureText = true;

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deep_orange,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 150.h,
              width: ScreenUtil().screenWidth,
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.light,
                        color: Colors.transparent,
                      ),
                    ),
                    Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 22.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: ScreenUtil().screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.r),
                    topRight: Radius.circular(28.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          "Welcome Buddy!",
                          style: TextStyle(fontSize: 22.sp, color: AppColors.deep_orange),
                        ),
                        Text(
                          "Glad to see you back my buddy.",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFFBBBBBB),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        _buildTextField(
                          controller: _nameController,
                          label: "NAME",
                          hintText: "Enter your name",
                          icon: Icons.person_outline,
                        ),
                        SizedBox(height: 10.h),
                        IntlPhoneField(
                            controller: _phoneController,
                          initialCountryCode: 'IN',
                          onChanged: (phone) {
                            print(phone.completeNumber);
                          },
                        ),
                        SizedBox(height: 10.h),
                        _buildTextField(
                          controller: _emailController,
                          label: "EMAIL",
                          hintText: "aadi@gmail.com",
                          icon: Icons.email_outlined,
                        ),
                        SizedBox(height: 10.h),
                        _buildTextField(
                          controller: _passwordController,
                          label: "PASSWORD",
                          hintText: "password must be 6 character",
                          icon: Icons.lock_outline,
                          obscureText: _obscureText,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(
                              _obscureText ? Icons.remove_red_eye : Icons.visibility_off,
                              size: 20.w,
                            ),
                          ),
                        ),

                        SizedBox(height: 10.h),
                        _buildTextField(
                          controller: _ConfirmpasswordController,
                          label: "CONFIRM PASSWORD",
                          hintText: "password must be 6 character",
                          icon: Icons.lock_outline,
                          obscureText: _obscureText,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(
                              _obscureText ? Icons.remove_red_eye : Icons.visibility_off,
                              size: 20.w,
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),
                        Wrap(
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFBBBBBB),
                              ),
                            ),
                            GestureDetector(
                              child: Text(
                                " Sign In",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.deep_orange,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(builder: (context) => LoginScreen()));
                              },
                            )
                          ],
                        ),



                        SizedBox(height: 32.h),
                        // Elevated button
                        SizedBox(
                          child: customButton(
                            "SignUp",
                            onPressed: () async {
                              if (_nameController.text.isEmpty ||
                                  _emailController.text.isEmpty ||
                                  _phoneController.text.isEmpty ||
                                  _passwordController.text.isEmpty ||
                              _ConfirmpasswordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content:
                                    Text("Fill all the * necessary fields")));
                              } else if (!EmailValidator.validate(_emailController.text)) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Email address is invalid!")));
                              } else if (_passwordController.text.length < 6) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Password should be atleast 6 characters")));
                              } else if (_passwordController.text != _ConfirmpasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Passwords do not match")));
                              } else {
                                try {
                                  final user = await _auth
                                      .createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.user!.uid)
                                      .set({
                                    'name': _nameController.text,
                                    'email': _emailController.text,
                                    'phone': _phoneController.text,

                                  });



                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Data submitted")));


                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text("Sign up failed: $e")));
                                }
                              }
                            },

                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Row(
      children: [
        Container(
          height: 48.h,
          width: 41.w,
          decoration: BoxDecoration(
            color: AppColors.deep_orange,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
              size: 20.w,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: Color(0xFF414041),
              ),
              labelText: label,
              labelStyle: TextStyle(
                fontSize: 15.sp,
                color: AppColors.deep_orange,
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
