// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameHistoryAdapter extends TypeAdapter<GameHistory> {
  @override
  final int typeId = 0;

  @override
  GameHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameHistory(
      (fields[0] as List)
          .map((dynamic e) => (e as List).cast<Player?>())
          .toList(),
      fields[1] as Player?,
      fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GameHistory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.board)
      ..writeByte(1)
      ..write(obj.winner)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
