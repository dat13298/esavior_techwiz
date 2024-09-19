import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customAppBar.dart';

class ActivityTab extends StatelessWidget {
  const ActivityTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Activity',
        subtitle: 'Recent updates',
      ),
      body: const Center(child: Text('Activity Tab')),
    );
  }
}
