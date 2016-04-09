library proto_game_console.command;

import 'package:proto_game/src/proto_game_base.dart';

import 'package:proto_game_console/ioInterface.dart';

part "commands/moveCommand.dart";
part "commands/lookAtCommand.dart";
part "commands/wearTakeOffCommand.dart";

abstract class Command {

  String command;

  Game game;

  IOInterface io;

  Command(this.game, this.io);

  Map<int, List<String>> autoCompleteArg([String arg = ""]){
    Map<int, List<String>> possibleCompletion = new Map();
    this._listPossibleArgs().forEach((String possibleArg){
      if (arg.length == 0){
        if (possibleCompletion[0] == null)
          possibleCompletion[0] = new List();
        possibleCompletion[0].add(possibleArg);
      } else if (arg.length > possibleArg.length) {
        return;
      } else {
        int score = Command.calculateLikenessScore(arg, possibleArg);
        if (score >= 0) {
          if (possibleCompletion[score] == null)
            possibleCompletion[score] = new List();
          possibleCompletion[score].add(possibleArg);
        }
      }
    });
    return possibleCompletion;
  }

  List<String> _listPossibleArgs();

  void executeCommand(String arg);

  static int calculateLikenessScore(String arg, String comparison){
    if (arg.length == 0) return 0;
    for (int i = 0; i < arg.length && i < comparison.length; i++){
      if (arg[i] != comparison[i]) {
        return -1;
      }
    }
    // TODO : Should add memory of how often comparison is used and add it to the score
    return 0;
  }

}


class CommandMap {

  static CommandMap _singleton;

  Map<String, Command> commands;

  CommandMap._internal(Game game, IOInterface io){
    commands = {
      "move": new MoveCommand(game, io),
      "lookat": new LookAtCommand(game, io),
      "wear": new WearCommand(game, io),
      "takeoff": new TakeOffCommand(game, io),
    };
  }

  factory CommandMap(Game game, IOInterface io){
    if (_singleton == null) {
      _singleton = new CommandMap._internal(game, io);
    }
    return _singleton;
  }

  Command operator [](String key) => commands[key];

  String toString(){
    return commands.toString();
  }

}