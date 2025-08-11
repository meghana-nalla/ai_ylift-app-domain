import 'package:flutter/material.dart';

class SpecialtySettings extends StatefulWidget {
  @override
  _SpecialtySettingsState createState() => _SpecialtySettingsState();
}

class _SpecialtySettingsState extends State<SpecialtySettings> {
  bool _isExpanded = false;
  bool _isWorking = false;
  String? _currentSpecialty;
  String? _newSpecialty;
  String? _newOtherSpecialty;
  String? _error;

  final List<String> specialties = [
    'Cardiology',
    'Dermatology',
    'Neurology',
    'Oncology',
    'Pediatrics',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentSpecialty();
  }

  void _loadCurrentSpecialty() {
    // TODO: replace simulation of API call
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _currentSpecialty = 'Cardiology';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Specialty'),
            subtitle: Text('Specialty is ${_currentSpecialty ?? "not set"}'),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded) _buildSpecialtyForm(),
        ],
      ),
    );
  }

  Widget _buildSpecialtyForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _newSpecialty,
            decoration: InputDecoration(labelText: 'Specialty'),
            items: specialties.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _newSpecialty = newValue;
                if (newValue != 'Other') {
                  _newOtherSpecialty = null;
                }
              });
            },
          ),
          if (_newSpecialty == 'Other')
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Enter your specialty'),
                onChanged: (value) {
                  setState(() {
                    _newOtherSpecialty = value;
                  });
                },
              ),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _error!,
                style: TextStyle(color: Colors.red),
              ),
            ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isValid() ? _updateSpecialty : null,
            child: _isWorking
                ? CircularProgressIndicator(color: Colors.white)
                : Text('Save'),
          ),
        ],
      ),
    );
  }

  bool _isValid() {
    return _newSpecialty != null &&
        (_newSpecialty != 'Other' ||
            (_newSpecialty == 'Other' &&
                _newOtherSpecialty != null &&
                _newOtherSpecialty!.isNotEmpty));
  }

  void _updateSpecialty() {
    setState(() {
      _isWorking = true;
      _error = null;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isWorking = false;
        if (_newSpecialty == 'Other') {
          _currentSpecialty = _newOtherSpecialty;
        } else {
          _currentSpecialty = _newSpecialty;
        }
        _isExpanded = false;
        _newSpecialty = null;
        _newOtherSpecialty = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Specialty updated successfully')),
      );
    });
  }
}
