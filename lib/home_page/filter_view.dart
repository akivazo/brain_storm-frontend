import 'package:brain_storm/data/data_manager.dart';
import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/user_manager.dart';
import 'package:brain_storm/home_page/ideas_feed.dart';
import 'package:brain_storm/home_page/main_feed.dart';
import 'package:brain_storm/home_page/new_idea.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TagsFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _tags = TagsManager.getInstance(context, listen: true).getTags();
    var mainFeedPage = MainFeedPage.getInstance(context);
    return FutureBuilder<Map<String, int>>(
      future: _tags,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          var tags = snapshot.data!.entries.toList();
          tags.sort((tag1, tag2) {
            return tag2.value - tag1.value;
          });
          return Expanded(
            child: ListView.builder(
                itemCount: tags.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(onPressed: (){
                            mainFeedPage.setPage(IdeasFeed());
                          }, child: Text("Show all ideas")),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Icon(Icons.tag),
                            Text("Tags", style: Theme.of(context).textTheme.headlineSmall,),
                          ],
                        )
                      ],
                    );
                  }
                  index -= 1;
                  var name = tags[index].key;
                  var count = tags[index].value;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        mainFeedPage.setPage(IdeasFeed(tags: [name]));
                      },
                      child: Column(
                        children: [
                          Text(name),
                          Text("uses count: ${count}")
                        ],
                      ),
                    ),
                  );
                }),
          );
        }
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        return Text("Somthing went wrong");
      },
    );
  }

}

class FilterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TagsFilter();
  }

}