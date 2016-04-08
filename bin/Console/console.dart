part of proto_game_console.console;

class Console {

  StreamSubscription subscription;

  ConsoleLine currentLine = new ConsoleLine();

  Stream<ConsoleLine> onEnter;
  StreamController _onEnter;
  Stream<ConsoleLine> onTab;
  StreamController _onTab;
  Stream<ConsoleLine> onSpace;
  StreamController _onSpace;
  Stream<ConsoleLine> onReturn;
  StreamController _onReturn;
  Stream<ConsoleLine> onChar;
  StreamController _onChar;

  Console(){
    stdin.echoMode = false;
    stdin.lineMode = false;
    _onEnter = new StreamController.broadcast();
    onEnter = _onEnter.stream;
    _onTab = new StreamController.broadcast();
    onTab = _onTab.stream;
    _onSpace = new StreamController.broadcast();
    onSpace = _onSpace.stream;
    _onReturn = new StreamController.broadcast();
    onReturn = _onReturn.stream;
    _onChar = new StreamController.broadcast();
    onChar = _onChar.stream;
  }

  Future<ConsoleLine> readLine() {
    Completer<ConsoleLine> completer = new Completer();
    if (subscription == null)
      beginInput();
    onEnter.first.then((ConsoleLine line){
      completer.complete(line);
    });
    return completer.future;
  }

  void beginInput(){
    subscription = stdin.listen((List<int> codeUnits){
      if (codeUnits.contains(9)) {  /// TAB
        _onTab.add(currentLine);
      }
      else if (codeUnits.contains(13)) { /// Enter
        _onEnter.add(currentLine);
        currentLine = new ConsoleLine();
        stdout.writeln();
      }
      else if (codeUnits.contains(32)) { /// Space
        if (!currentLine.commandComplete)
          currentLine.commandComplete = true;
        _onSpace.add(currentLine);
        stdout.write(' ');
      }
      else if (codeUnits.contains(8)) {  /// Return
        currentLine.deleteChar();
        stdout.write(LATIN1.decode(codeUnits));
        stdout.write(' ');
        stdout.write(LATIN1.decode(codeUnits));
        _onReturn.add(currentLine);
      }
      else {
        try {
          String char = LATIN1.decode(codeUnits);
          currentLine.addChar(char);
          stdout.write(char);
          _onChar.add(currentLine);
        } catch (e) {}
      }
    });
  }

  void stopInput() {
    if (subscription != null) {
      subscription.cancel()?.then((_){
        subscription = null;
      });
    }
  }

}

class ConsoleLine {

  String command = "";
  String arg = "";

  bool commandComplete = false;

  String toString(){
    if (arg.length > 0)
      return command + " " + arg;
    return command;
  }

  void deleteChar(){
    if (arg.length > 0)
      arg = arg.substring(0, arg.length - 1);
    else if (command.length > 0) {
      command = command.substring(0, command.length - 1);
      commandComplete = false;
    }
  }

  void addChar(String char){
    if (!commandComplete) command += char;
    else arg += char;
  }

}