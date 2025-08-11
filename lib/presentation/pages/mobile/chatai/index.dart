// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:uuid/uuid.dart';
//
// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   List<types.Message> _messages = [];
//   final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
//   final _bot = const types.User(id: 'bot');
//
//   @override
//   void initState() {
//     super.initState();
//     _addMessage(types.TextMessage(
//       author: _bot,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: const Uuid().v4(),
//       text: "Welcome to YLift Store! How can I assist you today?",
//     ));
//   }
//
//   void _addMessage(types.Message message) {
//     setState(() {
//       _messages.insert(0, message);
//     });
//   }
//
//   void _handleSendPressed(types.PartialText message) {
//     final textMessage = types.TextMessage(
//       author: _user,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: const Uuid().v4(),
//       text: message.text,
//     );
//
//     _addMessage(textMessage);
//     _processMessage(message.text);
//   }
//
//   void _processMessage(String text) {
//     final response = _generateResponse(text.toLowerCase());
//
//     final botMessage = types.TextMessage(
//       author: _bot,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: const Uuid().v4(),
//       text: response,
//     );
//
//     _addMessage(botMessage);
//   }
//
//   String _generateResponse(String text) {
//     if (text.contains('product') || text.contains('item')) {
//       return "YLift Store offers a variety of products. Are you interested in skincare, medical equipment, or exclusive items?";
//     } else if (text.contains('price') || text.contains('cost')) {
//       return "Our prices vary by product. Which specific item are you curious about?";
//     } else if (text.contains('delivery') || text.contains('shipping')) {
//       return "We provide free shipping on orders over \$50. Standard delivery typically takes 3-5 business days.";
//     } else if (text.contains('return') || text.contains('refund')) {
//       return "We have a 30-day return policy for unused products. Would you like more information about our return process?";
//     } else {
//       return "I'm not quite sure what you mean. Could you rephrase your question or ask about our products, pricing, delivery, or return policy?";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Chat(
//           messages: _messages,
//           onSendPressed: _handleSendPressed,
//           user: _user,
//           theme: DefaultChatTheme(
//             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           ),
//         ),
//       ),
//     );
//   }
// }