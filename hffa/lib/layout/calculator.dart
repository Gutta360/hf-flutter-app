import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TxnSearchForm extends StatefulWidget {
  @override
  _TxnSearchFormState createState() => _TxnSearchFormState();
}

class _TxnSearchFormState extends State<TxnSearchForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedName;
  String? _billNo;
  double? _amount;
  DateTime? _selectedDate;
  String? _selectedType;
  String? _selectedInterest;

  final List<String> nameOptions = ['John Doe', 'Jane Smith', 'Alex Brown'];
  final List<String> typeOptions = ['All', 'CREDIT', 'ANAMATH'];
  final List<String> interestOptions = [
    '0 %',
    '1 %',
    '1.5 %',
    '2 %',
    '2.5 %',
    '3 %',
    '3.5 %'
  ];

  final List<Map<String, dynamic>> transactions = [
    {
      "sNo": 1,
      "customerName": "John Doe",
      "billNo": "B123",
      "amount": 1000.0,
      "date": DateTime(2024, 1, 1),
      "type": "CREDIT",
      "interestRate": "2 %",
      "interestAmount": 20.0,
      "amountWithInterest": 1020.0,
    },
    {
      "sNo": 2,
      "customerName": "Jane Smith",
      "billNo": "B124",
      "amount": 1500.0,
      "date": DateTime(2024, 2, 1),
      "type": "ANAMATH",
      "interestRate": "1.5 %",
      "interestAmount": 22.5,
      "amountWithInterest": 1522.5,
    },
    {
      "sNo": 3,
      "customerName": "Alex Brown",
      "billNo": "B125",
      "amount": 2000.0,
      "date": DateTime(2024, 3, 1),
      "type": "CREDIT",
      "interestRate": "3 %",
      "interestAmount": 60.0,
      "amountWithInterest": 2060.0,
    },
  ];

  List<Map<String, dynamic>> filteredTransactions = [];
  TextEditingController _dateController = TextEditingController();
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    filteredTransactions = transactions;
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _filterTransactions() {
    setState(() {
      double? selectedInterestRate;
      if (_selectedInterest != null) {
        selectedInterestRate =
            double.tryParse(_selectedInterest!.replaceAll('%', '').trim());
      }

      filteredTransactions = transactions.where((txn) {
        bool matchesName =
            _selectedName == null || txn['customerName'] == _selectedName;

        // Updated condition for date filtering (From Date)
        bool matchesDate = _selectedDate == null ||
            (txn['date'] != null && txn['date'].isAfter(_selectedDate!) ||
                txn['date'].isAtSameMomentAs(_selectedDate!));

        bool matchesType = _selectedType == null ||
            _selectedType == 'All' ||
            txn['type'] == _selectedType;

        return matchesName && matchesDate && matchesType;
      }).map((txn) {
        if (selectedInterestRate != null) {
          double interestAmount = (txn['amount'] * selectedInterestRate) / 100;
          txn['interestRate'] = '$_selectedInterest';
          txn['interestAmount'] = interestAmount;
          txn['amountWithInterest'] = txn['amount'] + interestAmount;
        }
        return txn;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GridView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 4.0,
                  childAspectRatio: 10.0,
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
                  ),
                  _buildDatePickerField(),
                  _buildDropdownField(
                    label: 'Type',
                    value: _selectedType,
                    items: typeOptions,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                  ),
                  _buildDropdownField(
                    label: 'Interest',
                    value: _selectedInterest,
                    items: interestOptions,
                    onChanged: (value) {
                      setState(() {
                        _selectedInterest = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _filterTransactions,
                child: Text('Calculate'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal, // Text color
                  padding: EdgeInsets.symmetric(vertical: 14),
                  minimumSize: Size(120, 40),
                  textStyle: TextStyle(
                    fontSize: 15, // Font size // Optional: makes text bold
                  ), // Reduced height and width
                ),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('S.No')),
                    DataColumn(label: Text('Customer Name')),
                    DataColumn(label: Text('Bill No')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Interest Rate')),
                    DataColumn(label: Text('Interest Amount')),
                    DataColumn(label: Text('Amount With Interest')),
                  ],
                  rows: filteredTransactions.map((txn) {
                    return DataRow(cells: [
                      DataCell(Text(txn['sNo'].toString())),
                      DataCell(Text(txn['customerName'])),
                      DataCell(Text(txn['billNo'])),
                      DataCell(Text(txn['amount'].toString())),
                      DataCell(Text(dateFormat.format(txn['date']))),
                      DataCell(Text(txn['type'])),
                      DataCell(Text(txn['interestRate'])),
                      DataCell(Text(txn['interestAmount'].toString())),
                      DataCell(Text(txn['amountWithInterest'].toString())),
                    ]);
                  }).toList(),
                ),
              ),
            ],
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
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    required void Function(String) onChanged,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      onChanged: onChanged,
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
          decoration: InputDecoration(labelText: 'From Date'),
        ),
      ),
    );
  }
}
