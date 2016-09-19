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
    print("You are in the room: ${game.player.plateau.currentRoom.name}");
  });
  print("You are in the room: ${game.player.plateau.currentRoom.name}");
  console.beginInput();

}


class MappingToStdio extends LowLevelIo {

  Stdio io;
  MappingToStdio(this.io);

  void clear() => io.clear();
  String readLine() => io.readLine();
  void removeChars(int nb) => io.removeChars(nb);
  void writeLine(String line) => io.writeLine(line);
  void writeNewLine(String line) => io.writeNewLine(line);
  void writeString(String string) => io.writeString(string);
}