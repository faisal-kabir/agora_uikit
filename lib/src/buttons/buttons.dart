import 'package:agora_uikit/src/agora_client.dart';
import 'package:agora_uikit/src/enums.dart';
import 'package:flutter/material.dart';

/// A UI class to style how the buttons look. Use this class to add, remove or customize the buttons in your live video calling application.
class AgoraVideoButtons extends StatefulWidget {
  final AgoraClient client;

  /// List of enabled buttons. Use this to remove any of the default button or change their order.
  final List<BuiltInButtons>? enabledButtons;

  /// List of buttons that are added next to the default buttons. The buttons class contains a horizontal scroll view.
  final List<Widget>? extraButtons;

  /// Automatically hides the button class after a default time of 5 seconds if not set otherwise.
  final bool? autoHideButtons;

  /// The default auto hide time = 5 seconds
  final int autoHideButtonTime;

  /// Adds a vertical padding to the set of button
  final double? verticalButtonPadding;

  /// Alignment for the button class
  final Alignment buttonAlignment;

  /// Use this to style the disconnect button as per your liking while still keeping the default functionality.
  final Widget? disconnectButtonChild;

  /// Use this to style the mute mic button as per your liking while still keeping the default functionality.
  final Widget? muteButtonChild;

  /// Use this to style the switch camera button as per your liking while still keeping the default functionality.
  final Widget? switchCameraButtonChild;

  /// Use this to style the disabled video button as per your liking while still keeping the default functionality.
  final Widget? disableVideoButtonChild;

  final VoidCallback onDisconnectButtonClick;

  const AgoraVideoButtons({
    Key? key,
    required this.client,
    this.enabledButtons,
    this.extraButtons,
    this.autoHideButtons,
    this.autoHideButtonTime = 5,
    this.verticalButtonPadding,
    this.buttonAlignment = Alignment.bottomCenter,
    this.disconnectButtonChild,
    this.muteButtonChild,
    this.switchCameraButtonChild,
    this.disableVideoButtonChild,
    required this.onDisconnectButtonClick,
  }) : super(key: key);

  @override
  _AgoraVideoButtonsState createState() => _AgoraVideoButtonsState();
}

class _AgoraVideoButtonsState extends State<AgoraVideoButtons> {
  List<Widget> buttonsEnabled = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: widget.autoHideButtonTime),
      () {
        if (mounted) {
          setState(() {
            widget.client.sessionController.toggleVisible();
          });
        }
      },
    );

    Map buttonMap = <BuiltInButtons, Widget>{
      BuiltInButtons.toggleMic: _muteMicButton(),
      BuiltInButtons.callEnd: _disconnectCallButton(),
      BuiltInButtons.switchCamera: _switchCameraButton(),
      BuiltInButtons.toggleCamera: _disableVideoButton(),
    };

    if (widget.enabledButtons != null) {
      for (var i = 0; i < widget.enabledButtons!.length; i++) {
        for (var j = 0; j < buttonMap.length; j++) {
          if (buttonMap.keys.toList()[j] == widget.enabledButtons![i]) {
            buttonsEnabled.add(buttonMap.values.toList()[j]);
          }
        }
      }
    }
  }

  Widget toolbar(List<Widget>? buttonList) {
    return Container(
      alignment: widget.buttonAlignment,
      padding: widget.verticalButtonPadding == null
          ? const EdgeInsets.only(bottom: 48)
          : EdgeInsets.symmetric(
              vertical: widget.verticalButtonPadding!,
            ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Container(
              child: widget.enabledButtons == null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _disableVideoButton(),
                        _switchCameraButton(),
                        _muteMicButton(),
                        _disconnectCallButton(),
                        if (widget.extraButtons != null)
                          for (var i = 0; i < widget.extraButtons!.length; i++)
                            widget.extraButtons![i]
                      ],
                    )
                  : Row(
                      children: [
                        for (var i = 0; i < buttonList!.length; i++)
                          buttonList[i],
                        if (widget.extraButtons != null)
                          for (var i = 0; i < widget.extraButtons!.length; i++)
                            widget.extraButtons![i]
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _muteMicButton() {
    return widget.muteButtonChild != null
        ? RawMaterialButton(
            onPressed: () => widget.client.sessionController.toggleMute(),
            child: widget.muteButtonChild,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        : RawMaterialButton(
            onPressed: () => widget.client.sessionController.toggleMute(),
            child: Icon(
              widget.client.sessionController.value.isLocalUserMuted
                  ? Icons.mic_off
                  : Icons.mic,
              color: widget.client.sessionController.value.isLocalUserMuted
                  ? Colors.white
                  : Colors.black,
              size: 30.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: widget.client.sessionController.value.isLocalUserMuted
                ? Colors.black
                : Colors.white,
            padding: const EdgeInsets.all(12.0),
          );
  }

  Widget _disconnectCallButton() {
    return widget.disconnectButtonChild != null
        ? RawMaterialButton(
            onPressed: widget.onDisconnectButtonClick,
            child: widget.disconnectButtonChild,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        : RawMaterialButton(
            onPressed: widget.onDisconnectButtonClick,
            child: const Icon(Icons.call_end, color: Colors.white, size: 30),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          );
  }

  Widget _switchCameraButton() {
    return widget.switchCameraButtonChild != null
        ? RawMaterialButton(
            onPressed: () => widget.client.sessionController.switchCamera(),
            child: widget.switchCameraButtonChild,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        : RawMaterialButton(
            onPressed: () => widget.client.sessionController.switchCamera(),
            child: const Icon(
              Icons.switch_camera,
              color: Colors.black,
              size: 30.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          );
  }

  Widget _disableVideoButton() {
    return widget.disableVideoButtonChild != null
        ? RawMaterialButton(
            onPressed: () => widget.client.sessionController.toggleCamera(),
            child: widget.disableVideoButtonChild,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        : RawMaterialButton(
            onPressed: () => widget.client.sessionController.toggleCamera(),
            child: Icon(
              widget.client.sessionController.value.isLocalVideoDisabled
                  ? Icons.videocam_off
                  : Icons.videocam,
              color: widget.client.sessionController.value.isLocalVideoDisabled
                  ? Colors.white
                  : Colors.black,
              size: 30.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor:
                widget.client.sessionController.value.isLocalVideoDisabled
                    ? Colors.black
                    : Colors.white,
            padding: const EdgeInsets.all(12.0),
          );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.client.sessionController,
        builder: (context, counter, something) {
          return widget.autoHideButtons != null
              ? widget.autoHideButtons!
                  ? Visibility(
                      visible: widget.client.sessionController.value.visible,
                      child: toolbar(widget.enabledButtons == null
                          ? null
                          : buttonsEnabled),
                    )
                  : toolbar(
                      widget.enabledButtons == null ? null : buttonsEnabled)
              : toolbar(widget.enabledButtons == null ? null : buttonsEnabled);
        });
  }
}
