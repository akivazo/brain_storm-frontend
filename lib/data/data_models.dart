

class Idea {
  final String id;
  final String owner_name;
  final String subject;
  final String details;
  final List<String> tags;
  final int timestamp;
  final int favorites;

  Idea({
    required this.id,
    required this.owner_name,
    required this.subject,
    required this.details,
    required this.timestamp,
    required this.favorites,
    this.tags = const [],
  });



}

class Feedback {
  final String id;
  final String ownerName;
  final String content;

  Feedback({
    required this.id,
    required this.ownerName,
    required this.content,
  });



}

class User {
  final String name;
  final String password;
  final String email;
  final Set<String> favoritesIdea;

  User({
    required this.name,
    required this.password,
    required this.email,
    required this.favoritesIdea
  });

}

class Tag {
  final String name;
  final int count;

  Tag({required this.name, required this.count});
}
