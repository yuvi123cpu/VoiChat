

import "package:Talkify/animatedloader.dart";
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import  'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:Talkify/API_services.dart';


import 'chatmessage.dart';


class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {

  SpeechToText speechToText  = SpeechToText();
  TextToSpeech textToSpeech = TextToSpeech();

  final List<ChatMessage> message = [];


  var scrollController = ScrollController();

  scrollMethod(){
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  String text = "Hold the button and start speaking.";

  bool _isListening = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black45,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: AvatarGlow(
            endRadius: 75,
            animate: _isListening,
            duration: Duration(milliseconds: 2000),
            glowColor: _isListening ? Vx.red700 : Vx.yellow900,
            repeat: true,
            repeatPauseDuration: Duration(milliseconds: 100),
            showTwoGlows: true,
            child: GestureDetector(
              onTapDown: (details) async {
                if (!_isListening) {
                  var available = await speechToText.initialize();
                  if (available) {
                    setState(() {
                      _isListening = true;
                      speechToText.listen(
                          onResult: (result) {
                            setState(() {
                              text = result.recognizedWords;
                            });
                          }
                      );
                    });
                  }
                }
              },

              onTapUp: (details)async {
                setState(() {
                  _isListening = false;
                });
                 await speechToText.stop();
                 if(text.isNotEmpty && text != "Hold the button and start speaking"){
    message.add(ChatMessage(text: text, type: ChatMessageType.user));

    var msg = API_services.send_message(text);


    setState(() {
    message.add(ChatMessage(text: msg, type: ChatMessageType.AI));
    });
    Future.delayed(Duration(milliseconds: 1000), (){
    speechToText.stop();

    });
    CircleAvatar(
        child: Icon(_isListening ? Icons.mic : Icons.mic_none,
          color: Colors.black,),
        backgroundColor: _isListening ? Colors.red : Colors.lightBlueAccent,
        radius: 35
    );



    }
              })
        ),




        appBar: AppBar(
          backgroundColor: Vx.black,
          elevation: 0.0,
          leading: Image.asset("assets/icon4.png"),
          title: Text(
                "Talkify",
                style: TextStyle(

                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.white

                ),
              ).px0(),
            ),

        body: Container(
          color: Vx.black,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              children: [
                Animatedloader(),
                Text(text, style: TextStyle(fontStyle: FontStyle.italic,
                    color: _isListening ? Colors.greenAccent : Colors.yellowAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)
                ),
                 Expanded(
                   flex: 2,
                   child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20), color: Colors.green
                      ),
                          child: SingleChildScrollView(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              controller: scrollController,
                              shrinkWrap: true,
                              itemCount: message.length,
                                itemBuilder: (BuildContext context, int index)
                                {
                                  var chat = message[index];
                                  return Chatbubble(
                                    chattext: chat.text,type: chat.type,
                                  );
                                }

                            ),


                          ),


                   ),
                 ),

                SizedBox(height: 12,),
                Text(
                  "Developed by Yuvraj",
                  style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: Vx.red500),

                ),
              ],
            ),

          ),
        );
  }

  Widget Chatbubble({required chattext, required ChatMessageType type}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.yellowAccent,
          child: type  == ChatMessageType.AI ? Image.asset("assets/icon.png") : Image.asset("assets/yuvi.png")
        ),
        SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: type == ChatMessageType.AI ? Colors.yellow : Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(12),bottomRight: Radius.circular(12),bottomLeft: Radius.circular(12))
              ),
              child: Text("$chattext",
              style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.italic,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),),

            ),
        ),
        if(_isListening) const Animatedloader(),
      ],
    );

  }

  }