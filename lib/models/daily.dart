// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Daily {
  final double sales;
  final double tax;
  final int trx;
  Daily({
    required this.sales,
    required this.tax,
    required this.trx,
  });

  Daily copyWith({
    double? sales,
    double? tax,
    int? trx,
  }) {
    return Daily(
      sales: sales ?? this.sales,
      tax: tax ?? this.tax,
      trx: trx ?? this.trx,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sales': sales,
      'tax': tax,
      'trx': trx,
    };
  }

  factory Daily.fromMap(Map<String, dynamic> map) {
    return Daily(
      sales: map['sales'] as double,
      tax: map['tax'] as double,
      trx: map['trx'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Daily.fromJson(String source) =>
      Daily.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Daily(sales: $sales, tax: $tax, trx: $trx)';

  @override
  bool operator ==(covariant Daily other) {
    if (identical(this, other)) return true;

    return other.sales == sales && other.tax == tax && other.trx == trx;
  }

  @override
  int get hashCode => sales.hashCode ^ tax.hashCode ^ trx.hashCode;
}
