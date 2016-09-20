part of proto_game_console.command;


class WearCommand extends GameCommand {

  WearCommand(Game game) : super(game, "wear");

  @override
  List<String> listPossibleArgs() {
    List<String> possibleArgs = new List<String>();
    for (BaseGameObject obj in game.player.inventory){
      if (obj is WearableGameObject)
        possibleArgs.add(obj.name);
    }
    for (BaseGameObject obj in game.player.plateau.getCurrentRoom().getObjects()){
      if (obj is WearableGameObject)
        possibleArgs.add(obj.name);
    }
    return possibleArgs;
  }

  @override
  void executeCommand(String arg, Stdio io) {
    if (arg.length == 0) return;
    for (int i = 0; i < game.player.inventory.length; i++){
      BaseGameObject obj = game.player.inventory[i];
      if (obj.name == arg){
        if (!(obj is WearableGameObject)) {
          io.writeNewLine("${obj.name} is not wearable");
          return;
        }
        obj.executeAction("wear");
        io.writeNewLine("You're now wearing ${obj.name}");
        return;
      }
    }
    if (game.player.plateau.getCurrentRoom().getObjects() == null) {
      io.writeNewLine("${arg} not found");
      return;
    }
    for (int i = 0; i < game.player.plateau.getCurrentRoom().getObjects().length; i++){
      BaseGameObject obj = game.player.plateau.getCurrentRoom().getObjects()[i];
      if (obj.name == arg){
        if (!(obj is WearableGameObject)) {
          io.writeNewLine("${obj.name} is not wearable");
          return;
        }
        obj.executeAction("wear");
        io.writeNewLine("You're now wearing ${obj.name}");
        return;
      }
    }
    io.writeNewLine("${arg} not found");
  }
}

class TakeOffCommand extends GameCommand {

  TakeOffCommand(Game game) : super(game, "takeoff");

  @override
  List<String> listPossibleArgs() {
    List<String> possibleArgs = new List();
    for (WearableGameObject obj in game.player.wearing){
      possibleArgs.add(obj.name);
    }
    return possibleArgs;
  }

  @override
  void executeCommand(String arg, Stdio io){
    if (arg.length == 0) return;
    for (int i = 0; i < game.player.wearing.length; i++){
      WearableGameObject obj = game.player.wearing[i];
      if (obj.name == arg){
        obj.executeAction("remove");
        io.writeNewLine("You have taken off ${obj.name}");
        return;
      }
    }
    io.writeNewLine("${arg} not worn");
  }
}