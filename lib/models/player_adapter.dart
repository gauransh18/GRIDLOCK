import 'package:hive/hive.dart';
import 'game.dart'; 

class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final int typeId = 1; 

  @override
  Player read(BinaryReader reader) {
    return Player.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    writer.writeInt(obj.index);
  }
} 