import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicalLicensesView extends StatefulWidget {
  @override
  _MedicalLicensesViewState createState() => _MedicalLicensesViewState();
}

class _MedicalLicensesViewState extends State<MedicalLicensesView> {
  List<Map<String, dynamic>> licenses = [
    {
      'licenseName': 'DEA #',
      'value': 'AB1234567',
      'expirationDate': DateTime(2024, 12, 31),
    },
    {
      'licenseName': 'Medical License',
      'value': 'MD123456',
      'expirationDate': DateTime(2025, 6, 30),
    },
    {
      'licenseName': 'NPI #',
      'value': '1234567890',
      'expirationDate': DateTime(2026, 3, 15),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Licenses'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddLicenseView(onLicenseAdded: _addLicense),
                  ),
                );
              },
              child: Text('Add Medical License'),
            ),
          ),
          Expanded(
            child: licenses.isNotEmpty
                ? ListView(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('License Type')),
                      DataColumn(label: Text('License #')),
                      DataColumn(label: Text('Expires')),
                    ],
                    rows: licenses.map((license) {
                      return DataRow(
                        cells: [
                          DataCell(Text(license['licenseName'])),
                          DataCell(Text(license['value'])),
                          DataCell(Text(DateFormat('MM/dd/yyyy').format(license['expirationDate']))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            )
                : Center(child: Text('No licenses found')),
          ),
        ],
      ),
    );
  }

  void _addLicense(Map<String, dynamic> newLicense) {
    setState(() {
      licenses.add(newLicense);
    });
  }
}

class AddLicenseView extends StatefulWidget {
  final Function(Map<String, dynamic>) onLicenseAdded;

  AddLicenseView({required this.onLicenseAdded});

  @override
  _AddLicenseViewState createState() => _AddLicenseViewState();
}

class _AddLicenseViewState extends State<AddLicenseView> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedLicenseType;
  final TextEditingController _licenseNumberController = TextEditingController();
  DateTime? _selectedDate;

  List<String> licenseTypes = ['DEA #', 'Medical License', 'NPI #'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medical License'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedLicenseType,
                decoration: InputDecoration(labelText: 'License Type'),
                items: licenseTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLicenseType = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a license type' : null,
              ),
              TextFormField(
                controller: _licenseNumberController,
                decoration: InputDecoration(labelText: 'License Number'),
                validator: (value) => value!.isEmpty ? 'Please enter license number' : null,
              ),
              ListTile(
                title: Text('Expiration Date'),
                subtitle: Text(_selectedDate == null ? 'Select date' : DateFormat('MM/dd/yyyy').format(_selectedDate!)),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365 * 10)),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add License'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      widget.onLicenseAdded({
        'licenseName': _selectedLicenseType,
        'value': _licenseNumberController.text,
        'expirationDate': _selectedDate,
      });
      Navigator.of(context).pop();
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an expiration date')),
      );
    }
  }
}


class AddMedicalLicenseForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  AddMedicalLicenseForm({required this.onSubmit});

  @override
  _AddMedicalLicenseFormState createState() => _AddMedicalLicenseFormState();
}

class _AddMedicalLicenseFormState extends State<AddMedicalLicenseForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedLicenseType;
  final TextEditingController _licenseNumberController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedState;

  List<String> licenseTypes = ['DEA #', 'Medical License', 'NPI #'];
  Map<String, String> states = {
    'AL': 'Alabama',
    'AK': 'Alaska',
    // TODO: Add other states
  };

  Map<String, String?> errors = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medical License'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedLicenseType,
                decoration: InputDecoration(
                  labelText: 'License Type',
                  errorText: errors['licenseName'],
                ),
                items: licenseTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLicenseType = newValue;
                    errors['licenseName'] = null;
                  });
                },
                validator: (value) => value == null ? 'Please select a license type' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _licenseNumberController,
                decoration: InputDecoration(
                  labelText: 'License #',
                  errorText: errors['value'],
                ),
                validator: (value) => value!.isEmpty ? 'Please enter license number' : null,
                onChanged: (_) => setState(() => errors['value'] = null),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Expiration Date',
                    errorText: errors['expirationDate'],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                      ),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (_selectedLicenseType == 'Medical License')
                DropdownButtonFormField<String>(
                  value: _selectedState,
                  decoration: InputDecoration(
                    labelText: 'State',
                    errorText: errors['state'],
                  ),
                  items: states.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedState = newValue;
                      errors['state'] = null;
                    });
                  },
                  validator: (value) => _selectedLicenseType == 'Medical License' && value == null
                      ? 'Please select a state'
                      : null,
                ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 10)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        errors['expirationDate'] = null;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        setState(() {
          errors['expirationDate'] = 'Please select an expiration date';
        });
        return;
      }

      widget.onSubmit({
        'licenseName': _selectedLicenseType,
        'value': _licenseNumberController.text,
        'expirationDate': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'state': _selectedLicenseType == 'Medical License' ? _selectedState : null,
      });
    }
  }
}