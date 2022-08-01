// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class KPI {
  String date;
  double total;
  double tax;
  int trx;
  KPI({
    required this.date,
    required this.total,
    required this.tax,
    required this.trx,
  });

  KPI copyWith({
    String? date,
    double? total,
    double? tax,
    int? trx,
  }) {
    return KPI(
      date: date ?? this.date,
      total: total ?? this.total,
      tax: tax ?? this.tax,
      trx: trx ?? this.trx,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'total': total,
      'tax': tax,
      'trx': trx,
    };
  }

  factory KPI.fromMap(Map<String, dynamic> map) {
    return KPI(
      date: map['date'] as String,
      total: map['total'] as double,
      tax: map['tax'] as double,
      trx: map['trx'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory KPI.fromJson(String source) =>
      KPI.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'KPI(date: $date, total: $total, tax: $tax, trx: $trx)';
  }

  @override
  bool operator ==(covariant KPI other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        other.total == total &&
        other.tax == tax &&
        other.trx == trx;
  }

  @override
  int get hashCode {
    return date.hashCode ^ total.hashCode ^ tax.hashCode ^ trx.hashCode;
  }
}
