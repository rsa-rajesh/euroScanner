import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotkey_system/hotkey_system.dart';

import '../app_managers/color_manager.dart';

void showLoadingDialog(BuildContext context, {String message = 'Loading...'}) {
  SchedulerBinding.instance
      .addPostFrameCallback((_) => _buildLoadingDialog(context, message));
}

_buildLoadingDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Center(
                        child: SizedBox(
                            height: 60,
                            width: 60,
                            child: CircularProgressIndicator())),
                    SizedBox(width: 16),
                    Text(
                      "Please wait ... ",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      });
}

void showSnackBar(BuildContext context,
    {String message = 'Ok',
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    Color? bgColor,
    Color? actionLabelColor,
    String? actionLabel,
    void Function()? onPressed}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: bgColor,
      content: Text(
        message,
      ),
      behavior: behavior,
      action: SnackBarAction(
        label: actionLabel ?? '',
        textColor: actionLabelColor ?? ColorManager.textDark,
        onPressed: onPressed ?? () {},
      ),
    ),
  );
}

// // ==================== CONFIRM DIALOG =========================
// showConfirmDialog(
//   BuildContext context, {
//   String title = '',
//   String desctiption = '',
//   required Function() onConfirm,
// }) {
//   SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0)), //this right here
//             child: SizedBox(
//               width: 320.0,
//               child: Padding(
//                 padding: const EdgeInsets.all(32.0),
//                 child: Wrap(
//                   direction: Axis.vertical,
//                   crossAxisAlignment: WrapCrossAlignment.start,
//                   children: [
//                     CustomText(
//                         title: title,
//                         color: ColorManager.textDark,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         textOverflow: TextOverflow.ellipsis),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     SizedBox(
//                       width: 250.0,
//                       child: CustomText(
//                           title: desctiption,
//                           color: ColorManager.textDark,
//                           fontSize: 14,
//                           textOverflow: TextOverflow.ellipsis),
//                     ),
//                     const SizedBox(
//                       height: 32,
//                     ),
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             onConfirm();
//                             Navigator.of(context).pop();
//                           },
//                           child: Container(
//                             width: 100,
//                             decoration: BoxDecoration(
//                                 color: ColorManager.profileBg,
//                                 borderRadius: const BorderRadius.all(
//                                     Radius.circular(10))),
//                             padding: const EdgeInsets.all(16),
//                             child: Text("Yes",
//                                 textAlign: TextAlign.center,
//                                 style: GoogleFonts.lato(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w800,
//                                     color: ColorManager.textDark)),
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 32,
//                         ),
//                         GestureDetector(
//                           onTap: () => Navigator.pop(context),
//                           child: Container(
//                             width: 100,
//                             decoration: BoxDecoration(
//                                 color: ColorManager.black,
//                                 borderRadius: const BorderRadius.all(
//                                     Radius.circular(10))),
//                             padding: const EdgeInsets.all(16),
//                             child: Text("Cancel",
//                                 textAlign: TextAlign.center,
//                                 style: GoogleFonts.lato(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w800,
//                                     color: ColorManager.white)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   });
// }

// =============== APP EXIT CONFIRMATION DIALOG =====================
Future<bool?> showExitDialog(BuildContext context,
    {String title = "Exit App?",
    String body = "Are you sure you want to exit?"}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)), //this right here
          child: SizedBox(
            width: 320.0,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: 250.0,
                    child: Text(
                      body,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          SystemNavigator.pop();
                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                              color: ColorManager.buttonLightGrey,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(16),
                          child: Text("Yes",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: ColorManager.textDark)),
                        ),
                      ),
                      const SizedBox(
                        width: 32,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context, false),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                              color: ColorManager.textDark,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(16),
                          child: Text("Cancel",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, color: ColorManager.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

// =============== CHANGE HOTKEY DIALOG =====================
Future<bool?> showHotKeyDialog(BuildContext context,
    {String title = "Change hot key",
    String body = "Press key combination to change",
    required HotKey hotKey,
    int type = 1,
    VoidCallback? onChanged,
    required VoidCallback? onSaved(HotKey)}) {
  HotKey? newHotKey;

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)), //this right here
          child: SizedBox(
            width: 320.0,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  SizedBox(
                    width: 280,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        overflow: TextOverflow.visible,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  HotKeyRecorder(
                      onHotKeyRecorded: (hotKey) {
                        newHotKey = hotKey;
                        onChanged!();
                      },
                      initialHotKey: hotKey),
                  SizedBox(
                    width: 250.0,
                    child: Text(
                      body,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (type == 1) {
                            newHotKey?.scope = HotKeyScope.inapp;
                            newHotKey?.identifier = "quit app identifier";
                          } else {
                            newHotKey?.scope = HotKeyScope.system;
                            newHotKey?.identifier = "min app identifier";
                          }

                          onSaved(newHotKey);
                          navigator?.pop();
                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                              color: ColorManager.buttonLightGrey,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(8),
                          child: Text("Save",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: ColorManager.textDark)),
                        ),
                      ),
                      const SizedBox(
                        width: 32,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context, false),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                              color: ColorManager.textDark,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(8),
                          child: Text("Cancel",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, color: ColorManager.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
