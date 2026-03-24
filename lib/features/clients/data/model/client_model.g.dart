// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'client_model.dart';

// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************

// class ClientModelAdapter extends TypeAdapter<ClientModel> {
//   @override
//   final int typeId = 1;

//   @override
//   ClientModel read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return ClientModel(
//       id: fields[0] as int,
//       name: fields[1] as String,
//       placeName: fields[2] as String,
//       area: fields[3] as String,
//       email: fields[4] as String,
//       phone: fields[5] as String,
//       details: fields[6] as String,
//       location: fields[7] as String?,
//       visitDetails: fields[8] as String?,
//       date: fields[9] as String?,
//       time: fields[10] as String?,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, ClientModel obj) {
//     writer
//       ..writeByte(11)
//       ..writeByte(0)
//       ..write(obj.id)
//       ..writeByte(1)
//       ..write(obj.name)
//       ..writeByte(2)
//       ..write(obj.placeName)
//       ..writeByte(3)
//       ..write(obj.area)
//       ..writeByte(4)
//       ..write(obj.email)
//       ..writeByte(5)
//       ..write(obj.phone)
//       ..writeByte(6)
//       ..write(obj.details)
//       ..writeByte(7)
//       ..write(obj.location)
//       ..writeByte(8)
//       ..write(obj.visitDetails)
//       ..writeByte(9)
//       ..write(obj.date)
//       ..writeByte(10)
//       ..write(obj.time);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is ClientModelAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
