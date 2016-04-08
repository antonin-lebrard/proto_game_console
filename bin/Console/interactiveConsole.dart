part of proto_game_console.console;

class InteractiveConsole extends Console {

  Map<int, List<String>> currentCompletion;
  List<int> currentScores;

  CommandMap commandsMap;

  InteractiveConsole(Game game){
    onTab.listen(waitForPossibleInput);
    onEnter.listen(executeCommand);
    commandsMap = new CommandMap(game);
  }

  void waitForPossibleInput(ConsoleLine line){
    bool tabPressed = false;
    var sub = onTab.listen((ConsoleLine line) {
      tabPressed = true;
      listAutoCompletionPossibilities(line);
    });
    new Timer(new Duration(milliseconds: 100), (){
      sub.cancel();
      if (!tabPressed)
        autoComplete(line);
    });
  }

  void autoComplete(ConsoleLine line){
    if (commandsMap[currentLine.command] == null) return;
    currentCompletion = commandsMap[currentLine.command].autoCompleteArg(currentLine.arg);
    if (currentCompletion.keys.length == 0) return;
    String maxCommuneString = currentCompletion[currentCompletion.keys.first][0];
    for (int key in currentCompletion.keys){
      for (String completion in currentCompletion[key]){
        if (completion.length < maxCommuneString.length)
          maxCommuneString = maxCommuneString.substring(0, completion.length);
        for (int i = 0; i < maxCommuneString.length; i++){
          if (completion[i] != maxCommuneString[i]){
            maxCommuneString = maxCommuneString.substring(0, i);
            break;
          }
        }
      }
    }
    stdout.write(maxCommuneString.substring(line.arg.length));
    line.arg = maxCommuneString;
  }

  void listAutoCompletionPossibilities(ConsoleLine line){

  }

  void executeCommand(ConsoleLine line){
    Command command;
    for (String key in commandsMap.commands.keys){
      if (key == line.command){
        command = commandsMap[key];
        break;
      }
    }
    if (command == null) return;
    command.executeCommand(line.arg);
  }

}