import 'package:circle_button/circle_button.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {super.key,
      this.onTap1,
      this.onTap2,
      this.colorModeButton,
      this.modeText,
      this.colorManualButton,
      this.manualText,
      this.mode});
  final Function? onTap1;
  final Function? onTap2;
  final Color? colorManualButton;
  final String? manualText;
  final Color? colorModeButton;
  final String? modeText;
  final bool? mode;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              CircleButton(
                onTap: () {
                  onTap1!();
                },
                backgroundColor: colorModeButton!,
                borderColor: Colors.transparent,
                width: 125,
                height: 125, // Adjust colors as needed
                child: Center(
                  child: Text(
                    modeText!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (mode!)
          Container(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                CircleButton(
                  onTap: () {
                    onTap2!();
                  },
                  backgroundColor: colorManualButton!,
                  borderColor: Colors.transparent,
                  width: 125,
                  height: 125,
                  child: Center(
                    child: Text(
                      manualText!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
