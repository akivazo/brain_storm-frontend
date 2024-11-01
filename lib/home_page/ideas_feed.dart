import 'package:brain_storm/data/data_manager.dart';
import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/user_manager.dart';
import 'package:brain_storm/home_page/expended_idea.dart';
import 'package:brain_storm/home_page/main_feed.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:provider/provider.dart';

class IdeasFeed extends StatelessWidget {

  final List<Tag>? tags;

  const IdeasFeed({super.key, this.tags});

  @override
  Widget build(BuildContext context) {
    List<Tag>? _tags;
    if (tags == null){
      final UserManager userManager = Provider.of<UserManager>(context, listen: true);
      _tags = userManager.user!.tags;
    } else {
      _tags = tags!;
    }
    final IdeasManager ideasManager =
    Provider.of<IdeasManager>(context, listen: true);
    // use list for order
    var futureIdeas = ideasManager.getIdeas(_tags).then((ideas) { return ideas.toList();});
    return FutureBuilder<List<Idea>>(
        future: futureIdeas,
        builder: (BuildContext context, AsyncSnapshot<List<Idea>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            var ideas = snapshot.data!;
            return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: ideas.length, // Replace with the number of ideas
                itemBuilder: (context, index) {
                  return IdeaCard(
                    idea: ideas[index],
                  );
                });
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
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
  final _controller = TextEditingController();




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
            Text(widget.idea.details),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Posted by ${widget.idea.owner_name}'),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<MainFeedPage>(context, listen: false).goToIdeaFeed(widget.idea);
                  },
                  child: Text('Expend idea'),
                ),
                Builder(builder: (context) {
                  var userName = Provider.of<UserManager>(context, listen: false).getUser().name;
                  if (widget.idea.owner_name == userName){
                    return ElevatedButton(onPressed: () {
                      Provider.of<IdeasManager>(context, listen: false).removeIdea(widget.idea);
                    }, child: Text("Delete Idea"));
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