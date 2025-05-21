import 'package:flutter/material.dart';
import 'package:tic_tac_toe/Widget/sound.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? label; // Optional label text
  final String? iconPath; // Optional image asset path
  final Widget? iconWidget; // Optional widget (e.g., Icon or Image)
  final double width;
  final double spacebetweenIcon;
  final double height;
  final Color labelColor;

   CustomIconButton({
    super.key,
    required this.onTap,
    this.label,
    this.iconPath,
    this.iconWidget,
     this.spacebetweenIcon =8,
    this.labelColor =const Color(0xFF210045),
    this.width = 150,
    this.height = 57,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon = iconWidget ??
        (iconPath != null
            ? Image.asset(
          iconPath!,
          width: 28,
          height: 28,
        )
            : const SizedBox()); // fallback if nothing is provided

    return GestureDetector(
      onTap:(){
        AudioHelper().playButtonClick();
        onTap();
      } ,
      child: Container(
        width: width,
        height: height,
        // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF49E7F2), Color(0xFF423EB7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        // child: label == null
        //     ? Center(child: icon)
        //     : Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     icon,
        //     SizedBox(width: spacebetweenIcon),
        //     Text(
        //       label!,
        //       style:  TextStyle(
        //         fontSize: 24,
        //         fontFamily: 'Pridi',
        //         fontWeight: FontWeight.w500,
        //         color: labelColor,
        //       ),
        //     ),
        //   ],
        // ),
        child: (label != null && iconWidget == null && iconPath == null)
            ? Center(
          child: Text(
            label!,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Pridi',
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          ),
        )
            : (label != null
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(width: spacebetweenIcon),
            Text(
              label!,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Pridi',
                fontWeight: FontWeight.w500,
                color: labelColor,
              ),
            ),
          ],
        )
            : Center(child: icon)),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// class UndoButton extends StatelessWidget {
//   final VoidCallback onTap;
//
//   const UndoButton({super.key, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 150,
//         height: 57,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF56D8FF), Color(0xFF2E9AFF)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderRadius: BorderRadius.circular(40),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 3.0),
//               child: Image.asset(
//                 'assets/undo.png',
//                 width: 25,
//                 height: 25,
//               ),
//             ),
//             const SizedBox(width: 5),
//             const Text(
//               'Undo',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2C004C),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
