library proto_game_console.command;

import 'package:proto_game/src/proto_game_base.dart';

part "commands/moveCommand.dart";

abstract class Command {

  String command;

  Game game;

  Command(this.game);

  Map<int, List<String>> autoCompleteArg([String arg = ""]);

}


class CommandMap {

  static CommandMap _singleton;

  Map<String, Command> commands;

  CommandMap._internal(Game game){
    commands = {
      "move": new MoveCommand(game),
    };
  }

  factory CommandMap(Game game){
    if (_singleton == null) {
      _singleton = new CommandMap._internal(game);
    }
    return _singleton;
  }

  Command operator [](String key) => commands[key];

}