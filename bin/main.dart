import 'dart:io';

import 'package:proto_game/src/proto_game_base.dart';
import 'package:proto_game_console/command.dart';
import 'package:proto_game_console/console/console_entryPoint.dart';

main(List<String> args) async {
  String jsonContent = new File('example.json').readAsStringSync();
  GameDecoderBase gameDecoder = new GameDecoderJSON();

  Game game = gameDecoder.readFromFormat(jsonContent);

  InteractiveConsole console = new InteractiveConsole(game);

  print("You are in the room: ${(game.plateau as PlateauImpl).currentRoom.name}");
  while (true){
    ConsoleLine line = await console.readLine();
  }
}
