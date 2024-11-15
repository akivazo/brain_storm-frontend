
import 'package:brain_storm/data/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/data_models.dart';

/*
class TagsPicker extends StatefulWidget {
  @override
  _TagsPickerState createState() => _TagsPickerState();
}

class _TagsPickerState extends State<TagsPicker> {
  // List of items
  late Future<List<Tag>> futureTags;
  Set<int> selectedTags = {};

  @override
  void initState() {
    super.initState();
    var tagsManager = Provider.of<TagsManager>(context, listen: false);
    futureTags = tagsManager.getTags();
  }

  void _submit(List<Tag> tags, Set<int> selectedTags){
    Set<Tag> selected = {};
    for (var ind in selectedTags){
      selected.add(tags[ind]);
    }
    Navigator.of(context).pop(selected.toList());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: futureTags,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          if (snapshot.hasData) {
            var tags  = snapshot.data! as List<Tag>;
            return Scaffold(
              body: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 500,
                    maxHeight: 800
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 200,),
                      Text("Choose the subjects that you like lo see ideas about", style: TextStyle(fontSize: 20),),
                      SizedBox(height: 100,),
                      Expanded(
                        child: ListView.builder(
                          itemCount: tags.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              title: Text(tags[index].name),
                              value: selectedTags.contains(index),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value ?? false){
                                    selectedTags.add(index);
                                  } else {
                                    selectedTags.remove(index);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {_submit(tags, selectedTags);},
                          child: Text('Continue'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Text("Somthing went wrong");

        });
  }
}*/