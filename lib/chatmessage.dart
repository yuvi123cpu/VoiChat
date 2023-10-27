import 'package:flutter/material.dart';

enum ChatMessageType {Swagster,AI, user}


class ChatMessage {


  ChatMessage({required this.text, required this.type});
  String text;
  ChatMessageType type;




}