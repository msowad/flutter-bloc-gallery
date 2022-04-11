import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageImage extends StatelessWidget {
  final Reference image;
  const StorageImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: image.getData(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return Image.memory(
                data,
                fit: BoxFit.cover,
              );
            }
            // ignore: todo
            // TODO: handle error -> snapshot.hasError
            return const Text('no images');
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
