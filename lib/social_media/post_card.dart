import 'package:flutter/material.dart';
import '../demo_auth.dart';
import 'post.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final commentController = TextEditingController();
  bool showComments = false;

  void toggleLike() {
    setState(() {
      final post = widget.post;
      post.isLiked = !post.isLiked;
      post.likes += post.isLiked ? 1 : -1;
    });
  }

  void addComment() {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      widget.post.comments.add(
        Comment(
          username: DemoAuth.currentUsername ?? 'unknown',
          text: text,
        ),
      );
      commentController.clear();
      showComments = true;
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.pink,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text(
                  post.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.content),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: toggleLike,
                  icon: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: post.isLiked ? Colors.pink : null,
                  ),
                ),
                Text('${post.likes}'),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      showComments = !showComments;
                    });
                  },
                  icon: const Icon(Icons.comment_outlined),
                  label: Text('${post.comments.length}'),
                ),
              ],
            ),
            if (showComments) ...[
              const Divider(),
              for (final comment in post.comments)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('${comment.username}: ${comment.text}'),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                      ),
                      onSubmitted: (_) => addComment(),
                    ),
                  ),
                  IconButton(
                    onPressed: addComment,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}