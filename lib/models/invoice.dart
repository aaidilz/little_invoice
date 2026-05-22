enum InvoiceStatus { paid, unpaid }

class Invoice {
  final int? id;
  final int sellerId;
  final int buyerId;
  final String invoiceNumber;
  final String cityDate;
  final DateTime dueDate;
  final InvoiceStatus status;
  final double subtotal;
  final double discount;
  final double tax;
  final double dp;
  final double total;
  final String? notes;

  Invoice({
    this.id,
    required this.sellerId,
    required this.buyerId,
    required this.invoiceNumber,
    required this.cityDate,
    required this.dueDate,
    required this.status,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.dp,
    required this.total,
    this.notes,
  });

  /// Creates a sentinel invoice with null [id], used as a safe fallback
  /// for `firstWhere(..., orElse: () => Invoice.empty())`.
  factory Invoice.empty() => Invoice(
        sellerId: 0,
        buyerId: 0,
        invoiceNumber: '',
        cityDate: '',
        dueDate: DateTime(1970),
        status: InvoiceStatus.unpaid,
        subtotal: 0,
        discount: 0,
        tax: 0,
        dp: 0,
        total: 0,
      );

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'] as int?,
      sellerId: map['seller_id'] as int,
      buyerId: map['buyer_id'] as int,
      invoiceNumber: map['invoice_number'] as String,
      cityDate: map['city_date'] as String,
      dueDate: DateTime.parse(map['due_date'] as String),
      status: map['status'] == 'paid' ? InvoiceStatus.paid : InvoiceStatus.unpaid,
      subtotal: (map['subtotal'] as num).toDouble(),
      discount: (map['discount'] as num).toDouble(),
      tax: (map['tax'] as num).toDouble(),
      dp: (map['dp'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'seller_id': sellerId,
      'buyer_id': buyerId,
      'invoice_number': invoiceNumber,
      'city_date': cityDate,
      'due_date': dueDate.toIso8601String(),
      'status': status.name,
      'subtotal': subtotal,
      'discount': discount,
      'tax': tax,
      'dp': dp,
      'total': total,
      'notes': notes,
    };
  }

  Invoice copyWith({
    int? id,
    int? sellerId,
    int? buyerId,
    String? invoiceNumber,
    String? cityDate,
    DateTime? dueDate,
    InvoiceStatus? status,
    double? subtotal,
    double? discount,
    double? tax,
    double? dp,
    double? total,
    String? notes,
  }) {
    return Invoice(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      buyerId: buyerId ?? this.buyerId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      cityDate: cityDate ?? this.cityDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      dp: dp ?? this.dp,
      total: total ?? this.total,
      notes: notes ?? this.notes,
    );
  }
}
