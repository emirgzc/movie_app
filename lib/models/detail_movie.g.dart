// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_movie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DetailMovieAdapter extends TypeAdapter<DetailMovie> {
  @override
  final int typeId = 1;

  @override
  DetailMovie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DetailMovie(
      backdropPath: fields[0] as String?,
      id: fields[1] as int?,
      originalTitle: fields[2] as String?,
      overview: fields[3] as String?,
      popularity: fields[4] as double?,
      posterPath: fields[5] as String?,
      releaseDate: fields[6] as DateTime?,
      tagline: fields[7] as String?,
      title: fields[8] as String?,
      voteAverage: fields[9] as double?,
      voteCount: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DetailMovie obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.backdropPath)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.originalTitle)
      ..writeByte(3)
      ..write(obj.overview)
      ..writeByte(4)
      ..write(obj.popularity)
      ..writeByte(5)
      ..write(obj.posterPath)
      ..writeByte(6)
      ..write(obj.releaseDate)
      ..writeByte(7)
      ..write(obj.tagline)
      ..writeByte(8)
      ..write(obj.title)
      ..writeByte(9)
      ..write(obj.voteAverage)
      ..writeByte(10)
      ..write(obj.voteCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetailMovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
