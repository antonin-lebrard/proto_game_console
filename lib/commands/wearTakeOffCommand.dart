part of proto_game_console.command;


class WearCommand extends Command {

  WearCommand(Game game, IOInterface io) : super(game, io);

  @override
  List<String> _listPossibleArgs() {
    List<String> possibleArgs = new List<String>();
    for (BaseGameObject obj in game.player.inventory){
      if (obj is WearableGameObject)
        possibleArgs.add(obj.name);
    }
    for (BaseGameObject obj in game.plateau.getCurrentRoom().getObjects()){
      if (obj is WearableGameObject)
        possibleArgs.add(obj.name);
    }
    return possibleArgs;
  }

  @override
  void executeCommand(String arg) {
    if (arg.length == 0) return;
    for (int i = 0; i < game.player.inventory.length; i++){
      BaseGameObject obj = game.player.inventory[i];
      if (obj.name == arg){
        if (!(obj is WearableGameObject)) {
          io.writeNewLine("${obj.name} is not wearable");
          return;
        }
        game.player.wearing.add(obj);
        game.player.inventory.remove(obj);
        io.writeNewLine("You're now wearing ${obj.name}");
        return;
      }
    }
    if (game.plateau.getCurrentRoom().getObjects() == null) {
      io.writeNewLine("${arg} not found");
      return;
    }
    for (int i = 0; i < game.plateau.getCurrentRoom().getObjects().length; i++){
      BaseGameObject obj = game.plateau.getCurrentRoom().getObjects()[i];
      if (obj.name == arg){
        if (!(obj is WearableGameObject)) {
          io.writeNewLine("${obj.name} is not wearable");
          return;
        }
        game.player.wearing.add(obj);
        game.plateau.getCurrentRoom().getObjects().remove(obj);
        io.writeNewLine("You're now wearing ${obj.name}");
        return;
      }
    }
    io.writeNewLine("${arg} not found");
  }
}

class TakeOffCommand extends Command {

  TakeOffCommand(Game game, IOInterface io) : super(game, io);

  @override
  List<String> _listPossibleArgs() {
    List<String> possibleArgs = new List();
    for (WearableGameObject obj in game.player.wearing){
      possibleArgs.add(obj.name);
    }
    return possibleArgs;
  }

  @override
  void executeCommand(String arg){
    if (arg.length == 0) return;
    for (int i = 0; i < game.player.wearing.length; i++){
      WearableGameObject obj = game.player.wearing[i];
      if (obj.name == arg){
        game.player.inventory.add(obj);
        game.player.wearing.remove(obj);
        io.writeNewLine("You have take off ${obj.name}");
        return;
      }
    }
    io.writeNewLine("${arg} not worn");
  }
}