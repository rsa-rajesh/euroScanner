// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
//
// import '../app_managers/assets_managers.dart';
// import '../app_managers/color_manager.dart';
//
// class CustomCachedImage extends StatelessWidget {
//   final double? height;
//   final double? width;
//   final String imageUrl;
//   final BoxFit? fit;
//   final Alignment? alignment;
//
//   const CustomCachedImage({
//     Key? key,
//     this.height,
//     this.width,
//     required this.imageUrl,
//     this.fit,
//     this.alignment,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return CachedNetworkImage(
//       height: height,
//       width: width,
//       fit: fit,
//       imageUrl: imageUrl,
//       alignment: alignment ?? Alignment.center,
//       errorWidget: (context, url, error) {
//         return Container(
//           padding: const EdgeInsets.all(32.0),
//           child: Image.asset(AssetManager.appLogo,
//               color: Colors.white.withOpacity(0.2),
//               colorBlendMode: BlendMode.modulate),
//         );
//       },
//       placeholder: (context, url) => Center(
//         child: CircularProgressIndicator(
//           strokeWidth: 2,
//           color: ColorManager.buttonGrey,
//           backgroundColor: ColorManager.buttonLightGrey,
//         ),
//       ),
//     );
//   }
// }
