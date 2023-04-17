import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialnetwork/provider/user_provider.dart';
import 'package:socialnetwork/utils/shared.dart';

class ResponsiveScreen extends StatefulWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  const ResponsiveScreen(
      {Key? key,
      required this.mobileScreenLayout,
      required this.webScreenLayout})
      : super(key: key);

  @override
  State<ResponsiveScreen> createState() => _ResponsiveScreenState();
}

class _ResponsiveScreenState extends State<ResponsiveScreen> {
  @override
  initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < mobileSreenSize) {
        return widget.mobileScreenLayout;
      }
      return widget.webScreenLayout;
    });
  }
}
