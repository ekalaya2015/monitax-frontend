// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Device {
  final String id;
  final String name;
  final String serial_num;
  final String description;
  final double lat;
  final double lon;
  final String status;
  bool isExpanded = false;
  Device({
    required this.id,
    required this.name,
    required this.serial_num,
    required this.description,
    required this.lat,
    required this.lon,
    required this.status,
  });

  Device copyWith({
    String? id,
    String? name,
    String? serial_num,
    String? description,
    double? lat,
    double? lon,
    String? status,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      serial_num: serial_num ?? this.serial_num,
      description: description ?? this.description,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'serial_num': serial_num,
      'description': description,
      'lat': lat,
      'lon': lon,
      'status': status,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'] as String,
      name: map['name'] as String,
      serial_num: map['serial_num'] as String,
      description: map['description'] as String,
      lat: map['lat'] as double,
      lon: map['lon'] as double,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Device.fromJson(String source) =>
      Device.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Device(id: $id, name: $name, serial_num: $serial_num, description: $description, lat: $lat, lon: $lon, status: $status)';
  }

  @override
  bool operator ==(covariant Device other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.serial_num == serial_num &&
        other.description == description &&
        other.lat == lat &&
        other.lon == lon &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        serial_num.hashCode ^
        description.hashCode ^
        lat.hashCode ^
        lon.hashCode ^
        status.hashCode;
  }
}
