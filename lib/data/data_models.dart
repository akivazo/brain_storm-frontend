

class Idea {
  final String id;
  final String owner_name;
  final String subject;
  final String details;
  final List<Tag> tags;

  Idea({
    required this.id,
    required this.owner_name,
    required this.subject,
    required this.details,
    this.tags = const [],
  });

}

class Feedback {
  final String id;
  final String ideaId;
  final String ownerId;
  final String content;

  Feedback({
    required this.id,
    required this.ideaId,
    required this.ownerId,
    required this.content,
  });

}

class User {
  final String name;
  final String password;
  final String email;
  final List<Tag> tags;

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
