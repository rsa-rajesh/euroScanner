import 'package:flutter/material.dart';

import '../app_managers/color_manager.dart';

class NoItem extends StatelessWidget {
  String asset;
  String? title;
  String? desc;
  NoItem({super.key, required this.asset, this.desc, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(asset),
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            title ?? "",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: ColorManager.noItemTitleColor,
            ),

          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          desc ?? "",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ColorManager.noItemDescColor,
          ),
        )
      ],
    );
  }
}
