import 'package:flutter/material.dart';
import 'post.dart';

class CreatePostSheet extends StatefulWidget {
  final String username;

  const CreatePostSheet({super.key, required this.username});

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final formKey = GlobalKey<FormState>();
  final contentController = TextEditingController();

  void submit() {
    if (!formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      Post(
        username: widget.username,
        content: contentController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create Post',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text('Posting as ${widget.username}'),
            const SizedBox(height: 16),
            TextFormField(
              controller: contentController,
              maxLines: 4,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Write something to post.'
                  : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: submit,
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}