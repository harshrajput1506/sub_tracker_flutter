// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_rates_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrencyRatesModelAdapter extends TypeAdapter<CurrencyRatesModel> {
  @override
  final int typeId = 3;

  @override
  CurrencyRatesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrencyRatesModel(
      rates: (fields[0] as Map).cast<String, double>(),
      lastUpdated: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CurrencyRatesModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.rates)
      ..writeByte(1)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyRatesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
