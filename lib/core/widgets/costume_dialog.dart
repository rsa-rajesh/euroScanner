
import 'package:flutter/material.dart';

import '../app_managers/assets_managers.dart';

class CostumeDialog extends StatelessWidget {
  final String message;
  final bool cancelable;
  final String title;
  final String image;
  final String status;
  final VoidCallback? onButton1Clicked;
  final VoidCallback? onButton2Clicked;
  final bool button2Enabled;
  final String buttom1Lavel;
  final String buttom2Lavel;
  final Color titleColor;

  const CostumeDialog({
    Key? key,
    this.message = "Process Successfully Completed",
    this.title = 'Success',
    this.image = AssetManager.appLogo,
    this.status = 'Success',
    this.titleColor = const Color.fromARGB(255, 5, 119, 43),
    this.cancelable = false,
    this.button2Enabled = false,
    this.onButton1Clicked,
    this.onButton2Clicked,
    this.buttom1Lavel = 'OK',
    this.buttom2Lavel = 'Retry',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                if (cancelable) {
                  Navigator.pop(context);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: titleColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(22),
                        child: Image.asset(
                          image,
                          height: 140,
                          width: 140,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 12),
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: ElevatedButton(
                                      onPressed: (onButton1Clicked) != null
                                          ? () {
                                        Navigator.pop(context);
                                        onButton1Clicked!();
                                      }
                                          : () {
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(12.0)),
                                          backgroundColor:
                                          titleColor),
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Text(
                                          buttom1Lavel,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      )),
                                ),
                              ),
                              Visibility(
                                visible: button2Enabled,
                                child: Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: ElevatedButton(
                                        onPressed: (onButton2Clicked) != null
                                            ? () {
                                          onButton2Clicked!();
                                          Navigator.pop(context);
                                        }
                                            : () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(12.0)),
                                          backgroundColor: const Color.fromARGB(
                                              255, 219, 223, 170),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: Text(
                                            buttom2Lavel,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}