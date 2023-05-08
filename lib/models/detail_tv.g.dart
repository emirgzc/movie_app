// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_tv.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TvDetailAdapter extends TypeAdapter<TvDetail> {
  @override
  final int typeId = 2;

  @override
  TvDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TvDetail(
      backdropPath: fields[0] as String?,
      firstAirDate: fields[1] as DateTime?,
      id: fields[2] as int?,
      name: fields[3] as String?,
      originalName: fields[4] as String?,
      posterPath: fields[5] as String?,
      voteAverage: fields[6] as double?,
      voteCount: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, TvDetail obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.backdropPath)
      ..writeByte(1)
      ..write(obj.firstAirDate)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.originalName)
      ..writeByte(5)
      ..write(obj.posterPath)
      ..writeByte(6)
      ..write(obj.voteAverage)
      ..writeByte(7)
      ..write(obj.voteCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TvDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
