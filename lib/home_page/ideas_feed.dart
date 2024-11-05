import 'package:brain_storm/data/data_manager.dart';
import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/user_manager.dart';
import 'package:brain_storm/home_page/expended_idea.dart';
import 'package:brain_storm/home_page/main_feed.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:provider/provider.dart';

enum IdeasSortingMethod {
  TIMESTAMP,
  FAVORITES,
}
class IdeasFeed extends StatelessWidget {

  final List<String>? tags;
  final IdeasSortingMethod sortingMethod;

  const IdeasFeed({super.key, this.tags, this.sortingMethod = IdeasSortingMethod.TIMESTAMP});

  @override
  Widget build(BuildContext context) {

    final IdeasManager ideasManager = Provider.of<IdeasManager>(context, listen: true);
    // use list for order
    var futureIdeas = ideasManager.getIdeas(tags ?? []).then((ideas) {
      var _ideas = ideas.toList();
      _ideas.sort((a, b) {return a.timestamp.compareTo(b.timestamp);});


      return ideas.toList();
    });
    return FutureBuilder<List<Idea>>(
        future: futureIdeas,
        builder: (BuildContext context, AsyncSnapshot<List<Idea>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            var ideas = snapshot.data!;
            if (ideas.isEmpty){
              return Center(child: Text("No ideas to present"));
            }
            return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: ideas.length + 1, // Replace with the number of ideas
                itemBuilder: (context, index) {
                  if (index == 0){
                    if (tags != null){
                      return Text("Tags: ${tags!.join(", ")}", style: Theme.of(context).textTheme.labelMedium,);
                    }
                    return SizedBox.shrink();

                  }
                  index -= 1;
                  return IdeaCard(
                    idea: ideas[index],
                  );
                });
          } else if (snapshot.hasError) {
            throw Text('Error building ideas: ${snapshot.error}');
          }
          return Text("Somthing went wrong");
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
            Text(widget.idea.details, style: Theme.of(context).textTheme.bodyLarge),
            Divider(height: 20, endIndent: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("tags: ${widget.idea.tags.join(", ")}"),
                    SizedBox(height: 5,),
                    Text('Posted by: ${widget.idea.owner_name}', style: Theme.of(context).textTheme.bodySmall,),
                  ],
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<MainFeedPage>(context, listen: false).goToIdeaFeed(widget.idea);
                  },
                  child: Text('Feedbacks'),
                ),
                FavoriteIcon(idea: widget.idea,),
                Builder(builder: (context) {
                  var userName = Provider.of<UserManager>(context, listen: false).getUser().name;
                  if (widget.idea.owner_name == userName){
                    return ElevatedButton(onPressed: () {
                      Provider.of<IdeasManager>(context, listen: false).removeIdea(widget.idea, context);
                    }, child: Text("Delete Idea"),);
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

class _FavoriteIconState extends State<FavoriteIcon> {
  var _liked = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: (){
      var userManager = UserManager.getInstance(context);
      var favoriteManager = FavoriteManager.getInstance(context);
      if (_liked){
        favoriteManager.addFavorite(userManager.getUser(), widget.idea);
      } else {
        favoriteManager.removeFavorite(userManager.getUser(), widget.idea);
      }
      setState(() {
        _liked = !_liked;
      });



    }, icon: Icon(_liked ?  Icons.favorite : Icons.favorite_border ));
  }
}