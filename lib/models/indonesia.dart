// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Provinsi {
  int prov_id;
  String prov_name;
  int locationid;
  int status;
  Provinsi({
    required this.prov_id,
    required this.prov_name,
    required this.locationid,
    required this.status,
  });

  Provinsi copyWith({
    int? prov_id,
    String? prov_name,
    int? locationid,
    int? status,
  }) {
    return Provinsi(
      prov_id: prov_id ?? this.prov_id,
      prov_name: prov_name ?? this.prov_name,
      locationid: locationid ?? this.locationid,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'prov_id': prov_id,
      'prov_name': prov_name,
      'locationid': locationid,
      'status': status,
    };
  }

  factory Provinsi.fromMap(Map<String, dynamic> map) {
    return Provinsi(
      prov_id: map['prov_id'] as int,
      prov_name: map['prov_name'] as String,
      locationid: map['locationid'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Provinsi.fromJson(String source) =>
      Provinsi.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Provinsi(prov_id: $prov_id, prov_name: $prov_name, locationid: $locationid, status: $status)';
  }

  @override
  bool operator ==(covariant Provinsi other) {
    if (identical(this, other)) return true;

    return other.prov_id == prov_id &&
        other.prov_name == prov_name &&
        other.locationid == locationid &&
        other.status == status;
  }

  @override
  int get hashCode {
    return prov_id.hashCode ^
        prov_name.hashCode ^
        locationid.hashCode ^
        status.hashCode;
  }
}

class Kota {
  int city_id;
  String city_name;

  Kota({
    required this.city_id,
    required this.city_name,
  });

  Kota copyWith({
    int? city_id,
    String? city_name,
  }) {
    return Kota(
      city_id: city_id ?? this.city_id,
      city_name: city_name ?? this.city_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'city_id': city_id,
      'city_name': city_name,
    };
  }

  factory Kota.fromMap(Map<String, dynamic> map) {
    return Kota(
      city_id: map['city_id'] as int,
      city_name: map['city_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Kota.fromJson(String source) =>
      Kota.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Kota(city_id: $city_id, city_name: $city_name)';

  @override
  bool operator ==(covariant Kota other) {
    if (identical(this, other)) return true;

    return other.city_id == city_id && other.city_name == city_name;
  }

  @override
  int get hashCode => city_id.hashCode ^ city_name.hashCode;
}

class Kecamatan {
  int dis_id;
  String dis_name;

  Kecamatan({
    required this.dis_id,
    required this.dis_name,
  });

  Kecamatan copyWith({
    int? dis_id,
    String? dis_name,
  }) {
    return Kecamatan(
      dis_id: dis_id ?? this.dis_id,
      dis_name: dis_name ?? this.dis_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dis_id': dis_id,
      'dis_name': dis_name,
    };
  }

  factory Kecamatan.fromMap(Map<String, dynamic> map) {
    return Kecamatan(
      dis_id: map['dis_id'] as int,
      dis_name: map['dis_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Kecamatan.fromJson(String source) =>
      Kecamatan.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Kecamatan(dis_id: $dis_id, dis_name: $dis_name)';

  @override
  bool operator ==(covariant Kecamatan other) {
    if (identical(this, other)) return true;

    return other.dis_id == dis_id && other.dis_name == dis_name;
  }

  @override
  int get hashCode => dis_id.hashCode ^ dis_name.hashCode;
}

class Kelurahan {
  int subdis_id;
  String subdis_name;

  Kelurahan({
    required this.subdis_id,
    required this.subdis_name,
  });

  Kelurahan copyWith({
    int? subdis_id,
    String? subdis_name,
  }) {
    return Kelurahan(
      subdis_id: subdis_id ?? this.subdis_id,
      subdis_name: subdis_name ?? this.subdis_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subdis_id': subdis_id,
      'subdis_name': subdis_name,
    };
  }

  factory Kelurahan.fromMap(Map<String, dynamic> map) {
    return Kelurahan(
      subdis_id: map['subdis_id'] as int,
      subdis_name: map['subdis_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Kelurahan.fromJson(String source) =>
      Kelurahan.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Kelurahan(subdis_id: $subdis_id, subdis_name: $subdis_name)';

  @override
  bool operator ==(covariant Kelurahan other) {
    if (identical(this, other)) return true;

    return other.subdis_id == subdis_id && other.subdis_name == subdis_name;
  }

  @override
  int get hashCode => subdis_id.hashCode ^ subdis_name.hashCode;
}
