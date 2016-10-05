import 'dart:async';
import 'dart:io';

import 'package:proto_game/src/proto_game_base.dart';
import 'package:proto_game_console/command.dart';
import 'package:dart_console/dart_console.dart';

main(List<String> args) {

  InteractiveConsole console = new InteractiveConsole();

  String jsonContent;
  if (!new File('example.json').existsSync())
    jsonContent = new File('bin/example.json').readAsStringSync();
  else
    jsonContent = new File('example.json').readAsStringSync();
  GameDecoderBase gameDecoder = new GameDecoderJSON();

  Game game = gameDecoder.readFromFormat(jsonContent, new MappingToStdio(console.stdio));

  new GameCommandListing(game).forEach((Command command){
    console.registerCommand(command);
  });

  console.onEnter.listen((_) {
    print("You are in the room: ${game.player.plateau.currentRoom.name_id}");
  });
  print("You are in the room: ${game.player.plateau.currentRoom.name_id}");
  console.beginInput();

}


class MappingToStdio extends LowLevelIo {

  Stdio io;
  MappingToStdio(this.io);

  void clear() => io.clear();
  Future<String> readLine() => new Future.value(io.readLine());
  void removeChars(int nb) => io.removeChars(nb);
  void writeLine(String line) => io.writeLine(line);
  void writeNewLine(String line) => io.writeNewLine(line);
  void writeString(String string) => io.writeString(string);
  Future<String> presentChoices(List<String> choices){
    Completer<String> completer;
    bool chose = false;
    while (!chose){
      io.writeLine("Choose by typing the n° of your choice:");
      for (int i = 0; i < choices.length; i++)
        io.writeLine("$i: ${choices[i]}");
      int idx = int.parse(io.readLine(), onError: (_){});
      if (idx > -1 && idx < choices.length){
        completer.complete(choices[idx]);
        chose = true;
      }
    }
    return completer.future;
  }
}