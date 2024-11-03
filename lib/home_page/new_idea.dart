import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/data_manager.dart';
import 'package:brain_storm/data/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SubjectField extends StatelessWidget {
  final TextEditingController controller;

  const SubjectField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: 'Subject'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter idea subject';
        }
        return null;
      },
    );
  }
}

class DetailsField extends StatelessWidget {
  final TextEditingController controller;

  const DetailsField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: 'Details'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter what the idea is about';
        }
        return null;
      },
    );
  }
}

class TagsField extends StatelessWidget {
  final TextEditingController controller;

  const TagsField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: 'Tags (comma-separated, e.g., tag1, tag2)'),

    );
  }
}


class NewIdeaForm extends StatefulWidget {
  @override
  _NewIdeaFormState createState() => _NewIdeaFormState();
}

class _NewIdeaFormState extends State<NewIdeaForm> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _detailsController = TextEditingController();
  final _tagsController = TextEditingController();

  void _create(){
    var ideaManager = IdeasManager.getInstance(context);
    var userManager = UserManager.getInstance(context);
    if (_formKey.currentState!.validate()) {
      // Process the form data
      final name = userManager.getUser().name;
      final subject = _subjectController.text;
      final details = _detailsController.text;
      final tags = _tagsController.text.split(',')
          .map((tag) => tag.trim())
          .toList();

      ideaManager.createIdea(name, subject, details, tags, context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 500,
            maxWidth: 500
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("New idea"),
                SubjectField(controller: _subjectController),
                DetailsField(controller: _detailsController),
                TagsField(controller: _tagsController),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _create();
                    },
                    child: Text('Create'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class NewIdeaButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewIdeaForm()),
          );
        },
        child: Text('New Idea'),
      ),
    );
  }

}