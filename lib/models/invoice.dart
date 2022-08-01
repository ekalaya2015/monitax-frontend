// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Invoice {
  String device_name;

  String invoice_num;
  String invoice_date;
  double total_value;
  double tax_value;
  Invoice({
    required this.device_name,
    required this.invoice_num,
    required this.invoice_date,
    required this.total_value,
    required this.tax_value,
  });

  Invoice copyWith({
    String? device_name,
    String? invoice_num,
    String? invoice_date,
    double? total_value,
    double? tax_value,
  }) {
    return Invoice(
      device_name: device_name ?? this.device_name,
      invoice_num: invoice_num ?? this.invoice_num,
      invoice_date: invoice_date ?? this.invoice_date,
      total_value: total_value ?? this.total_value,
      tax_value: tax_value ?? this.tax_value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'device_name': device_name,
      'invoice_num': invoice_num,
      'invoice_date': invoice_date,
      'total_value': total_value,
      'tax_value': tax_value,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      device_name: map['device_name'] as String,
      invoice_num: map['invoice_num'] as String,
      invoice_date: map['invoice_date'] as String,
      total_value: map['total_value'] as double,
      tax_value: map['tax_value'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Invoice.fromJson(String source) =>
      Invoice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Invoice(device_name: $device_name, invoice_num: $invoice_num, invoice_date: $invoice_date, total_value: $total_value, tax_value: $tax_value)';
  }

  @override
  bool operator ==(covariant Invoice other) {
    if (identical(this, other)) return true;

    return other.device_name == device_name &&
        other.invoice_num == invoice_num &&
        other.invoice_date == invoice_date &&
        other.total_value == total_value &&
        other.tax_value == tax_value;
  }

  @override
  int get hashCode {
    return device_name.hashCode ^
        invoice_num.hashCode ^
        invoice_date.hashCode ^
        total_value.hashCode ^
        tax_value.hashCode;
  }
}
