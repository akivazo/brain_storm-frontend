import 'package:brain_storm/data/data_manager.dart';
import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/user_manager.dart';
import 'package:brain_storm/home_page/main_feed/expended_idea.dart';
import 'package:brain_storm/home_page/main_feed/idea_card.dart';
import 'package:brain_storm/home_page/main_feed/main_feed.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class IdeasFeed extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final IdeasManager ideasManager =
        IdeasManager.getInstance(context, listen: true);
    final mainFeedPage = MainFeedPage.getInstance(context, listen: true);
    var tags = mainFeedPage.tags;
    // use list for order
    var ideas = ideasManager.getIdeas(tags).toList();
    if (mainFeedPage.userIdeas) {
      var userName = UserManager.getInstance(context).getUserName();
      ideas = ideas.where((idea) {
        return idea.owner_name == userName;
      }).toList();
    }
    if (mainFeedPage.sortingMethod == IdeasSortingMethod.TIMESTAMP) {
      ideas.sort((a, b) {
        return a.timestamp.compareTo(b.timestamp);
      });
    } else if (mainFeedPage.sortingMethod == IdeasSortingMethod.TIMESTAMP_REVERSE) {
      ideas.sort((a, b) {
        return b.timestamp.compareTo(a.timestamp);
      });
    } else if (mainFeedPage.sortingMethod == IdeasSortingMethod.FAVORITES) {
      ideas.sort((a, b) {
        return b.favorites.compareTo(a.favorites);
      });
    }
    if (ideas.isEmpty) {
      return Center(child: Text("No ideas to present"));
    }
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: ideas.length + 1, // Replace with the number of ideas
        itemBuilder: (context, index) {
          if (index == 0) {
            if (tags.isNotEmpty) {
              return Text(
                "Tags: ${tags.join(", ")}",
                style: Theme.of(context).textTheme.labelMedium,
              );
            }
            return SizedBox.shrink();
          }
          index -= 1;
          if (MediaQuery.of(context).size.width > 1000){
            return HorizontalIdeaCard(
              idea: ideas[index],
            );
          }
          return VerticalIdeaCard(
              idea: ideas[index]
          );

        });
  }
}


