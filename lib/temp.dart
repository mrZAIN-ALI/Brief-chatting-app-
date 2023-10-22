// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chit_chat/api/api.dart';
// import 'package:chit_chat/helpers/dialogs.dart';
// import 'package:chit_chat/models/user.dart';
// import 'package:chit_chat/screens/auth_Screens/login_Screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class ProfileScreen extends StatefulWidget {
//   final chatUUser_Info user_Info;
//   const ProfileScreen(this.user_Info);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final FocusNode nameFocusNode = FocusNode();
//   final FocusNode aboutFocusNode = FocusNode();
//   @override
//   void dispose() {
//     nameFocusNode.dispose();
//     aboutFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     //
//     final mediaQ = MediaQuery.of(context).size;
//     final heightForCircularImage = mediaQ.height * 0.20;
//     final primaryThemeColor = Theme.of(context).colorScheme.primary;
//     final _textFormKey = GlobalKey<FormState>();
//     //
//     return GestureDetector(
//       // onTap: () {
//       //   FocusNode currentFocus = FocusScope.of(context);
//       //   if (!currentFocus.hasPrimaryFocus) {
//       //     currentFocus.unfocus();
//       //   }
//       // },
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         appBar: AppBar(
//           leading: Icon(Icons.home_outlined),
//           title: Text("User Profile"),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: mediaQ.height * 0.020,
//                 width: mediaQ.width,
//               ),
//               Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius:
//                         BorderRadius.circular(heightForCircularImage / 2),
//                     child: CachedNetworkImage(
//                       fit: BoxFit.cover,
//                       height: heightForCircularImage,
//                       width: heightForCircularImage,
//                       imageUrl: widget.user_Info.image ??
//                           "http://via.placeholder.com/350x150",
//                       progressIndicatorBuilder:
//                           (context, url, downloadProgress) =>
//                               CircularProgressIndicator(
//                                   value: downloadProgress.progress),
//                       errorWidget: (context, url, error) =>
//                           Icon(CupertinoIcons.person),
//                     ),
//                   ),
//                   Positioned(
//                     child: MaterialButton(
//                       onPressed: () {},
//                       child: Icon(
//                         Icons.edit,
//                         color: primaryThemeColor,
//                       ),
//                       color: Colors.white,
//                       shape: CircleBorder(),
//                     ),
//                     bottom: 0,
//                     right: 0,
//                     // left: 4,
//                   ),
//                 ],
//               ),
//               //
//               SizedBox(
//                 height: mediaQ.height * 0.020,
//               ),
//               Text(
//                 widget.user_Info.email,
//                 style: TextStyle(color: Colors.black54),
//               ),
//               //
//               SizedBox(
//                 height: mediaQ.height * 0.040,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Form(
//                   key: _textFormKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         onTap: ()=>nameFocusNode.requestFocus(),
//                         focusNode: nameFocusNode,
//                         keyboardType: TextInputType.name,
//                         initialValue: widget.user_Info.name,
//                         onSaved: (newValue) => Apis.me_LoggedIn.name =
//                             newValue! ?? "Default Value by zain",
//                         validator: (value) => (value!.isEmpty && value != null)
//                             ? "Name can't be empty"
//                             : null,
//                         // style: TextStyle(
//                         //   color: nameFocusNode.hasFocus ? primaryThemeColor : Colors.black,
//                         // ),
//                         decoration: InputDecoration(
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(
//                               color: nameFocusNode.hasFocus
//                                   ? primaryThemeColor
//                                   : Colors.black54,
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(
//                               color: primaryThemeColor,
//                             ),
//                           ),
//                           hintText: "i.e : John Smith",
//                           prefixIcon: Icon(
//                             CupertinoIcons.person,
//                             color: nameFocusNode.hasFocus
//                                 ? primaryThemeColor
//                                 : Colors.black54,
//                             // color: primaryThemeColor,
//                           ),
//                           labelText: "Name",
//                           labelStyle: TextStyle(
//                             color: nameFocusNode.hasFocus
//                                 ? primaryThemeColor
//                                 : Colors.black54,
//                             fontSize: 25,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               //
//               SizedBox(
//                 height: mediaQ.height * 0.020,
//               ),
//               //

//               //
//               SizedBox(
//                 height: mediaQ.height * 0.050,
//               ),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   if (_textFormKey.currentState!.validate()) {
//                     _textFormKey.currentState!.save();
//                     Apis.updateUserInfo().then((value) {
//                       Navigator.of(context).pop();
//                     });
//                   }
//                 },
//                 icon: Icon(Icons.edit),
//                 label: Text("Update Profile"),
//                 style: ElevatedButton.styleFrom(
//                     minimumSize:
//                         Size(mediaQ.width * 0.7, mediaQ.height * .06),
//                     // shape: RoundedRectangleBorder(
//                     //   borderRadius: BorderRadius.circular(15),
//                     // ),
//                     shape: StadiumBorder()),
//               )
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () async {
//             DialogHelper.showProgressIndicator(context);
//             await Apis.auth.signOut().then((value) async {
//               await GoogleSignIn().signOut().then((value) {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//                 //
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => LoginScreen(),
//                   ),
//                 );
//                 //
//               });
//             });
//           },
//           child: Icon(Icons.logout),
//           backgroundColor: Colors.white,
//           foregroundColor: primaryThemeColor,
//         ),
//       ),
//     );
//   }
// }
