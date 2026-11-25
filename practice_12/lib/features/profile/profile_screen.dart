import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../settings/settings_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _pick(BuildContext context, ImageSource source) async {
    final settings = context.read<SettingsModel>();
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked == null) return;
    final dir = await getApplicationDocumentsDirectory();
    final saved = await File(picked.path).copy('${dir.path}/avatar.jpg');
    await FileImage(saved).evict();
    await settings.setAvatarPath(saved.path);
  }

  Future<void> _takePhoto(BuildContext context) async {
    final status = await Permission.camera.request();
    if (!context.mounted) return;

    if (status.isGranted || status.isLimited) {
      await _pick(context, ImageSource.camera);
    } else if (status.isPermanentlyDenied) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Camera is blocked'),
          content: const Text(
            'Allow camera access in Settings to take a photo.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await openAppSettings();
              },
              child: const Text('Open settings'),
            ),
          ],
        ),
      );
    } else if (status.isRestricted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera is restricted on this device.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera permission is needed to take a photo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = context.watch<SettingsModel>().avatarPath;
    final file = path == null ? null : File(path);
    final hasPhoto = file != null && file.existsSync();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 56,
              backgroundImage: hasPhoto ? FileImage(file) : null,
              child: hasPhoto
                  ? null
                  : const Text('U', style: TextStyle(fontSize: 32)),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => _pick(context, ImageSource.gallery),
              child: const Text('Choose photo'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _takePhoto(context),
              child: const Text('Take photo'),
            ),
          ],
        ),
      ),
    );
  }
}
