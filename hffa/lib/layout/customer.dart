import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Check if the customer with the same name and surname already exists
        QuerySnapshot existingCustomer = await FirebaseFirestore.instance
            .collection('customers')
            .where('name', isEqualTo: _nameController.text)
            .where('surname', isEqualTo: _surnameController.text)
            .get();

        if (existingCustomer.docs.isNotEmpty) {
          // Show an alert if the customer with the same name and surname already exists
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content:
                  Text('Customer with this name and surname already exists'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Save the form data to Firestore if the combination of name and surname doesn't exist
          await FirebaseFirestore.instance.collection('customers').add({
            'surname': _surnameController.text,
            'name': _nameController.text,
            'phone': _phoneController.text,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Form Saved Successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Clear the form after saving
          _surnameController.clear();
          _nameController.clear();
          _phoneController.clear();
        }
      } catch (error) {
        print("Error adding document: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save form'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _surnameController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSurnameField(),
                  SizedBox(height: 16),
                  _buildNameField(),
                  SizedBox(height: 16),
                  _buildPhoneField(),
                  SizedBox(height: 35),
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveForm,
                      child: Text('Save'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        minimumSize: Size(120, 40),
                        textStyle: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurnameField() {
    return TextFormField(
      controller: _surnameController,
      decoration:
          InputDecoration(labelText: 'Surname', prefixIcon: Icon(Icons.person)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Surname is required';
        } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
          return 'Surname should be alphabetic only';
        }
        return null;
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
          labelText: 'Name', prefixIcon: Icon(Icons.account_circle)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Name is required';
        } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
          return 'Name should be alphabetic only';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          labelText: 'Phone Number', prefixIcon: Icon(Icons.phone)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is required';
        } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
          return 'Enter a valid 10-digit phone number';
        }
        return null;
      },
    );
  }
}
