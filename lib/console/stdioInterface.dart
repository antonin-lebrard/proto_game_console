part of proto_game_console.console;


class StdIOInterface extends IOInterface {

  @override
  void writeString(String string) {
    stdout.write(string);
  }

  @override
  void writeLine(String line) {
    stdout.writeln(line);
  }

  @override
  void writeNewLine(String line) {
    stdout.writeln("");
    stdout.writeln(line);
  }

  @override
  void removeChars(int nb){
    for (int i = 0; i < nb; i++){
      stdout.write(LATIN1.decode([8]));
      stdout.write(" ");
      stdout.write(LATIN1.decode([8]));
    }
  }

  @override
  String readLine() {
    return stdin.readLineSync();
  }

  @override
  void clear() {
    for (int i = 0; i < stdout.terminalLines; i++){
      stdout.writeln("");
    }
  }


}

