import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProviderCampaignManagement extends StatefulWidget {
  @override
  _ProviderCampaignManagementState createState() => _ProviderCampaignManagementState();
}

class _ProviderCampaignManagementState extends State<ProviderCampaignManagement> {
  List<Map<String, dynamic>> campaigns = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  Future<void> _loadCampaigns() async {
    // TODO:  API call
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      campaigns = [
        {
          'id': '1',
          'name': 'Summer Health Campaign',
          'status': 'Active',
          'subscriptionStatus': 'Active',
          'campaignStatus': '2/2 Complete',
          'product': 'Health Essentials Course',
          'leads': 5,
        },
        {
          'id': '2',
          'name': 'Fall Wellness Initiative',
          'status': 'Inactive',
          'subscriptionStatus': 'Pending',
          'campaignStatus': '1/2 Pending Course',
          'product': 'Wellness Fundamentals',
          'leads': 0,
        },
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Campaigns'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : campaigns.isEmpty
          ? ProviderNotAvailable()
          : CampaignList(campaigns: campaigns),
    );
  }
}

class CampaignList extends StatelessWidget {
  final List<Map<String, dynamic>> campaigns;

  CampaignList({required this.campaigns});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This is a list of all your active campaigns. By purchasing the select products your rating within the campaign increases. The higher the rating the more lead traffic you can receive from our select lead websites.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Subscr. Status')),
                  DataColumn(label: Text('Campaign Status')),
                  DataColumn(label: Text('Product')),
                  DataColumn(label: Text('Contact Info')),
                  DataColumn(label: Text('Leads')),
                ],
                rows: campaigns.map((campaign) {
                  return DataRow(
                    cells: [
                      DataCell(Text(campaign['name'])),
                      DataCell(Text(
                        campaign['status'],
                        style: TextStyle(
                          color: campaign['status'] == 'Active' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      DataCell(Text(campaign['subscriptionStatus'])),
                      DataCell(Text(campaign['campaignStatus'])),
                      DataCell(Text(campaign['product'])),
                      DataCell(
                        ElevatedButton(
                          child: Text('View/Edit'),
                          onPressed: () => _showContactInfoDialog(context, campaign),
                        ),
                      ),
                      DataCell(
                        ElevatedButton(
                          child: Text('Enter'),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LeadsView(campaignName: campaign['name'], providerId: campaign['id']),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactInfoDialog(BuildContext context, Map<String, dynamic> campaign) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${campaign['name']} Provider Contact Information'),
          content: SingleChildScrollView(
            child: ContactInfoForm(),
          ),
        );
      },
    );
  }
}

class ContactInfoForm extends StatefulWidget {
  @override
  _ContactInfoFormState createState() => _ContactInfoFormState();
}

class _ContactInfoFormState extends State<ContactInfoForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _businessName;
  String? _phone;
  String? _email;
  String? _address;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Full Name'),
            validator: (value) => value!.isEmpty ? 'Please enter your full name' : null,
            onSaved: (value) => _name = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Practice Name'),
            validator: (value) => value!.isEmpty ? 'Please enter your practice name' : null,
            onSaved: (value) => _businessName = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Phone'),
            validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
            onSaved: (value) => _phone = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
            onSaved: (value) => _email = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Address'),
            validator: (value) => value!.isEmpty ? 'Please enter your address' : null,
            onSaved: (value) => _address = value,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            child: Text('Submit'),
            onPressed: _submitForm,
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Here you would typically send this data to your backend
      print('Name: $_name');
      print('Business Name: $_businessName');
      print('Phone: $_phone');
      print('Email: $_email');
      print('Address: $_address');
      Navigator.of(context).pop();
    }
  }
}

class LeadsView extends StatefulWidget {
  final String campaignName;
  final String providerId;

  LeadsView({required this.campaignName, required this.providerId});

  @override
  _LeadsViewState createState() => _LeadsViewState();
}

class _LeadsViewState extends State<LeadsView> {
  List<Map<String, dynamic>> leads = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeads();
  }

  Future<void> _loadLeads() async {
    // Simulating API call
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      leads = [
        {
          'firstName': 'John',
          'lastName': 'Doe',
          'phone': '123-456-7890',
          'email': 'john.doe@example.com',
          'message': 'Interested in your services',
          'createdAt': DateTime.now().subtract(Duration(days: 2)),
        },
        {
          'firstName': 'Jane',
          'lastName': 'Smith',
          'phone': '987-654-3210',
          'email': 'jane.smith@example.com',
          'message': 'Please contact me for more information',
          'createdAt': DateTime.now().subtract(Duration(days: 1)),
        },
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Leads for ${widget.campaignName}'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('First Name')),
            DataColumn(label: Text('Last Name')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Message')),
            DataColumn(label: Text('Date')),
          ],
          rows: leads.map((lead) {
            return DataRow(
              cells: [
                DataCell(Text(lead['firstName'])),
                DataCell(Text(lead['lastName'])),
                DataCell(Text(lead['phone'])),
                DataCell(Text(lead['email'])),
                DataCell(Text(lead['message'])),
                DataCell(Text(DateFormat('MM/dd/yyyy').format(lead['createdAt']))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ProviderNotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Not Available',
            style: TextStyle(fontSize: 52, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'To join a Product Provider Campaign you must purchase the respective course.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            child: Text('View Campaigns'),
            onPressed: () {
              // TODO: create navigation to campaign list
            },
          ),
        ],
      ),
    );
  }
}