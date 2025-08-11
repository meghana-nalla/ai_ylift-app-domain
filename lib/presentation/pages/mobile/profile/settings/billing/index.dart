import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillingInfo extends StatefulWidget {
  final String userName;

  BillingInfo({required this.userName});

  @override
  _BillingInfoState createState() => _BillingInfoState();
}

class _BillingInfoState extends State<BillingInfo> {
  List<Map<String, dynamic>> cards = [
    {
      'id': '1',
      'cardType': 'Visa',
      'cardNumber': '****1234',
    },
    {
      'id': '2',
      'cardType': 'MasterCard',
      'cardNumber': '****5678',
    },
  ];

  bool _isExpanded = false;
  bool _isNewCardExpanded = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardExpMonthController = TextEditingController();
  final TextEditingController _cardExpYearController = TextEditingController();
  final TextEditingController _cardCvcController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  String? _selectedState;
  String? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _isExpanded = !isExpanded;
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('Billing Info'),
                  subtitle: Text(
                    '${widget.userName} has ${cards.length} saved card${cards.length != 1 ? 's' : ''}.',
                  ),
                );
              },
              body: Column(
                children: [
                  ...cards.map((card) => CardItem(
                    card: card,
                    onDelete: () => _deleteCard(card['id']),
                  )),
                ],
              ),
              isExpanded: _isExpanded,
            ),
          ],
        ),
        SizedBox(height: 16),
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _isNewCardExpanded = !isExpanded;
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('New Payment Method'),
                  subtitle: Text('Add new payment details below.'),
                );
              },
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _cardNumberController,
                        decoration: InputDecoration(labelText: 'Card Number'),
                        validator: (value) => value!.isEmpty ? 'Please enter card number' : null,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cardExpMonthController,
                              decoration: InputDecoration(labelText: 'Exp Month (MM)'),
                              validator: (value) => value!.isEmpty ? 'Please enter expiration month' : null,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _cardExpYearController,
                              decoration: InputDecoration(labelText: 'Exp Year (YYYY)'),
                              validator: (value) => value!.isEmpty ? 'Please enter expiration year' : null,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _cardCvcController,
                              decoration: InputDecoration(labelText: 'CVV'),
                              validator: (value) => value!.isEmpty ? 'Please enter CVV' : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Text('Billing Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _firstNameController,
                              decoration: InputDecoration(labelText: 'First Name'),
                              validator: (value) => value!.isEmpty ? 'Please enter first name' : null,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _lastNameController,
                              decoration: InputDecoration(labelText: 'Last Name'),
                              validator: (value) => value!.isEmpty ? 'Please enter last name' : null,
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(labelText: 'Address'),
                        validator: (value) => value!.isEmpty ? 'Please enter address' : null,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cityController,
                              decoration: InputDecoration(labelText: 'City'),
                              validator: (value) => value!.isEmpty ? 'Please enter city' : null,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedState,
                              decoration: InputDecoration(labelText: 'State'),
                              items: ['CA', 'NY', 'TX'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedState = newValue;
                                });
                              },
                              validator: (value) => value == null ? 'Please select a state' : null,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _zipController,
                              decoration: InputDecoration(labelText: 'Zip/Postal'),
                              validator: (value) => value!.isEmpty ? 'Please enter zip code' : null,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedCountry,
                              decoration: InputDecoration(labelText: 'Country'),
                              items: ['US', 'CA'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value == 'US' ? 'United States' : 'Canada'),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCountry = newValue;
                                });
                              },
                              validator: (value) => value == null ? 'Please select a country' : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _submitNewCard,
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
              isExpanded: _isNewCardExpanded,
            ),
          ],
        ),
      ],
    );
  }

  void _deleteCard(String id) {
    setState(() {
      cards.removeWhere((card) => card['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Card has been successfully removed')),
    );
  }

  void _submitNewCard() {
    if (_formKey.currentState!.validate()) {
      // TODO: send data to backend
      setState(() {
        cards.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'cardType': 'New Card',
          'cardNumber': '****' + _cardNumberController.text.substring(_cardNumberController.text.length - 4),
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New card has been successfully added')),
      );
      _clearForm();
    }
  }

  void _clearForm() {
    _cardNumberController.clear();
    _cardExpMonthController.clear();
    _cardExpYearController.clear();
    _cardCvcController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _addressController.clear();
    _cityController.clear();
    _zipController.clear();
    setState(() {
      _selectedState = null;
      _selectedCountry = null;
      _isNewCardExpanded = false;
    });
  }
}

class CardItem extends StatelessWidget {
  final Map<String, dynamic> card;
  final VoidCallback onDelete;

  CardItem({required this.card, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(_getCardIcon(card['cardType'])),
        title: Text('${card['cardType']} ending in ${card['cardNumber']}'),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }

  IconData _getCardIcon(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return Icons.credit_card;
      case 'mastercard':
        return Icons.credit_card;
      default:
        return Icons.credit_card;
    }
  }
}