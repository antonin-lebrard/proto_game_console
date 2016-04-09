part of proto_game_console.command;


class LookAtCommand extends Command {
  LookAtCommand(Game game, IOInterface io) : super(game, io);

  @override
  List<String> _listPossibleArgs() {
    List<String> possibleArgs = new List();
    possibleArgs..add("yourself")..add("myself")..add("me");
    possibleArgs..add("inventory");
    game.player.inventory.forEach((BaseGameObject object){
      possibleArgs.add(object.name);
    });
    game.player.wearing.forEach((WearableGameObject object){
      possibleArgs.add(object.name);
    });
    possibleArgs..add("currentroom")..add("room")..add("here")..add(game.plateau.getCurrentRoom().name);
    game.plateau.getCurrentRoom().getNextRooms()?.keys?.forEach((Direction direction){
      possibleArgs.add(direction.toString().substring("Direction.".length, direction.toString().length).toLowerCase());
    });
    game.plateau.getCurrentRoom().getObjects()?.forEach((BaseGameObject object){
      possibleArgs.add(object.name);
    });
    return possibleArgs;
  }

  @override
  void executeCommand(String arg) {
    if (arg.length == 0) return;
    switch (arg) {
      case "yourself":
      case "myself":
      case "me":
        showPlayer();
        break;
      case "inventory":
        showInventory();
        break;
      case "currentroom":
      case "room":
      case "here":
        showCurrentRoom();
        break;
      default:
        processArg(arg);
    }
  }

  void showPlayer() {
    io.writeNewLine("You're ${game.player.name}");
    for (String key in game.player.mapGlobalProperties.keys) {
      io.writeLine("Your ${game.player.getProperty(key).name} is at ${game.player.getProperty(key).value}");
    }
    io.writeNewLine("You're wearing :");
    for (WearableGameObject obj in game.player.wearing){
      io.writeLine("${obj.name} : ${obj.description}");
    }
    io.writeLine("Inventory :");
    for (BaseGameObject obj in game.player.inventory){
      io.writeLine("${obj.name} : ${obj.description}");
    }
  }

  void showInventory(){
    io.writeLine("Inventory :");
    for (BaseGameObject obj in game.player.inventory){
      io.writeLine("${obj.name} : ${obj.description}");
    }
    io.writeNewLine("You're wearing :");
    for (WearableGameObject obj in game.player.wearing){
      io.writeLine("${obj.name} : ${obj.description}");
    }
  }

  void showCurrentRoom(){
    io.writeNewLine("${game.plateau.getCurrentRoom().name} :");
    io.writeNewLine("${game.plateau.getCurrentRoom().getDescription()}");
    io.writeLine("");
    if (game.plateau.getCurrentRoom().getObjects() != null || game.plateau.getCurrentRoom().getObjects().length > 0){
      io.writeString("You see ");
      for (BaseGameObject obj in game.plateau.getCurrentRoom().getObjects()){
        io.writeString("${obj.name}, ${obj.description}, ");
      }
      io.removeChars(2);
    }
    io.writeLine("");
  }

  void showObject(BaseGameObject obj, [isPlayerWearingIt = false]){
    io.writeLine("${obj.name}, ${obj.description}");
    if (isPlayerWearingIt)
      io.writeLine("You're wearing it");
  }

  void showDirection(Direction dir){
    String dirString = dir.toString().substring("Direction.".length, dir.toString().length).toLowerCase();
    io.writeNewLine("$dirString of here, you see ${game.plateau.getCurrentRoom().getNextRooms()[dir].getDescription()}");
  }

  void processArg(String arg){
    if (arg == game.plateau.getCurrentRoom().name){
      showCurrentRoom();
      return;
    }
    game.player.inventory.forEach((BaseGameObject object){
      if (arg == object.name){
        showObject(object);
        return;
      }
    });
    game.player.wearing.forEach((WearableGameObject object){
      if (arg == object.name){
        showObject(object, true);
        return;
      }
    });
    game.plateau.getCurrentRoom().getNextRooms()?.keys?.forEach((Direction direction){
      String dir = direction.toString().substring("Direction.".length, direction.toString().length).toLowerCase();
      if (dir == arg) {
        showDirection(direction);
        return;
      }
    });
    game.plateau.getCurrentRoom().getObjects()?.forEach((BaseGameObject object){
      if (arg == object.name){
        showObject(object);
        return;
      }
    });
  }

}