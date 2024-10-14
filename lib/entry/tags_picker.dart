
import 'package:flutter/material.dart';

import '../data/data_models.dart';
import '../data/data_fetcher.dart';


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
    var dataFetcher = DataFetcher();
    futureTags = dataFetcher.fetchTags();
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
          } else {
            return Center(child: Card(child: Text("Loading..."),));
          }

        });
  }
}