import 'package:brain_storm/data/data_manager.dart';
import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/user_manager.dart';
import 'package:brain_storm/home_page/main_feed/main_feed.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:provider/provider.dart';

class FeedbackCard extends StatelessWidget {
  final Feedback feedback;
  final Idea idea;

  const FeedbackCard({super.key, required this.idea, required this.feedback});

  @override
  Widget build(BuildContext context) {
    var userName = UserManager.getInstance(context).getUserName();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(feedback.content, style: Theme.of(context).textTheme.bodyLarge,),
              Row(
                children: [
                  Text("Posted by ${feedback.ownerName}", style: Theme.of(context).textTheme.bodySmall),
                  Spacer(),
                  Builder(builder: (context) {
                    if (feedback.ownerName == userName){
                      return ElevatedButton(onPressed: () {
                        FeedbackManager.getInstance(context).deleteFeedback(idea, feedback);
                      }, child: Text("Delete Feedback"));
                    }
                    return SizedBox.shrink();
                  })
                ],
              )
            ],
          ),
        )

      ),
    );
  }
}

class FeedbacksView extends StatelessWidget {
  final Idea idea;

  const FeedbacksView({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    var feedbacksManager = Provider.of<FeedbackManager>(context, listen: true);
    var feedbacks = feedbacksManager.getIdeaFeedbacks(idea);
    if (feedbacks.isEmpty){
      return Expanded(
        child: Column(
          children: [
            Divider(height: 40,),
            Text("No Feedbacks yet", style: TextStyle(),),
          ],
        ),
      );
    }
    return Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: feedbacks.length,
                  // Replace with the number of ideas
                  itemBuilder: (context, index) {
                    return FeedbackCard(
                      idea: idea,
                      feedback: feedbacks[index],
                    );
                  }),
            );
          }
  }


class ExpendedIdea extends StatelessWidget {
  final Idea idea;

  const ExpendedIdea({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(onPressed: () {
            Provider.of<MainFeedPage>(context, listen: false).restartIdeaFeed();
          }, icon: Icon(Icons.arrow_back)),
          SizedBox(height: 20,),
          Text(
            idea.subject,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 8.0),
          Text(
            'By: ${idea.owner_name}',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          SizedBox(height: 16.0),
          Text(
            idea.details,
            style: TextStyle(fontSize: 16),
          ),

          SizedBox(height: 20,),
          FeedbacksView(
            idea: idea,
          ),
          SizedBox(
            height: 10,
          ),
          SubmitFeedbackBox(idea: idea)
        ],
      ),
    );
  }
}

class SubmitFeedbackBox extends StatelessWidget {
  final _controller = TextEditingController();
  final Idea idea;

  SubmitFeedbackBox({super.key, required this.idea});

  void _submit(BuildContext context){
    var content = _controller.text;
    var userName = Provider.of<UserManager>(context, listen: false).getUserName();
    var feedbackManager = Provider.of<FeedbackManager>(context, listen: false);
    feedbackManager.addFeedback(userName, idea, content);
    _controller.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Enter your feedback',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10,),
        ElevatedButton(onPressed: () => {_submit(context)}, child: Text("Submit feedback")),
        SizedBox(height: 10,)
      ],
    );
  }
}
