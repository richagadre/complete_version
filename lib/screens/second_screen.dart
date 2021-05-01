import 'package:at_chat_flutter/at_chat_flutter.dart';
import 'package:flutter/material.dart';
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
import '../service/client_sdk_service.dart';
import 'third_screen.dart';
import '../utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondScreen extends StatefulWidget {
  static final String id = 'second';
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  ClientSdkService clientSdkService = ClientSdkService.getInstance();
  String activeAtSign = '';
  GlobalKey<ScaffoldState> scaffoldKey;
  List<String> atSigns;
  String chatWithAtSign;
  bool showOptions = false;
  bool isEnabled = true;
  bool _visible = true;

  @override
  void initState() {
    // TODO: Call function to initialize chat service.
    getAtSignAndInitializeChat();
    scaffoldKey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(

        leading: Padding(
        padding: const EdgeInsets.all(8.0),
        ),

        title: Text('Direct Messages', style: GoogleFonts.comfortaa(),),
        backgroundColor: Color(0xFF2196F3),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
        ),

      ),
      ),

      floatingActionButton: FloatingActionButton(

        onPressed: () {
          // Call setState. This tells Flutter to rebuild the
          // UI with the changes.
          setState(() {
            _visible = !_visible;
          });
        },
        tooltip: 'Toggle Opacity',
        child: Text (
          'Close',
          style: GoogleFonts.comfortaa(),
          textAlign: TextAlign.center,
        ),
          backgroundColor: Color(0xFF2196F3),
        ),
       // This trailing comma makes auto-formatting nicer for build methods.
      body: Center(
        child: Column(
          children: <Widget>[
         AnimatedOpacity(
          // If the widget is visible, animate to 0.0 (invisible).
          // If the widget is hidden, animate to 1.0 (fully visible).
          opacity: _visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          // The green box must be a child of the AnimatedOpacity widget.
          child: Container(
            width: 200.0,
            height: 50.0,

            decoration: BoxDecoration(
               borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.grey[200],
            ),
            child:Text(
                '@alice: I am suffering from ...',
              style: GoogleFonts.comfortaa(),
                  textAlign: TextAlign.center,
            )
          ),
        ),

            SizedBox(
              height: 20.0,
            ),

            Container(

              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Text(
                'Welcome $activeAtSign!',
                style: GoogleFonts.comfortaa(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text('Choose an @sign to chat with', style: GoogleFonts.comfortaa(),),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: DropdownButton<String>(
                hint:  Text('\tPick an @sign', style: GoogleFonts.comfortaa(),),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                ),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black87
                ),
                underline: Container(
                  height: 2,
                  color: Color(0xFF2196F3),
                ),
                onChanged: isEnabled ? (String newValue) {
                  setState(() {
                    chatWithAtSign = newValue;
                    isEnabled = false;
                  });
                } : null,
                disabledHint: chatWithAtSign != null ? Text(chatWithAtSign)
                  : null,
                value: chatWithAtSign != null ? chatWithAtSign : null,
                items: atSigns == null ? null : atSigns
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: GoogleFonts.comfortaa(),),
                    );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            showOptions ? Column(
              children: [
                SizedBox(height: 20.0),
                FlatButton(
                  onPressed: () {
                    scaffoldKey.currentState
                        .showBottomSheet((context) => ChatScreen());
                  },
                  child: Container(
                    height: 40,
                    child: Text('Open chat in bottom sheet'),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ThirdScreen.id);
                  },
                  child: Container(
                    height: 40,
                    child: Text('Navigate to chat screen', style: GoogleFonts.comfortaa(),),
                  ),
                )
              ],
            )
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {
                    if (chatWithAtSign != null &&
                        chatWithAtSign.trim() != '') {
                      // TODO: Call function to set receiver's @sign
                      setAtsignToChatWith();
                      setState(() {
                        showOptions = true;
                      });
                    } else {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(
                              children: [Text('@sign Missing!')],
                            ),
                            content: Text('Please enter an @sign', style: GoogleFonts.comfortaa(),),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Close', style: GoogleFonts.comfortaa(),),
                              )
                            ],
                          );
                        });
                      }
                  },
                  child: Container(
                    height: 40,
                    child: Text('Chat options', style: GoogleFonts.comfortaa(),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  // TODO: Write function to initialize the chatting service
  getAtSignAndInitializeChat() async {
    String currentAtSign = await clientSdkService.getAtSign();
    setState(() {
      activeAtSign = currentAtSign;
    });
    List<String> allAtSigns = at_demo_data.allAtsigns;
    allAtSigns.remove(activeAtSign);
    setState(() {
      atSigns = allAtSigns;
    });
    initializeChatService(
        clientSdkService.atClientServiceInstance.atClient, activeAtSign,
        rootDomain: MixedConstants.ROOT_DOMAIN);
  }
  // TODO: Write function that determines whom you are chatting with
  setAtsignToChatWith() {
    setChatWithAtSign(chatWithAtSign);
  }
}
