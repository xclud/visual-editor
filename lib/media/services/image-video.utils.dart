import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/services/controller.dart';
import '../../documents/models/nodes/embeddable.dart';
import '../../shared/translations/toolbar.i18n.dart';
import '../../shared/utils/platform.utils.dart';
import '../../toolbar/models/media-pick.enum.dart';
import '../../toolbar/models/media-picker.type.dart';

class ImageVideoUtils {
  static Future<MediaPickSettingE?> selectMediaPickSetting(
    BuildContext context,
  ) =>
      showDialog<MediaPickSettingE>(
        context: context,
        builder: (ctx) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                icon: const Icon(
                  Icons.collections,
                  color: Colors.orangeAccent,
                ),
                label: Text('Gallery'.i18n),
                onPressed: () => Navigator.pop(ctx, MediaPickSettingE.Gallery),
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.link,
                  color: Colors.cyanAccent,
                ),
                label: Text('Link'.i18n),
                onPressed: () => Navigator.pop(ctx, MediaPickSettingE.Link),
              )
            ],
          ),
        ),
      );

  // For image picking logic
  static Future<void> handleImageButtonTap(
    BuildContext context,
    QuillController controller,
    ImageSource imageSource,
    OnImagePickCallback onImagePickCallback, {
    FilePickImpl? filePickImpl,
    WebImagePickImpl? webImagePickImpl,
  }) async {
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;

    String? imageUrl;
    if (kIsWeb) {
      assert(
          webImagePickImpl != null,
          'Please provide webImagePickImpl for Web '
          '(check out example directory for how to do it)');
      imageUrl = await webImagePickImpl!(onImagePickCallback);
    } else if (isMobile()) {
      imageUrl = await _pickImage(
        imageSource,
        onImagePickCallback,
      );
    } else {
      assert(filePickImpl != null, 'Desktop must provide filePickImpl');
      imageUrl = await _pickImageDesktop(
        context,
        filePickImpl!,
        onImagePickCallback,
      );
    }

    if (imageUrl != null) {
      controller.replaceText(index, length, BlockEmbed.image(imageUrl), null);
    }
  }

  // For video picking logic
  static Future<void> handleVideoButtonTap(
      BuildContext context,
      QuillController controller,
      ImageSource videoSource,
      OnVideoPickCallback onVideoPickCallback, {
        FilePickImpl? filePickImpl,
        WebVideoPickImpl? webVideoPickImpl,
      }) async {
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;

    String? videoUrl;
    if (kIsWeb) {
      assert(
      webVideoPickImpl != null,
      'Please provide webVideoPickImpl for Web '
          '(check out example directory for how to do it)');
      videoUrl = await webVideoPickImpl!(onVideoPickCallback);
    } else if (isMobile()) {
      videoUrl = await _pickVideo(videoSource, onVideoPickCallback);
    } else {
      assert(filePickImpl != null, 'Desktop must provide filePickImpl');
      videoUrl =
      await _pickVideoDesktop(context, filePickImpl!, onVideoPickCallback);
    }

    if (videoUrl != null) {
      controller.replaceText(index, length, BlockEmbed.video(videoUrl), null);
    }
  }

  // === PRIVATE ===

  static Future<String?> _pickImage(
    ImageSource source,
    OnImagePickCallback onImagePickCallback,
  ) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) {
      return null;
    }

    return onImagePickCallback(File(pickedFile.path));
  }

  static Future<String?> _pickImageDesktop(
    BuildContext context,
    FilePickImpl filePickImpl,
    OnImagePickCallback onImagePickCallback,
  ) async {
    final filePath = await filePickImpl(context);
    if (filePath == null || filePath.isEmpty) return null;

    final file = File(filePath);
    return onImagePickCallback(file);
  }

  static Future<String?> _pickVideo(
    ImageSource source,
    OnVideoPickCallback onVideoPickCallback,
  ) async {
    final pickedFile = await ImagePicker().pickVideo(source: source);
    if (pickedFile == null) {
      return null;
    }

    return onVideoPickCallback(File(pickedFile.path));
  }

  static Future<String?> _pickVideoDesktop(
    BuildContext context,
    FilePickImpl filePickImpl,
    OnVideoPickCallback onVideoPickCallback,
  ) async {
    final filePath = await filePickImpl(context);
    if (filePath == null || filePath.isEmpty) return null;

    final file = File(filePath);
    return onVideoPickCallback(file);
  }
}
