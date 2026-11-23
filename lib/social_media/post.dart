class Comment {
  final String username;
  final String text;

  const Comment({
    required this.username,
    required this.text,
  });
}

class Post {
  final String username;
  final String caption;
  final String imageUrl;

  const Post({
    required this.username,
    required this.caption,
    this.imageUrl = '',
  });
}