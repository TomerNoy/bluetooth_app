import 'package:flutter/material.dart';
import 'package:neurotask/api/account_api.dart';
import 'package:neurotask/theme.dart';
import 'bluetooth.dart';

/// stateless wrapper
class Registration extends StatelessWidget {
  const Registration({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primary,
      child: const SafeArea(child: RegistrationPage()),
    );
  }
}

/// stateful page content for handling the form
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  /// form validators
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'required field';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'required field';
    const pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    final regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) return null;
    return 'invalid email';
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'required field';
    if (value.length < 8) return 'must be at least 8 char long';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'required field';
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) return null;
    return 'invalid phone number';
  }

  String? _validateConditions(bool? value) {
    if (value == false || value == null) return 'required field';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () => _formKey.currentState?.reset(),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                validator: _validateName,
                controller: _firstNameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_circle),
                  labelText: "First Name",
                ),
              ),
              TextFormField(
                validator: _validateName,
                controller: _lastNameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_circle),
                  labelText: "Last Name",
                ),
              ),
              TextFormField(
                validator: _validateEmail,
                controller: _mailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: "Email ",
                ),
              ),
              TextFormField(
                validator: _validatePassword,
                controller: _passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  labelText: "Password",
                ),
              ),
              TextFormField(
                validator: _validatePhone,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mobile_screen_share),
                  labelText: "Phone",
                ),
              ),
              CheckboxFormField(
                title: const Text('I accept the terms and conditions'),
                validator: _validateConditions,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Directionality(
        textDirection: TextDirection.rtl,
        child: FloatingActionButton.extended(
          onPressed: _handleRegister,
          icon: const Icon(Icons.arrow_back_ios),
          label: const Text('Send'),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    // for testing
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) {
    //       return const Bluetooth(title: 'Bluetooth Devices');
    //     },
    //   ),
    // );
    if (_formKey.currentState!.validate()) {
      _buildShowDialog(context);
      final account = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _mailController.text,
        'password': _passwordController.text,
        'phoneNumber': _phoneController.text,
      };

      final Map<String, dynamic> res = await register(account);

      if (res['code'] >= 200 && res['code'] < 300) {
        /// if register success move to bluetooth page
        // Account newAccount = Account.fromJson(account); // todo: account manage
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Bluetooth(title: 'Bluetooth Devices');
            },
          ),
        );
      } else {
        /// if register failed show showSnackBar with relevant err msg
        final String msg = res['description'] ?? 'something went wrong :(';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    }
  }

  Future<dynamic> _buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

/// modified FormField for checkbox so we could use proper form validation
class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    Key? key,
    Widget? title,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    bool initialValue = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<bool> state) {
            return CheckboxListTile(
              contentPadding: const EdgeInsets.all(5),
              dense: state.hasError,
              title: title,
              value: state.value,
              onChanged: state.didChange,
              subtitle: state.hasError
                  ? Builder(
                      builder: (BuildContext context) => Text(
                        state.errorText ?? '',
                        style: TextStyle(color: Theme.of(context).errorColor),
                      ),
                    )
                  : null,
              controlAffinity: ListTileControlAffinity.leading,
            );
          },
        );
}
