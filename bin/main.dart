import 'dart:io';

import 'package:proto_game/src/proto_game_base.dart';
import 'package:proto_game_console/command.dart';
import 'package:dart_console/dart_console.dart';

main(List<String> args) async {
  String jsonContent = new File('example.json').readAsStringSync();
  GameDecoderBase gameDecoder = new GameDecoderJSON();

  Game game = gameDecoder.readFromFormat(jsonContent);

  InteractiveConsole console = new InteractiveConsole();

  new GameCommandListing(game).forEach((Command command){
    console.registerCommand(command);
  });


  print("You are in the room: ${game.player.plateau.currentRoom.name}");
  console.beginInput();
}
