library proto_game_console.command;

import 'package:proto_game/src/proto_game_base.dart';

part "commands/moveCommand.dart";

abstract class Command {

  String command;

  Game game;

  Command(this.game);

  Map<int, List<String>> autoCompleteArg([String arg = ""]);

  void executeCommand(String arg);

  static int calculateLikenessScore(String arg, String comparison){
    int score = -1;
    if (arg.length == 0) return 0;
    int firstSameLetterIndex = comparison.indexOf(arg.substring(0, 1));
    if (firstSameLetterIndex == -1) return score;
    score = 1;
    for (int i = firstSameLetterIndex + 1; i < arg.length && i < comparison.length; i++){
      if (arg[i] != comparison[i]) {
        break;
      }
      score++;
    }
    // TODO : Should add memory of how often comparison is used and add it to the score
    return score;
  }

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

  String toString(){
    return commands.toString();
  }

}