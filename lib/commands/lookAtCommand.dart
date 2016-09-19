part of proto_game_console.command;


class LookAtCommand extends GameCommand {
  LookAtCommand(Game game) : super(game, "lookat");

  @override
  List<String> listPossibleArgs() {
    List<String> possibleArgs = new List();
    possibleArgs..add("yourself")..add("myself")..add("me");
    possibleArgs..add("inventory");
    game.player.inventory.forEach((BaseGameObject object){
      possibleArgs.add(object.name);
    });
    game.player.wearing.forEach((WearableGameObject object){
      possibleArgs.add(object.name);
    });
    possibleArgs..add("currentroom")..add("room")..add("here")..add(game.player.plateau.getCurrentRoom().name);
    game.player.plateau.getCurrentRoom().getNextRooms()?.keys?.forEach((Direction direction){
      possibleArgs.add(direction.toString().substring("Direction.".length, direction.toString().length).toLowerCase());
    });
    game.player.plateau.getCurrentRoom().getObjects()?.forEach((BaseGameObject object){
      possibleArgs.add(object.name);
    });
    return possibleArgs;
  }

  @override
  void executeCommand(String arg, Stdio io) {
    if (arg.length == 0) return;
    switch (arg) {
      case "yourself":
      case "myself":
      case "me":
        showPlayer(io);
        break;
      case "inventory":
        showInventory(io);
        break;
      case "currentroom":
      case "room":
      case "here":
        showCurrentRoom(io);
        break;
      default:
        processArg(io, arg);
    }
  }

  void showPlayer(Stdio io) {
    io.writeNewLine("You're ${game.player.name}");
    for (String key in game.player.properties.keys) {
      io.writeLine("Your ${game.player.getProperty(key).name} is at ${game.player.getProperty(key).getValue()}");
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

  void showInventory(Stdio io){
    io.writeLine("Inventory :");
    for (BaseGameObject obj in game.player.inventory){
      io.writeLine("${obj.name} : ${obj.description}");
    }
    io.writeNewLine("You're wearing :");
    for (WearableGameObject obj in game.player.wearing){
      io.writeLine("${obj.name} : ${obj.description}");
    }
  }

  void showCurrentRoom(Stdio io){
    io.writeNewLine("${game.player.plateau.getCurrentRoom().name} :");
    io.writeNewLine("${game.player.plateau.getCurrentRoom().getDescription()}");
    io.writeLine("");
    if (game.player.plateau.getCurrentRoom().getObjects() != null || game.player.plateau.getCurrentRoom().getObjects().length > 0){
      io.writeString("You see ");
      for (BaseGameObject obj in game.player.plateau.getCurrentRoom().getObjects()){
        io.writeString("${obj.name}, ${obj.description}, ");
      }
      io.removeChars(2);
    }
    io.writeLine("");
  }

  void showObject(Stdio io, BaseGameObject obj, [isPlayerWearingIt = false]){
    io.writeLine("${obj.name}, ${obj.description}");
    if (isPlayerWearingIt)
      io.writeLine("You're wearing it");
  }

  void showDirection(Stdio io, Direction dir){
    String dirString = dir.toString().substring("Direction.".length, dir.toString().length).toLowerCase();
    io.writeNewLine("$dirString of here, you see ${game.player.plateau.getCurrentRoom().getNextRooms()[dir].getDescription()}");
  }

  void processArg(Stdio io, String arg){
    if (arg == game.player.plateau.getCurrentRoom().name){
      showCurrentRoom(io);
      return;
    }
    game.player.inventory.forEach((BaseGameObject object){
      if (arg == object.name){
        showObject(io, object);
        return;
      }
    });
    game.player.wearing.forEach((WearableGameObject object){
      if (arg == object.name){
        showObject(io, object, true);
        return;
      }
    });
    game.player.plateau.getCurrentRoom().getNextRooms()?.keys?.forEach((Direction direction){
      String dir = direction.toString().substring("Direction.".length, direction.toString().length).toLowerCase();
      if (dir == arg) {
        showDirection(io, direction);
        return;
      }
    });
    game.player.plateau.getCurrentRoom().getObjects()?.forEach((BaseGameObject object){
      if (arg == object.name){
        showObject(io, object);
        return;
      }
    });
  }

}