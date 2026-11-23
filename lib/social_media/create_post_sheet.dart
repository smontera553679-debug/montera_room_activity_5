import 'package:flutter/material.dart';
import 'post.dart';

class CreatePostSheet extends StatefulWidget {
  final String username;

  const CreatePostSheet({
    super.key,
    required this.username,
  });

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final formKey = GlobalKey<FormState>();
  final captionController = TextEditingController();
  final imageUrlController = TextEditingController();

  void submit() {
    if (!formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      Post(
        username: widget.username,
        caption: captionController.text.trim(),
        imageUrl: imageUrlController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    captionController.dispose();
    imageUrlController.dispose();
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
      child: SingleChildScrollView(
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
              const SizedBox(height: 16),
              TextFormField(
                controller: captionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Caption',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Write a caption.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: imageUrlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Image URL (optional)',
                  hintText: 'https://picsum.photos/600/400',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final url = value?.trim() ?? '';
                  if (url.isEmpty) return null;
                  final uri = Uri.tryParse(url);
                  final valid = uri != null &&
                      (uri.scheme == 'http' || uri.scheme == 'https') &&
                      uri.host.isNotEmpty;
                  return valid ? null : 'Enter a valid http(s) URL.';
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: submit,
                icon: const Icon(Icons.send),
                label: const Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}