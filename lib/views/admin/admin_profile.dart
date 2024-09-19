import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customAppBar.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        subtitle: 'Your information',
      ),
      body: Center(child: Text('Profile Tab')),
    );
  }
}
