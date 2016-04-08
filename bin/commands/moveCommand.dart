part of proto_game_console.command;


class MoveCommand extends Command {

  MoveCommand(Game game) : super(game);

  Map<int, List<String>> autoCompleteArg([String arg = ""]) {
    Map<int, List<String>> possibleCompletion = new Map();
    game.plateau.getCurrentRoom().getNextRooms().keys.forEach((Direction direction){
      String dir = direction.toString().substring("Direction.".length, direction.toString().length).toLowerCase();
      if (arg.length == 0){
        if (possibleCompletion[0] == null)
          possibleCompletion[0] = new List();
        possibleCompletion[0].add(dir);
      } else if (arg.length > dir.length) {
        return;
      } else {
        int score = Command.calculateLikenessScore(arg, dir);
        if (score >= 0) {
          if (possibleCompletion[score] == null)
            possibleCompletion[score] = new List();
          possibleCompletion[score].add(dir);
        }
      }
    });
    return possibleCompletion;
  }

  @override
  void executeCommand(String arg){
    Direction direction = GameDecoderJSON.parseDirection(arg);
    if (direction != null)
      game.plateau.move(direction);
  }

}