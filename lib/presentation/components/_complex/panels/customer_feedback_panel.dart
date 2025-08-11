// import 'package:YLift/core/constants/constant.dart';
// import 'package:YLift/core/controllers/global.dart';
// import 'package:YLift/presentation/components/_complex/desktop_view/gap.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:get/get.dart';
// import 'package:galaxy_ui/galaxy_ui.dart';
// import 'package:galaxy_models/galaxy_models.dart';
// class CustomerFeedbackPanel extends StatefulWidget {
//   const CustomerFeedbackPanel({super.key});
//
//   @override
//   State<CustomerFeedbackPanel> createState() => _CustomerFeedbackPanelState();
// }
//
// class _CustomerFeedbackPanelState extends State<CustomerFeedbackPanel> {
//   final GlobalController global = Get.find<GlobalController>();
//   FeedBackType? feedBackTypeService;
//   FeedBackType? feedBackTypeWebsite;
//   String? errorMessage;
//   var _controller = InputTextFieldController();
//
//   void setTypeService(FeedBackType type) {
//     setState(() {
//       feedBackTypeService = type;
//     });
//   }
//
//   void setTypeWebsite(FeedBackType type) {
//     setState(() {
//       feedBackTypeWebsite = type;
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void submit() {
//     try {
//       // final isFormValid = validateForm();
//       // if (!isFormValid) return;
//       //
//       // // a custom data object to render page data
//       // final addressTileData = AddressSimple(
//       //   // addressSimple: createNewAddress(),
//       //   // fullName: '${firstName.text} ${lastName.text}',
//       //   // companyName: companyName.text,
//       //     name: '${firstName.text} ${lastName.text}',
//       //     line1: line1.text,
//       //     line2: line2.text,
//       //     country: 'United States',
//       //     city: city.text,
//       //     state: usState!.code,
//       //     zip: zipCode.text,
//       //     // type: addressType,
//       //     isDefault: isDefault,
//       //     // email: email.text,
//       //     phone: phoneNumber.text,
//       //     createdAt: DateTime.now(),
//       //     type: addressType!
//       // );
//
//       //widget.onSubmit(addressTileData);
//     } catch (e) {
//       setState(() {
//         errorMessage = '$e';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const GapY(),
//         Text('Rate our Website',
//             style:
//             TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         const GapY(),
//         Row(
//           children: [
//             Text('Please rate the website overall'),
//           ],
//         ),
//         const GapY(),
//         Wrap(
//           children: [
//             OverflowBar(
//               alignment: MainAxisAlignment.start,
//               spacing: YLiftConstant.gap,
//               overflowSpacing: 16,
//               children: List.generate(
//                 FeedBackType.values.length,
//                     (index) {
//                   final type = FeedBackType.values[index];
//
//                   return OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       backgroundColor: type == feedBackTypeWebsite ? YLiftColor
//                           .orange : null,
//                       overlayColor: YLiftColor.orange,
//                       shape: const RoundedRectangleBorder(
//                         borderRadius:
//                         BorderRadius.all(Radius.circular(4)),
//                       ),
//                       side:
//                       const BorderSide(color: Colors.grey, width: 1),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 24, vertical: 16),
//                       foregroundColor: YLiftColor.softBlack,
//                     ),
//                     onPressed: () => setTypeWebsite(type),
//                     child: Text(
//                       type.name,
//                       style: TextStyle(
//                           color: type == feedBackTypeWebsite
//                               ? Colors.white
//                               : null
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//         const GapY(),
//         Row(
//           children: [
//             Text('Please rate how well could you understand the website'),
//           ],
//         ),
//         const GapY(),
//         Wrap(
//           children: [
//             OverflowBar(
//               alignment: MainAxisAlignment.start,
//               spacing: YLiftConstant.gap,
//               overflowSpacing: 16,
//               children: List.generate(
//                 FeedBackType.values.length,
//                     (index) {
//                   final type = FeedBackType.values[index];
//                   return OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       backgroundColor: type == feedBackTypeService ? YLiftColor
//                           .orange : null,
//                       overlayColor: YLiftColor.orange,
//                       shape: const RoundedRectangleBorder(
//                         borderRadius:
//                         BorderRadius.all(Radius.circular(4)),
//                       ),
//                       side:
//                       const BorderSide(color: Colors.grey, width: 1),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 24, vertical: 16),
//                       foregroundColor: YLiftColor.softBlack,
//                     ),
//                     onPressed: () => setTypeService(type),
//                     child: Text(
//                       type.name,
//                       style: TextStyle(
//                           color: type == feedBackTypeService
//                               ? Colors.white
//                               : null
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//         const GapY(),
//         Text('Anything else to add?'),
//         TextField(
//           controller: _controller,
//           minLines: 3,
//           maxLines: 5,
//           keyboardType: TextInputType.multiline,
//         ),
//         Text(
//           'Thank you for taking time to give us feedback. Unfortunately, we are unable to reply directly to your comments. If you need to contact Customer Service again, please click the Contact Us button on any page',
//           style: TextStyle(fontSize: 11.11),
//         ),
//         const GapY(),
//         if (errorMessage != null)
//           Text(
//             errorMessage!,
//             style: TextStyle(color: YLiftColor.orange, fontSize: 11.11),
//           ),
//         const GapY(),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 200,
//               child: YLiftFilledButton(
//                 onPressed: submit,
//                 child: const Text('Submit'),
//               ),
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }
