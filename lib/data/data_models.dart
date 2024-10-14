

class Idea {
  String id;
  String owner_name;
  String subject;
  String details;
  List<Tag> tags;

  Idea({
    required this.id,
    required this.owner_name,
    required this.subject,
    required this.details,
    this.tags = const [],
  });

}

class Feedback {
  String id;
  String ideaId;
  String ownerId;
  String content;

  Feedback({
    required this.id,
    required this.ideaId,
    required this.ownerId,
    required this.content,
  });

}

class User {
  String name;
  String password;
  String email;
  List<Tag> tags;

  User({
    required this.name,
    required this.password,
    required this.email,
    this.tags = const [],
  });

}

class Tag {
  final String name;

  Tag({required this.name});
}