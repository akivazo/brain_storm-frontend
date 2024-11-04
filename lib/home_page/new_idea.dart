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

class TagsField extends StatefulWidget {

  final Set<String> chosenTags;
  const TagsField({super.key, required this.chosenTags});

  @override
  State<TagsField> createState() => _TagsFieldState();
}

class _TagsFieldState extends State<TagsField> {
  late TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<String> filteredSuggestions = [];
  late Set<String> chosenTags;

  @override
  void initState() {
    super.initState();
    chosenTags = widget.chosenTags;
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);

  }


  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _overlayEntry?.remove(); // Ensure overlay is removed on dispose
    super.dispose();
  }

  Future<List<String>> getTagsSuggestion(String text) async {
    var tagsManager = TagsManager.getInstance(context);
    return tagsManager.getSortedTags().then((tags) {
      return tags
          .where((tag) => tag.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  void _onTextChanged() async {
    final text = _controller.text;
    if (text.isNotEmpty) {
      filteredSuggestions = await getTagsSuggestion(text);
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  void _onFocusChanged() {
    if (_controller.text.isNotEmpty && !_focusNode.hasFocus) {
     //_hideOverlay();
    }
  }

  void _showOverlay() {
    // Remove any existing overlay before creating a new one
    _overlayEntry?.remove();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    // Remove overlay if it exists
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 400,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, 56),
          child: Material(
            elevation: 4.0,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: filteredSuggestions.map((suggestion) {
                return ListTile(
                  title: Text(suggestion),
                  onTap: () {
                    setState(() {
                      print(chosenTags);
                      chosenTags.add(suggestion);
                    });
                    _controller.clear();
                    _focusNode.unfocus();
                    _hideOverlay();
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _addCustomTag(){
    setState(() {
      chosenTags.add(_controller.text.trim());
      _controller.clear();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              labelText: 'Find tag',
              suffixIcon: TextButton(onPressed: (){
                _addCustomTag();
              }, child: Text("add"))
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
              builder: (context) {
                if (chosenTags.isEmpty){
                  return Text("No tags chosen yet");
                }
                return Text("Tags: ${chosenTags.join(", ")}");
              }
          ),
        ),
      ],
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
  final _chosenTags = Set<String>();

  void _create(){
    var ideaManager = IdeasManager.getInstance(context);
    var userManager = UserManager.getInstance(context);
    if (_formKey.currentState!.validate()) {
      // Process the form data
      final name = userManager.getUser().name;
      final subject = _subjectController.text;
      final details = _detailsController.text;
      final tags = _chosenTags.toList();

      ideaManager.createIdea(name, subject, details, tags, context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(onPressed: () {
                Navigator.of(context).pop();
              }, icon: Icon(Icons.arrow_back)),
            ),
          ),
          SizedBox(height: 300,),
          Container(
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
                  TagsField(chosenTags: _chosenTags,),
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
        ],
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