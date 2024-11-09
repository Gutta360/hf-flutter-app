import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TxnForm extends StatefulWidget {
  @override
  _TxnFormState createState() => _TxnFormState();
}

class _TxnFormState extends State<TxnForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedName;
  String? _billNo;
  double? _amount;
  DateTime? _selectedDate;
  String? _selectedType;

  final List<String> nameOptions = ['John Doe', 'Jane Smith', 'Alex Brown'];
  final List<String> typeOptions = ['CREDIT', 'ANAMATH'];

  TextEditingController _dateController = TextEditingController();
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
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
                  GridView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 4.0,
                      childAspectRatio: 6.0,
                    ),
                    children: [
                      _buildDropdownField(
                        label: 'Name',
                        value: _selectedName,
                        items: nameOptions,
                        onChanged: (value) {
                          setState(() {
                            _selectedName = value;
                          });
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? 'Name is required'
                            : null,
                      ),
                      _buildDropdownField(
                        label: 'Type',
                        value: _selectedType,
                        items: typeOptions,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? 'Type is required'
                            : null,
                      ),
                      _buildTextField(
                        label: 'Bill No',
                        onChanged: (value) {
                          _billNo = value;
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? 'Bill No is required'
                            : null,
                      ),
                      _buildTextField(
                        label: 'Amount',
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          _amount = double.tryParse(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Amount is required';
                          }
                          double? amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return 'Enter a valid amount greater than 0';
                          }
                          return null;
                        },
                      ),
                      _buildDatePickerField()
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Transaction saved Successfully')),
                        );
                      }
                    },
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal, // Text color
                      padding: EdgeInsets.symmetric(vertical: 14),
                      minimumSize: Size(120, 40),
                      textStyle: TextStyle(
                        fontSize: 15, // Font size // Optional: makes text bold
                      ), // Reduced height and width
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    required void Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildDatePickerField() {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
            _dateController.text = dateFormat.format(pickedDate);
          });
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: _dateController,
          decoration: InputDecoration(labelText: 'Date'),
          validator: (value) =>
              value == null || value.isEmpty ? 'Date is required' : null,
        ),
      ),
    );
  }
}
