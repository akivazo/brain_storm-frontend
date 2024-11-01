import 'package:brain_storm/data/data_manager.dart';
import 'package:brain_storm/data/data_models.dart';
import 'package:brain_storm/data/user_manager.dart';
import 'package:brain_storm/home_page/main_feed.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:provider/provider.dart';

class FeedbackCard extends StatelessWidget {
  final Feedback feedback;

  const FeedbackCard({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        child: ListTile(
          title: Text(feedback.content),
          subtitle: Text("Posted by ${feedback.ownerName}"),
        ),
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
    var futureFeedbacks = feedbacksManager.getIdeaFeedbacks(idea);
    return FutureBuilder<List<Feedback>>(
        future: futureFeedbacks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            List<Feedback> feedbacks = snapshot.data!;
            print(feedbacks);
            return Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: feedbacks.length,
                  // Replace with the number of ideas
                  itemBuilder: (context, index) {
                    return FeedbackCard(
                      feedback: feedbacks[index],
                    );
                  }),
            );
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          return Text("Somthing went wrong");
        });
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
            Provider.of<MainFeedPage>(context, listen: false).goToIdeasFeed();
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
    var user = Provider.of<UserManager>(context, listen: false).getUser();
    var feedbackManager = Provider.of<FeedbackManager>(context, listen: false);
    feedbackManager.addFeedback(user, idea, content);
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
