//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:tamrini/model/trainer.dart';
// import 'package:tamrini/utils/widgets/global%20Widgets.dart';
// import 'package:tamrini/utils/widgets/profile_widget.dart';
// import 'package:tamrini/utils/widgets/textfield_widget.dart';
//
// class EditTrainerProfileScreen extends StatefulWidget {
//   final Trainer user;
//   const EditTrainerProfileScreen({Key? key, required this.user}) : super(key: key);
//   @override
//   State<EditTrainerProfileScreen> createState() => _EditTrainerProfileScreenState();
// }
//
// class _EditTrainerProfileScreenState extends State<EditTrainerProfileScreen> {
//
//   @override
//   Widget build(BuildContext context) =>  Scaffold( persistentFooterButtons: [
//           adBanner() ],
//         appBar: globalAppBar("Edit Profile"),
//
//         body: ListView(
//           padding: const EdgeInsets.symmetric(horizontal: 32),
//           physics: const BouncingScrollPhysics(),
//           children: [
//             const SizedBox(height: 24),
//             ProfileWidget(
//               imagePath: widget.user.image!,
//               isEdit: true,
//               onClicked: () async {},
//             ),
//             const SizedBox(height: 24),
//             TextFieldWidget(
//               label: 'Full Name',
//               text: widget.user.name!,
//               onChanged: (name) {},
//             ),
//             const SizedBox(height: 24),
//             TextFieldWidget(
//               label: 'Email',
//               text: widget.user.contacts.toString(),
//               onChanged: (email) {},
//             ),
//             const SizedBox(height: 24),
//             TextFieldWidget(
//               label: 'About',
//               text: widget.user.description!,
//               maxLines: 5,
//               onChanged: (about) {},
//             ),
//             const SizedBox(height: 10),
//
//           ],
//         ),
//
//   );
// }
