import 'package:brain_storm/data/data_manager.dart';
import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/user_manager.dart';
import 'package:brain_storm/home_page/main_feed/main_feed.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class IdeaMainDetailsView extends StatelessWidget {
  final Idea idea;
  const IdeaMainDetailsView({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    String details = idea.details;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          idea.subject,
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
                    MainFeedPage.getInstance(context, listen: false).showIdeaPage(idea);
                  },
                  child: Text("See more.."))
            ]);
          }
          return Text(details,
              style: Theme.of(context).textTheme.bodyLarge);
        }),
      ],
    );
  }
}

class IdeaSubDetailsView extends StatelessWidget {
  final Idea idea;
  const IdeaSubDetailsView({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(idea.timestamp * 1000, isUtc: true);
    DateTime localDateTime = dateTime.toLocal();
    String formattedDate = DateFormat.yMMMd().add_jm().format(localDateTime);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("tags: ${idea.tags.join(", ")}"),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Posted by: ${idea.owner_name}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(
          height: 5,
        ),
        Text("Created: $formattedDate", style: Theme.of(context).textTheme.bodySmall)
      ],
    );
  }
}

class IdeaButtons extends StatelessWidget {
  final Idea idea;
  const IdeaButtons({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Provider.of<MainFeedPage>(context, listen: false)
                    .showIdeaPage(idea);
              },
              child: Builder(
                  builder: (context) {
                    var feedbacksManager = FeedbackManager.getInstance(context);
                    var feedbacksCount = feedbacksManager.getIdeaFeedbacks(idea).length;
                    return Text("$feedbacksCount Feedbacks ");
                  }
              ),
            ),

          ],
        ),
        FavoriteIcon(
          idea: idea,
        ),
        Builder(builder: (context) {
          var userName = UserManager.getInstance(context).getUserName();
          if (idea.owner_name == userName) {
            return ElevatedButton(
              onPressed: () {
                IdeasManager.getInstance(context)
                    .removeIdea(idea, context);
              },
              child: Text("Delete Idea"),
            );
          }
          return SizedBox.shrink();
        })
      ],
    );
  }
}

class VerticalIdeaCard extends StatelessWidget {
  final Idea idea;
  const VerticalIdeaCard({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IdeaMainDetailsView(idea: idea),
            Divider(
              height: 20,
              endIndent: 40,
            ),
            IdeaSubDetailsView(idea: idea),
            Divider(
              height: 20,
              endIndent: 40,
            ),
            IdeaButtons(idea: idea)
          ],
        ),
      ),
    );
  }
}

class HorizontalIdeaCard extends StatelessWidget {
  final Idea idea;

  const HorizontalIdeaCard({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IdeaMainDetailsView(idea: idea),
            Divider(
              height: 20,
              endIndent: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IdeaSubDetailsView(idea: idea),
                Spacer(),
                IdeaButtons(idea: idea)
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