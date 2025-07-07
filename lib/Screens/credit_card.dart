import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:realturn_app/Screens/confirmation1.dart';

class DonationForm extends StatefulWidget {
  final Function(Map<String, dynamic>)? onSubmit;

  const DonationForm({
    Key? key,
    this.onSubmit,
  }) : super(key: key);

  @override
  State<DonationForm> createState() => _DonationFormState();
}

class _DonationFormState extends State<DonationForm> {
  final _formKey = GlobalKey<FormState>();
  String selectedCountry = 'Uganda';
  bool saveInfo = false;
  bool _isLoading = false;

  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final securityCodeController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final amountController = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // List of countries from around the world
  final List<String> countries = [
    'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Antigua and Barbuda',
    'Argentina', 'Armenia', 'Australia', 'Austria', 'Azerbaijan', 'Bahamas', 'Bahrain',
    'Bangladesh', 'Barbados', 'Belarus', 'Belgium', 'Belize', 'Benin', 'Bhutan', 'Bolivia',
    'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei', 'Bulgaria', 'Burkina Faso',
    'Burundi', 'Cabo Verde', 'Cambodia', 'Cameroon', 'Canada', 'Central African Republic',
    'Chad', 'Chile', 'China', 'Colombia', 'Comoros', 'Congo', 'Costa Rica', 'Croatia',
    'Cuba', 'Cyprus', 'Czech Republic', 'Denmark', 'Djibouti', 'Dominica', 'Dominican Republic',
    'Ecuador', 'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia', 'Eswatini',
    'Ethiopia', 'Fiji', 'Finland', 'France', 'Gabon', 'Gambia', 'Georgia', 'Germany', 'Ghana',
    'Greece', 'Grenada', 'Guatemala', 'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti', 'Honduras',
    'Hungary', 'Iceland', 'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland', 'Israel', 'Italy',
    'Jamaica', 'Japan', 'Jordan', 'Kazakhstan', 'Kenya', 'Kiribati', 'Korea, North',
    'Korea, South', 'Kosovo', 'Kuwait', 'Kyrgyzstan', 'Laos', 'Latvia', 'Lebanon', 'Lesotho',
    'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Madagascar', 'Malawi',
    'Malaysia', 'Maldives', 'Mali', 'Malta', 'Marshall Islands', 'Mauritania', 'Mauritius',
    'Mexico', 'Micronesia', 'Moldova', 'Monaco', 'Mongolia', 'Montenegro', 'Morocco',
    'Mozambique', 'Myanmar', 'Namibia', 'Nauru', 'Nepal', 'Netherlands', 'New Zealand',
    'Nicaragua', 'Niger', 'Nigeria', 'North Macedonia', 'Norway', 'Oman', 'Pakistan', 'Palau',
    'Palestine', 'Panama', 'Papua New Guinea', 'Paraguay', 'Peru', 'Philippines', 'Poland',
    'Portugal', 'Qatar', 'Romania', 'Russia', 'Rwanda', 'Saint Kitts and Nevis', 'Saint Lucia',
    'Saint Vincent and the Grenadines', 'Samoa', 'San Marino', 'Sao Tome and Principe',
    'Saudi Arabia', 'Senegal', 'Serbia', 'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia',
    'Slovenia', 'Solomon Islands', 'Somalia', 'South Africa', 'South Sudan', 'Spain', 'Sri Lanka',
    'Sudan', 'Suriname', 'Sweden', 'Switzerland', 'Syria', 'Taiwan', 'Tajikistan', 'Tanzania',
    'Thailand', 'Timor-Leste', 'Togo', 'Tonga', 'Trinidad and Tobago', 'Tunisia', 'Turkey',
    'Turkmenistan', 'Tuvalu', 'Uganda', 'Ukraine', 'United Arab Emirates', 'United Kingdom',
    'United States', 'Uruguay', 'Uzbekistan', 'Vanuatu', 'Vatican City', 'Venezuela', 'Vietnam',
    'Yemen', 'Zambia', 'Zimbabwe'
  ];

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    securityCodeController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> _saveDonationToFirebase() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create a unique donation ID
      String donationId = _database.child('donations').push().key!;
      
      // Prepare donation data matching your required structure
      Map<String, dynamic> donationData = {
        'amount': amountController.text.trim(),
        'email': emailController.text.trim(),
        'paymentMethod': 'card',
        'phoneNumber': phoneController.text.trim(),
        'status': 'pending',
        'timestamp': ServerValue.timestamp,
        // Additional card-specific data
        'country': selectedCountry,
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'cardNumber': cardNumberController.text.trim(),
        'expiry': expiryController.text.trim(),
        'saveInfo': saveInfo,
      };

      // Save to Firebase Realtime Database
      await _database.child('donations').child(donationId).set(donationData);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Donation submitted successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Clear form fields
      _clearForm();

      // Call the original onSubmit callback if provided
      if (widget.onSubmit != null) {
        widget.onSubmit!({
          'country': selectedCountry,
          'cardNumber': cardNumberController.text,
          'expiry': expiryController.text,
          'securityCode': securityCodeController.text,
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'amount': amountController.text,
          'saveInfo': saveInfo,
        });
      }

      // Navigate to VerificationCodeScreen (commented out as in original code)
      /*
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VerificationCodeScreen(),
        ),
      );
      */

    } catch (error) {
      // Handle errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit donation: $error'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    amountController.clear();
    cardNumberController.clear();
    expiryController.clear();
    securityCodeController.clear();
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    emailController.clear();
    setState(() {
      selectedCountry = 'Uganda';
      saveInfo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildAmountField(),
                const SizedBox(height: 15),
                _buildCountryDropdown(),
                const SizedBox(height: 15),
                _buildCardNumberField(),
                const SizedBox(height: 15),
                _buildCardDetailsRow(),
                const SizedBox(height: 15),
                _buildNameFields(),
                const SizedBox(height: 15),
                _buildContactFields(),
                const SizedBox(height: 15),
                _buildSaveInfoCheckbox(),
                const SizedBox(height: 15),
                _buildDonateButton(),
                const SizedBox(height: 15),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        const Column(
          children: [
            Text(
              'Donate to',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Real turn tennis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: amountController,
        decoration: const InputDecoration(
          hintText: 'Amount',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter donation amount';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid amount';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedCountry,
          hint: const Text('Select your country'),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          items: countries.map((String country) {
            return DropdownMenuItem<String>(
              value: country,
              child: Text(country),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedCountry = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildCardNumberField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: cardNumberController,
        decoration: const InputDecoration(
          hintText: 'Card number',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter card number';
          }
          if (value.length < 16) {
            return 'Please enter a valid card number';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCardDetailsRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: expiryController,
              decoration: const InputDecoration(
                hintText: 'MM/YY',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter expiry date';
                }
                return null;
              },
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: securityCodeController,
              decoration: const InputDecoration(
                hintText: 'CVV',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter CVV';
                }
                if (value.length < 3) {
                  return 'Invalid CVV';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameFields() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: firstNameController,
            decoration: const InputDecoration(
              hintText: 'First name',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter first name';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: lastNameController,
            decoration: const InputDecoration(
              hintText: 'Last name',
              border: OutlineInputBorder(),
              // contentPadding: ExtPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter last name';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContactFields() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(
              hintText: 'Phone number',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter phone number';
              }
              if (value.length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSaveInfoCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: saveInfo,
          onChanged: (value) {
            setState(() {
              saveInfo = value ?? false;
            });
          },
        ),
        const Text('Save this information for next time'),
      ],
    );
  }

  Widget _buildDonateButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _saveDonationToFirebase,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Donate now',
                  style: TextStyle(fontSize: 16),
                ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Text(
        '© Realturn tennis uganda',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}