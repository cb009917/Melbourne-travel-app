// import 'package:flutter/material.dart';
// import 'package:tourist/Models/catagory.dart';
// import 'package:tourist/recomandation.dart';

// class catagory_page extends StatelessWidget {
//   const catagory_page({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 50,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           return Container(
//             height: 80,
//             child: Chip(
//               elevation: 0.4,
//               label: Text(touristmodel[index].name),
//               avatar: CircleAvatar(
//                 backgroundImage: AssetImage(touristmodel[index].image),
//               ),
//             ),
//           );
//         },
//         separatorBuilder: (context, index) =>
//             const Padding(padding: EdgeInsets.only(left: 10)),
//         itemCount: touristmodel.length,
//       ),
//     );
//   }
// }
