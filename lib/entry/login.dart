import 'package:flutter/material.dart';
import '../data/data_models.dart';
import '../data/data_fetcher.dart';
import '../data/local_data_manager.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  var dataFetcher = DataFetcher();
  var localDataManager = LocalUserManager();
  var generalErrorText = "";

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      User? user;
      try {
        user = await dataFetcher.fetchUser(_nameController.text, _passwordController.text);
      } on Exception catch (e, stacktrace){
        setState(() {
          generalErrorText = "${e}. ${stacktrace}.";
          return;
        });
      }
      if (user == null){
        setState(() {
          generalErrorText = "Either Username or the passwords were incorrect";
        });
      } else {
        if (mounted){
          Navigator.of(context).pop(user);
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: 500
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Text("Login"),),
                NameField(textController: _nameController,),
                PasswordField(textController: _passwordController),
                SizedBox(height: 20, child: Text(generalErrorText, style: TextStyle(color: Colors.red),),),
                ElevatedButton(
                  onPressed: () {_login(context);},
                  child: Text("Login")
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class NameField extends StatelessWidget {
  final TextEditingController textController;

  const NameField({super.key, required this.textController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      decoration: InputDecoration(labelText: "User Name"),
      validator: (value) {
        if (value == null || value.isEmpty){
          return "User name can't be empty";
        }
        return null;
      },
    );
  }

}

class PasswordField extends StatefulWidget {
  final TextEditingController textController;

  const PasswordField({super.key, required this.textController});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isPasswordObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      obscureText: _isPasswordObscured,
      decoration: InputDecoration(
          labelText: "Password",
          suffixIcon: IconButton(
              onPressed: _togglePasswordVisibility,
              icon: Icon(_isPasswordObscured ? Icons.visibility : Icons.visibility_off)
          )
      ),
      validator: (value) {
        if (value == null || value.isEmpty){
          return "Password can't be empty";
        }
        return null;
      },

    );
  }
}