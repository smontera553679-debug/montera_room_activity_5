class Comment {
  final String username;
  final String text;

  Comment({required this.username, required this.text});
}

class Post {
  final String username;
  final String content;
  final DateTime createdAt;
  int likes;
  bool isLiked;
  final List<Comment> comments;

  Post({
    required this.username,
    required this.content,
    DateTime? createdAt,
    this.likes = 0,
    this.isLiked = false,
    List<Comment>? comments,
  })  : createdAt = createdAt ?? DateTime.now(),
        comments = comments ?? [];
}