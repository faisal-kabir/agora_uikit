import 'package:flutter/material.dart';

/// Widget that is displayed when local/remote video is disabled.
class DisabledVideoWidget extends StatefulWidget {
  const DisabledVideoWidget({Key? key}) : super(key: key);

  @override
  _DisabledVideoWidgetState createState() => _DisabledVideoWidgetState();
}

class _DisabledVideoWidgetState extends State<DisabledVideoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(8.0),
      child: const Center(
        child: Icon(Icons.video_call,color: Colors.white,),
      ),
    );
  }
}
