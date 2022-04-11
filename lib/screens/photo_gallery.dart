import 'package:bloc_firebase_photo_gallery/bloc/bloc.dart';
import 'package:bloc_firebase_photo_gallery/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGallery extends HookWidget {
  const PhotoGallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.read<AppBloc>().state.images ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          IconButton(
            onPressed: () async {
              final image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image == null) return;
              context
                  .read<AppBloc>()
                  .add(AppEventUploadImage(filePath: image.path));
            },
            icon: const Icon(Icons.upload),
          ),
          const MainPopupMenuButton(),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children: images.map((image) => StorageImage(image: image)).toList(),
      ),
    );
  }
}
