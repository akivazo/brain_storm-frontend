import 'package:brain_storm/data/data_manager.dart';
import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/user_manager.dart';
import 'package:brain_storm/home_page/main_feed/expended_idea.dart';
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
          return IdeaCard(
            idea: ideas[index],
          );
        });
  }
}

class IdeaCard extends StatefulWidget {
  final Idea idea;

  const IdeaCard({super.key, required this.idea});

  @override
  State<IdeaCard> createState() => _IdeaCardState();
}

class _IdeaCardState extends State<IdeaCard> {
  @override
  Widget build(BuildContext context) {
    String details = widget.idea.details;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(widget.idea.timestamp * 1000, isUtc: true);
    DateTime localDateTime = dateTime.toLocal();
    String formattedDate = DateFormat.yMMMd().add_jm().format(localDateTime);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.idea.subject,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Builder(builder: (context) {
              if (details.length > 30) {
                return Row(children: [
                  Text(details.length > 30 ? details.substring(0, 30) : details,
                      style: Theme.of(context).textTheme.bodyLarge),
                  TextButton(
                      onPressed: () {
                        MainFeedPage.getInstance(context, listen: false).showIdeaPage(widget.idea);
                      },
                      child: Text("See more.."))
                ]);
              }
              return Text(details,
                  style: Theme.of(context).textTheme.bodyLarge);
            }),
            Divider(
              height: 20,
              endIndent: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("tags: ${widget.idea.tags.join(", ")}"),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Posted by: ${widget.idea.owner_name}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Created: $formattedDate", style: Theme.of(context).textTheme.bodySmall)
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<MainFeedPage>(context, listen: false)
                            .showIdeaPage(widget.idea);
                      },
                      child: Builder(
                        builder: (context) {
                          var feedbacksManager = FeedbackManager.getInstance(context);
                          var feedbacksCount = feedbacksManager.getIdeaFeedbacks(widget.idea).length;
                          return Text("$feedbacksCount Feedbacks ");
                        }
                      ),
                    ),

                  ],
                ),
                FavoriteIcon(
                  idea: widget.idea,
                ),
                Builder(builder: (context) {
                  var userName = UserManager.getInstance(context).getUserName();
                  if (widget.idea.owner_name == userName) {
                    return ElevatedButton(
                      onPressed: () {
                        IdeasManager.getInstance(context)
                            .removeIdea(widget.idea, context);
                      },
                      child: Text("Delete Idea"),
                    );
                  }
                  return SizedBox.shrink();
                })
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteIcon extends StatefulWidget {
  final Idea idea;

  const FavoriteIcon({super.key, required this.idea});

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class FavoriteData {
  final bool isUserLiked;
  final Idea idea;

  FavoriteData({required this.isUserLiked, required this.idea});
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    var userManager = UserManager.getInstance(context);
    var liked = userManager.isIdeaInUserFavorites(widget.idea);
    var ideaManager = IdeasManager.getInstance(context);
    var idea = ideaManager.getIdea(widget.idea.id);
    return Column(
      children: [
        IconButton(
            onPressed: () {
              var favoriteManager = FavoriteManager.getInstance(context);
              if (liked) {
                // user dislike
                favoriteManager.removeFavorite(widget.idea, context);
              } else {
                // user liked
                favoriteManager.addFavorite(widget.idea, context);
              }
              setState(() {});
            },
            icon: Icon(liked ? Icons.favorite : Icons.favorite_border)),
        Text(idea.favorites.toString())
      ],
    );
  }
}
