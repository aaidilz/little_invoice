class InvoiceItem {
  final int? id;
  final int invoiceId;
  final String description;
  final int quantity;
  final double price;
  final double lineTotal;

  InvoiceItem({
    this.id,
    required this.invoiceId,
    required this.description,
    required this.quantity,
    required this.price,
    required this.lineTotal,
  });

  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      id: map['id'] as int?,
      invoiceId: map['invoice_id'] as int,
      description: map['description'] as String,
      quantity: map['quantity'] as int,
      price: (map['price'] as num).toDouble(),
      lineTotal: (map['line_total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'invoice_id': invoiceId,
      'description': description,
      'quantity': quantity,
      'price': price,
      'line_total': lineTotal,
    };
  }

  InvoiceItem copyWith({
    int? id,
    int? invoiceId,
    String? description,
    int? quantity,
    double? price,
    double? lineTotal,
  }) {
    return InvoiceItem(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      lineTotal: lineTotal ?? this.lineTotal,
    );
  }
}
