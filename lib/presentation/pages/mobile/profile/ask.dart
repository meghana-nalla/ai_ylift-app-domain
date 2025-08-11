import 'dart:js_interop';

import 'package:YLift/core/constants/index.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:web/web.dart' as web;

import 'package:YLift/core/controllers/global.dart';

import 'package:YLift/presentation/components/z-index_export.dart';


class StreamProfilePage extends StatefulWidget {
  @override
  _StreamProfilePageState createState() => _StreamProfilePageState();
}

class _StreamProfilePageState extends State<StreamProfilePage> {
  bool showUserModal = false;
  Map<String, String> newUser = {};
  Map<String, String> errors = {};
  String status = "not_accepted";
  bool statusUnchecked = false;
  String? imgPath;
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            AccountPage(),
            if (showUserModal) _buildUserModal(),
            SizedBox(height: 16),
            _buildProfileImagePanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserModal() {
    return Dialog(
      child: Container(
        width: 500,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Create a Stream Profile',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('To access ASKY a separate profile from YLS is required.'),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Username*',
                      errorText: errors['username'],
                    ),
                    onChanged: (value) => newUser['username'] = value,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Email*',
                      errorText: errors['email'],
                    ),
                    onChanged: (value) => newUser['email'] = value,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('I accept the Terms and Privacy Policy'),
              value: status == 'accepted',
              onChanged: (value) {
                setState(() {
                  status = value! ? 'accepted' : 'not_accepted';
                  statusUnchecked = false;
                });
              },
            ),
            if (statusUnchecked)
              Text(
                'Please agree to our Terms and Privacy Policy before registering for an account.',
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTierColumn('FREE', '\$0/Month', Colors.green, true),
                _buildTierColumn(
                    'STANDARD', '\$49.99/Month', Colors.blue, false),
                _buildTierColumn(
                    'PREMIUM', '\$99.99/Month', Colors.orange, false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierColumn(
      String tier, String price, Color color, bool enabled) {
    return Column(
      children: [
        Text(tier, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        Text(price),
        ElevatedButton(
          child: Text('Register'),
          onPressed: enabled ? createFreeProfile : null,
        ),
        // TODO: need tier info and payment logic
      ],
    );
  }

  Widget _buildProfileImagePanel() {
    return Column(
      children: [
        Text('Profile Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        if (imgPath != null) Image.network(imgPath!),
        ElevatedButton(
          child: Text('Upload'),
          onPressed: _pickImage,
        ),
        SizedBox(height: 32),
        ElevatedButton(
          child: Text('Clear'),
          onPressed: () => setState(() => imgPath = null),
        ),
        if (imgPath != null)
          ElevatedButton(
            child: Text('Update Profile'),
            onPressed: uploadImage,
          ),
        if (uploading) CircularProgressIndicator(),
      ],
    );
  }

  void createFreeProfile() {
    if (status == 'accepted') {
      // TODO: Implement profile creation logic
    } else {
      setState(() => statusUnchecked = true);
    }
  }

  Future<void> _pickImage() async {
    // final image = await ImagePickerWeb.getImageAsBytes();
    // if (image != null) {
    //   final blob = web.Blob([image] as JSArray<web.BlobPart>);
    //   final url = web.URL.createObjectURL(blob);
    //   setState(() => imgPath = url);
    // }
  }

  Future<void> uploadImage() async {
    setState(() => uploading = true);
    try {
      // TODO : Implement image upload logic
    } catch (e) {
      // TODO : Handle error
    } finally {
      setState(() => uploading = false);
    }
  }
}

class AccountPage extends StatelessWidget {
  final controller = Get.find<GlobalController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.0),
        RotatingProfilePicture(
          frontImageUrl: PLACEHOLDER_IMAGE,
          // frontImageUrl: controller.credentials.value.user.pictureUrl
          //     .toString()
          //     .replaceFirst('secure.gravatar.com', 'ylift.app'),
          backImageUrl:
          'https://ylift.app/api/v2/mars/file/public/media/logo_white_circle.png',
          size: 160.0,
          rotationDuration: Duration(milliseconds: 100),
          stayDuration: Duration(seconds: 7),
        ),
        SizedBox(height: 32.0),
        Text('${controller.profile!.value.info?.name}'),
        SizedBox(height: 32.0),
        Text('${controller.profile!.value.followerCount ?? 0} Followers'),
      ],
    );
  }
}
