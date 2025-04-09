import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'dob': _dobController.text,
          'school': _schoolController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Profile Updated Successfully!",
              style: TextStyle(color: Colors.green),
            ),
            backgroundColor: Colors.white,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xffF4F5F9),
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Profile Picture with Edit Option
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage(
                        "assets/HomeScreen_Profile.png",
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Implement image picker here
                      },
                      icon: const Icon(Icons.edit, size: 30),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              _buildLabel("Name"),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _firstNameController,
                      hint: "First Name",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      controller: _lastNameController,
                      hint: "Last Name",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _buildLabel("Email"),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _emailController,
                hint: "amar123@gmail.com",
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),
              _buildLabel("Date of Birth"),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: _buildTextField(
                    controller: _dobController,
                    hint: "Select your DOB",
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              _buildLabel("School Name"),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _schoolController,
                hint: "ABC School",
              ),

              const SizedBox(height: 26),
              Center(child: _buildButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return SizedBox(
      height: 52,
      width: 193,
      child: ElevatedButton(
        onPressed: _updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff75DBCE),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text('Update', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

// Common Widget for Labels
Widget _buildLabel(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.black,
    ),
  );
}

// Common Widget for Text Fields
Widget _buildTextField({
  required TextEditingController controller,
  required String hint,
  bool obscureText = false,
  Widget? suffixIcon,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: const Color(0xff000000).withOpacity(0.1),
          blurRadius: 6,
          spreadRadius: 0,
          offset: const Offset(0, 7),
        ),
      ],
    ),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hint,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color(0xff636D77),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field cannot be empty';
        }
        if (keyboardType == TextInputType.emailAddress &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    ),
  );
}
