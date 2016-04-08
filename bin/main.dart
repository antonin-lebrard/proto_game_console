import 'dart:io';

import 'package:proto_game/src/proto_game_base.dart';
import 'command.dart';
import 'Console/console_entryPoint.dart';

main(List<String> args) async {
  String jsonContent = new File('example.json').readAsStringSync();
  GameDecoderBase gameDecoder = new GameDecoderJSON();

  Game game = gameDecoder.readFromFormat(jsonContent);

  InteractiveConsole console = new InteractiveConsole(game);

  while (true){
    print("You are in the room: ${(game.plateau as PlateauImpl).currentRoom.name}");
    ConsoleLine line = await console.readLine();
  }
}
