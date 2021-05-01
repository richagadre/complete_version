import 'package:at_chat_flutter/at_chat_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThirdScreen extends StatefulWidget {
  static final String id = 'third';
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat', style: GoogleFonts.comfortaa(),), backgroundColor: Color(0xFF2196F3),),
      // TODO: Fill in the body parameter of the Scaffold
      body: ChatScreen(
        height: MediaQuery.of(context).size.height,
        incomingMessageColor: Color(0xFF2196F3),
        outgoingMessageColor: Colors.pink,
        isScreen: true,
      ),
    );
  }
}
