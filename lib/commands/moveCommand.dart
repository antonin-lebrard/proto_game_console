part of proto_game_console.command;


class MoveCommand extends Command {

  MoveCommand(Game game, IOInterface io) : super(game, io);

  @override
  List<String> _listPossibleArgs(){
    List<String> possibleArgs = new List<String>();
    game.plateau.getCurrentRoom().getNextRooms().keys.forEach((Direction direction){
      String dir = direction.toString().substring("Direction.".length, direction.toString().length).toLowerCase();
      possibleArgs.add(dir);
    });
    return possibleArgs;
  }

  @override
  void executeCommand(String arg){
    Direction direction = GameDecoderJSON.parseDirection(arg);
    if (direction != null)
      game.plateau.move(direction);
  }

}