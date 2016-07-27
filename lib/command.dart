library proto_game_console.command;

import 'package:proto_game/src/proto_game_base.dart';

import 'package:dart_console/dart_console.dart';

part "commands/moveCommand.dart";
part "commands/lookAtCommand.dart";
part "commands/wearTakeOffCommand.dart";

abstract class GameCommand extends Command {
  Game game;
  GameCommand(this.game, String command) : super(command);
}

class GameCommandListing {

  static GameCommandListing _singleton;

  List<Command> commands;

  GameCommandListing ._internal(Game game){
    commands = [
      new MoveCommand(game),
      new LookAtCommand(game),
      new WearCommand(game),
      new TakeOffCommand(game),
    ];
  }

  factory GameCommandListing (Game game){
    if (_singleton == null) {
      _singleton = new GameCommandListing._internal(game);
    }
    return _singleton;
  }

  Command operator [](int index) => commands[index];

  void forEach(Function each(Command command)){
    commands.forEach(each);
  }

  String toString(){
    return commands.toString();
  }

}