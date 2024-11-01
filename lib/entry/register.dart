import 'package:brain_storm/data/data_manager.dart';
import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/user_manager.dart';
import 'package:brain_storm/entry/tags_picker.dart';
import 'package:brain_storm/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _validatePasswordController = TextEditingController();
  var generalErrorText = "";

  void _register(BuildContext context) async {
    var userManager = Provider.of<UserManager>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      var name = _nameController.text;
      if (await userManager.isUsernameUsed(name)){
        setState(() {
          generalErrorText = "Username '${name}' already exist";
        });
      } else {
        var password = _passwordController.text;
        var email = _emailController.text;
        var tags = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => TagsPicker()));
        try {
          userManager.registerUser(name, password, email, (tags as List<Tag>));
        } catch (e, stacktrace) {
          setState(() {
            generalErrorText = "Error: ${e} $stacktrace";
          });
          return;
        }

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage()));
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 500, maxHeight: 500),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text("Create a user"),
                  NameField(controller: _nameController),
                  PasswordField(controller: _passwordController),
                  ConfirmPasswordField(controller: _validatePasswordController, origController: _passwordController),
                  EmailField(controller: _emailController),
                  SizedBox(
                    height: 20, child: Center(child: Text(generalErrorText, style: TextStyle(color: Colors.red),),),),
                  ElevatedButton(onPressed: () {
                    _register(context);
                  }, child: Text("Register"))
                ],
              )
          ),
        ),
      ),
    );
  }
}

class NameField extends StatelessWidget {
  final TextEditingController controller;

  const NameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "User Name",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Name can't be empty";
        }
        return null;
      },
    );
  }

}


class PasswordField extends StatefulWidget {
  final TextEditingController controller;


  const PasswordField({super.key, required this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  var _obscureText = true;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
          labelText: "Password",
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off))
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Name can't be empty";
        }
        if (value.length < 6){
          return "Password must contains at least 6 characters";
        }
        return null;
      },
    );
  }
}

class ConfirmPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController origController;

  const ConfirmPasswordField({super.key, required this.controller, required this.origController});

  @override
  State<ConfirmPasswordField> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPasswordField> {
  var _obscureText = true;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
          labelText: "Repeat Password",
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off))
      ),
      validator: (value) {
        if (widget.controller.text != widget.origController.text){
          return "Passwords don't match";
        }
        return null;
      },
    );
  }
}

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Email",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email.';
        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address.';
        }
        return null;
      },
    );
  }

}