import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
class ResaleCertificatesList extends StatefulWidget {
  @override
  _ResaleCertificatesListState createState() => _ResaleCertificatesListState();
}

class _ResaleCertificatesListState extends State<ResaleCertificatesList> {
  List<Map<String, dynamic>> resaleCertificates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResaleCertificates();
  }

  Future<void> _loadResaleCertificates() async {
    // TODO:  API call
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      resaleCertificates = [
        {'state': 'CA', 'status': 'Approved', 'expirationDate': DateTime(2024, 12, 31)},
        {'state': 'NY', 'status': 'Pending', 'expirationDate': DateTime(2023, 6, 30)},
        {'state': 'TX', 'status': 'Expired', 'expirationDate': DateTime(2022, 3, 15)},
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resale Certificates'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to add resale certificate form
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResaleCertificateForm(
                    onSubmit: (Map<String, dynamic> data) {
                      // TODO: Handle form submission
                      print(data);
                      Navigator.pop(context);
                    },
                  )),
                );
              },
              child: Text('Add Resale Certificate'),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : resaleCertificates.isEmpty
                ? Center(child: Text('No resale certificates found'))
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('State')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Expires')),
                ],
                rows: resaleCertificates.map((cert) {
                  return DataRow(
                    cells: [
                      DataCell(Text(cert['state'])),
                      DataCell(Text(cert['status'])),
                      DataCell(Text(DateFormat('MM/dd/yyyy').format(cert['expirationDate']))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class ResaleCertificateForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  ResaleCertificateForm({required this.onSubmit});

  @override
  _ResaleCertificateFormState createState() => _ResaleCertificateFormState();
}

class _ResaleCertificateFormState extends State<ResaleCertificateForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedState;
  String? _fileName;
  String _message = '';
  Map<String, String> _errors = {};

  final List<Map<String, String>> states = [
    {'value': 'AL', 'text': 'Alabama'},
    {'value': 'AK', 'text': 'Alaska'},
    // TODO: Add all other states
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Resale Certificate'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedState,
                decoration: InputDecoration(
                  labelText: 'State',
                  errorText: _errors['state'],
                ),
                items: states.map((state) {
                  return DropdownMenuItem<String>(
                    value: state['value'],
                    child: Text(state['text']!),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedState = newValue;
                    //_errors['state'] = null;
                  });
                },
                validator: (value) => value == null ? 'Please select a state' : null,
              ),
              SizedBox(height: 16),
              Text('Proof of Certificate'),
              SizedBox(height: 8),
              Text(
                'If you have a resale certificate, upload it here. If not, fill out and upload',
                style: TextStyle(fontSize: 12),
              ),
              InkWell(
                child: Text(
                  'this form',
                  style: TextStyle(fontSize: 12, color: Colors.blue, decoration: TextDecoration.underline),
                ),
                onTap: () => _launchURL('/static/documents/uniform-sales-use-tax-exemption-certificate.pdf'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _pickFile,
                child: Text('Choose File'),
              ),
              if (_fileName != null) Text(_fileName!),
              if (_errors['file'] != null)
                Text(_errors['file']!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Message',
                  hintText: 'Include any additional pertinent information here.',
                ),
                maxLines: 5,
                onChanged: (value) => _message = value,
              ),
              SizedBox(height: 16),
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

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        // _errors['file'] = null;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_fileName == null) {
        setState(() {
          _errors['file'] = 'Please select a file';
        });
        return;
      }

      // TODO: Test  upload the file and get a URL
      // then remove this example, we'll just use a placeholder URL
      String fileUrl = 'https://api/uploaded-file.pdf';

      widget.onSubmit({
        'state': _selectedState,
        'attachmentUrl': fileUrl,
        'message': _message,
      });
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}