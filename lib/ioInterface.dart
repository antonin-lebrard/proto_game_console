library proto_game_console.io_interface;


abstract class IOInterface {

  /**
   * write the string directly into the output
   *
   * No space or line-end before and after the insertion
   */
  void writeString(String string);

  /**
   * write line into the output
   *
   * line-end inserted AFTER the insertion
   */
  void writeLine(String line);

  /**
   * write line into the output
   *
   * line-end inserted BEFORE and AFTER insertion
   */
  void writeNewLine(String line);

  /**
   * remove nb chars from the output
   */
  void removeChars(int nb);

  /**
   * ask to read a line from input
   */
  String readLine();

  /**
   * clear the output
   */
  void clear();

}