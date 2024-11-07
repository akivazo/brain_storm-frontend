import 'package:brain_storm/data/data_manager.dart';
import 'package:brain_storm/home_page/ideas_feed.dart';
import 'package:brain_storm/home_page/main_feed.dart';
import 'package:flutter/material.dart';

class TagsFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mainFeedPage = MainFeedPage.getInstance(context);

    var tags = TagsManager.getInstance(context, listen: true).getTags().entries.toList();
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
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      Icon(Icons.tag),
                      SizedBox(width: 10,),
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


}