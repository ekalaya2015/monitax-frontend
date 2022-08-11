// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'package:monitax/models/device.dart';

class Area {
  int provinsi_id;
  int kota_id;
  int kecamatan_id;
  int kelurahan_id;
  Area({
    required this.provinsi_id,
    required this.kota_id,
    required this.kecamatan_id,
    required this.kelurahan_id,
  });

  Area copyWith({
    int? provinsi_id,
    int? kota_id,
    int? kecamatan_id,
    int? kelurahan_id,
  }) {
    return Area(
      provinsi_id: provinsi_id ?? this.provinsi_id,
      kota_id: kota_id ?? this.kota_id,
      kecamatan_id: kecamatan_id ?? this.kecamatan_id,
      kelurahan_id: kelurahan_id ?? this.kelurahan_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'provinsi_id': provinsi_id,
      'kota_id': kota_id,
      'kecamatan_id': kecamatan_id,
      'kelurahan_id': kelurahan_id,
    };
  }

  factory Area.fromMap(Map<String, dynamic> map) {
    return Area(
      provinsi_id: map['provinsi_id'] as int,
      kota_id: map['kota_id'] as int,
      kecamatan_id: map['kecamatan_id'] as int,
      kelurahan_id: map['kelurahan_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Area.fromJson(String source) =>
      Area.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Area(provinsi_id: $provinsi_id, kota_id: $kota_id, kecamatan_id: $kecamatan_id, kelurahan_id: $kelurahan_id)';
  }

  @override
  bool operator ==(covariant Area other) {
    if (identical(this, other)) return true;

    return other.provinsi_id == provinsi_id &&
        other.kota_id == kota_id &&
        other.kecamatan_id == kecamatan_id &&
        other.kelurahan_id == kelurahan_id;
  }

  @override
  int get hashCode {
    return provinsi_id.hashCode ^
        kota_id.hashCode ^
        kecamatan_id.hashCode ^
        kelurahan_id.hashCode;
  }
}

class User {
  final String id;
  final String nik;
  final String first_name;
  final String last_name;
  final String username;
  final String picture;
  final String address;
  final String phone_no;
  final String role;
  final Area area;
  final List<Device> devices;
  User({
    required this.id,
    required this.nik,
    required this.first_name,
    required this.last_name,
    required this.username,
    required this.picture,
    required this.address,
    required this.phone_no,
    required this.role,
    required this.area,
    required this.devices,
  });

  User copyWith({
    String? id,
    String? nik,
    String? first_name,
    String? last_name,
    String? username,
    String? picture,
    String? address,
    String? phone_no,
    String? role,
    Area? area,
    List<Device>? devices,
  }) {
    return User(
      id: id ?? this.id,
      nik: nik ?? this.nik,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      username: username ?? this.username,
      picture: picture ?? this.picture,
      address: address ?? this.address,
      phone_no: phone_no ?? this.phone_no,
      role: role ?? this.role,
      area: area ?? this.area,
      devices: devices ?? this.devices,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nik': nik,
      'first_name': first_name,
      'last_name': last_name,
      'username': username,
      'picture': picture,
      'address': address,
      'phone_no': phone_no,
      'role': role,
      'area': area.toMap(),
      'devices': devices.map((x) => x.toMap()).toList(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    List<Device> list = [];
    for (final element in map['devices']) {
      list.add(Device.fromMap(element));
    }
    return User(
        id: map['id'] as String,
        nik: map['nik'] as String,
        first_name: map['first_name'] as String,
        last_name: map['last_name'] as String,
        username: map['username'] as String,
        picture: map['picture'] as String,
        address: map['address'] as String,
        phone_no: map['phone_no'] as String,
        role: map['role'] as String,
        area: Area.fromMap(map['area'] as Map<String, dynamic>),
        devices: list);
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, nik: $nik, first_name: $first_name, last_name: $last_name, username: $username, picture: $picture, address: $address, phone_no: $phone_no, role: $role, area: $area, devices: $devices)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nik == nik &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.username == username &&
        other.picture == picture &&
        other.address == address &&
        other.phone_no == phone_no &&
        other.role == role &&
        other.area == area &&
        listEquals(other.devices, devices);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nik.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        username.hashCode ^
        picture.hashCode ^
        address.hashCode ^
        phone_no.hashCode ^
        role.hashCode ^
        area.hashCode ^
        devices.hashCode;
  }
}
