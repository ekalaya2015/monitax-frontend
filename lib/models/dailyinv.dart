// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:monitax/models/invoice.dart';

class DailyInvoice {
  String username;
  double total;
  double tax;
  int count;
  List<Invoice> invoices;
  DailyInvoice({
    required this.username,
    required this.total,
    required this.tax,
    required this.count,
    required this.invoices,
  });

  DailyInvoice copyWith({
    String? username,
    double? total,
    double? tax,
    int? count,
    List<Invoice>? invoices,
  }) {
    return DailyInvoice(
      username: username ?? this.username,
      total: total ?? this.total,
      tax: tax ?? this.tax,
      count: count ?? this.count,
      invoices: invoices ?? this.invoices,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'total': total,
      'tax': tax,
      'count': count,
      'invoices': invoices.map((x) => x.toMap()).toList(),
    };
  }

  factory DailyInvoice.fromMap(Map<String, dynamic> map) {
    List<Invoice> list = [];
    for (final element in map['invoices']) {
      list.add(Invoice.fromMap(element));
    }
    return DailyInvoice(
        username: map['username'] as String,
        total: map['total'] as double,
        tax: map['tax'] as double,
        count: map['count'] as int,
        invoices: list);
  }

  String toJson() => json.encode(toMap());

  factory DailyInvoice.fromJson(String source) =>
      DailyInvoice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DailyInvoice(username: $username, total: $total, tax: $tax, count: $count, invoices: $invoices)';
  }

  @override
  bool operator ==(covariant DailyInvoice other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.total == total &&
        other.tax == tax &&
        other.count == count &&
        listEquals(other.invoices, invoices);
  }

  @override
  int get hashCode {
    return username.hashCode ^
        total.hashCode ^
        tax.hashCode ^
        count.hashCode ^
        invoices.hashCode;
  }
}
