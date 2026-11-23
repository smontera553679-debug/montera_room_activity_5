import 'package:flutter/material.dart';
import '../demo_auth.dart';
import 'post.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final commentController = TextEditingController();
  final List<Comment> comments = [];
  bool liked = false;
  int likeCount = 0;
  bool showComments = false;

  void toggleLike() {
    setState(() {
      liked = !liked;
      likeCount += liked ? 1 : -1;
    });
  }

  void addComment() {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      comments.add(
        Comment(
          username: DemoAuth.currentUsername ?? 'Guest',
          text: text,
        ),
      );
      showComments = true;
    });
    commentController.clear();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final initial =
        post.username.isEmpty ? '?' : post.username[0].toUpperCase();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
              child: Text(initial),
            ),
            title: Text(
              post.username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (post.imageUrl.isNotEmpty)
            AspectRatio(
              aspectRatio: 3 / 2,
              child: Image.network(
                post.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.pink.shade50,
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.broken_image, size: 48, color: Colors.pink),
                        SizedBox(height: 8),
                        Text('Image could not be loaded'),
                      ],
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(post.caption),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
            child: Row(
              children: [
                IconButton(
                  tooltip: liked ? 'Unlike' : 'Like',
                  onPressed: toggleLike,
                  icon: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? Colors.pink : null,
                  ),
                ),
                Text('$likeCount'),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: showComments ? 'Hide comments' : 'Show comments',
                  onPressed: () {
                    setState(() {
                      showComments = !showComments;
                    });
                  },
                  icon: Icon(
                    showComments
                        ? Icons.chat_bubble
                        : Icons.chat_bubble_outline,
                  ),
                ),
                Text('${comments.length}'),
              ],
            ),
          ),
          if (showComments) ...[
            const Divider(height: 1),
            for (final comment in comments)
              ListTile(
                dense: true,
                title: Text(
                  comment.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(comment.text),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => addComment(),
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Send comment',
                    onPressed: addComment,
                    icon: const Icon(Icons.send, color: Colors.pink),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}