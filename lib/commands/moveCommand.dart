part of proto_game_console.command;


class MoveCommand extends GameCommand {

  MoveCommand(Game game) : super(game, "move");

  @override
  List<String> listPossibleArgs(){
    List<String> possibleArgs = new List<String>();
    game.player.plateau.getCurrentRoom().getNextRooms().keys.forEach((Direction direction){
      String dir = direction.toString().substring("Direction.".length, direction.toString().length).toLowerCase();
      possibleArgs.add(dir);
    });
    return possibleArgs;
  }

  @override
  void executeCommand(String arg, Stdio io){
    Direction direction = GameDecoderJSON.parseDirection(arg);
    if (direction != null)
      game.player.plateau.move(direction);
  }

}