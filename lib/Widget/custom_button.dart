import 'package:flutter/material.dart';
import 'package:tic_tac_toe/Widget/sound.dart';

class RoundedGradientButton extends StatelessWidget {
  final String? text;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const RoundedGradientButton({
    super.key,
    this.text,
    this.leftIcon,
    this.rightIcon,
    this.width =300,
    this.height =57,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        AudioHelper().playButtonClick();
        onPressed();
      } ,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF49E7F2), Color(0xFF423EB7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(40),
          border: const Border(
            bottom: BorderSide(color: Color(0xFFFFB400), width: 3),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildContent(),
        ),
      ),
    );
  }

  // List<Widget> _buildContent() {
  //   if (leftIcon != null && rightIcon != null && text != null) {
  //     // Two icons and a label in between (e.g., "vs")
  //     return [
  //       leftIcon!,
  //       const SizedBox(width: 12),
  //       Text(
  //         text!,
  //         style: const TextStyle(
  //           color: Color(0xFF2C004C),
  //           fontSize: 20,
  //           fontFamily: 'Pridi',
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       const SizedBox(width: 12),
  //       rightIcon!,
  //     ];
  //   } else if (leftIcon != null && text != null) {
  //     // One icon and label (e.g., "Play ▶️")
  //     return [
  //       Text(
  //         text!,
  //         style: const TextStyle(
  //           color: Color(0xFF2C004C),
  //           fontSize: 20,
  //           fontFamily: 'Pridi',
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       // const SizedBox(width: 8),
  //       Padding(
  //         padding: const EdgeInsets.only(top: 3.0),
  //         child: leftIcon!,
  //       ),
  //     ];
  //   } else {
  //     // Fallback (only text or something wrong)
  //     return [
  //       Text(
  //         text ?? '',
  //         style: const TextStyle(
  //           color: Color(0xFF2C004C),
  //           fontSize: 20,
  //           fontFamily: 'Pridi',
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ];
  //   }
  // }
  List<Widget> _buildContent() {
    if (leftIcon != null && rightIcon != null && text != null) {
      // Two icons and a label in between
      return [
        leftIcon!,
        const SizedBox(width: 12),
        Text(
          text!,
          style: const TextStyle(
            color: Color(0xFF2C004C),
            fontSize: 18,
            fontFamily: 'Pridi',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 6),
        rightIcon!,
      ];
    } else if (leftIcon != null && text != null) {
      // Left icon and label
      return [

        Text(
          text!,
          style: const TextStyle(
            color: Color(0xFF2C004C),
            fontSize: 18,
            fontFamily: 'Pridi',
            fontWeight: FontWeight.bold,
          ),
        ),
        leftIcon!,
      ];
    } else if (rightIcon != null && text != null) {
      // Right icon and label
      return [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: rightIcon!,
        ),
        const SizedBox(width: 8),
        Text(
          text!,
          style: const TextStyle(
            color: Color(0xFF2C004C),
            fontSize: 18,
            fontFamily: 'Pridi',
            fontWeight: FontWeight.bold,
          ),
        ),


      ];
    } else {
      // Fallback
      return [
        Text(
          text ?? '',
          style: const TextStyle(
            color: Color(0xFF2C004C),
            fontSize: 18,
            fontFamily: 'Pridi',
            fontWeight: FontWeight.bold,
          ),
        ),
      ];
    }
  }

}




// import 'package:flutter/material.dart';
//
// class RoundedGradientButton extends StatelessWidget {
//   final String text;
//   final IconData icon;
//   final VoidCallback onPressed;
//
//   const RoundedGradientButton({
//     super.key,
//     required this.text,
//     required this.icon,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         width: 300,
//         height: 57,
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF49E7F2), Color(0xFF423EB7)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderRadius: BorderRadius.circular(40),
//           // border: Border.all(color: Color(0xFFFFB400), width: 3),
//           border: const Border(
//             bottom: BorderSide(color: Colors.orange, width: 3),
//           ),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black26,
//               offset: Offset(0, 4),
//               blurRadius: 6,
//             ),
//           ],
//         ),
//         child: Row(
//           // mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               text,
//               style: const TextStyle(
//                 color: Color(0xFF2C004C),
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             // const SizedBox(width: 8),
//             Padding(
//               padding: const EdgeInsets.only(top: 2.0),
//               child: Icon(
//                 icon,
//                 color: const Color(0xFF2C004C),
//                 size: 30,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
