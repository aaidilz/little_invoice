class Buyer {
  final int? id;
  final String name;
  final String address;
  final String phone;
  final String email;

  Buyer({
    this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
  });

  factory Buyer.fromMap(Map<String, dynamic> map) {
    return Buyer(
      id: map['id'] as int?,
      name: map['name'] as String,
      address: map['address'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
    };
  }

  Buyer copyWith({
    int? id,
    String? name,
    String? address,
    String? phone,
    String? email,
  }) {
    return Buyer(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Buyer) return false;
    if (id != null && other.id != null) {
      return id == other.id;
    }
    return name == other.name &&
        address == other.address &&
        phone == other.phone &&
        email == other.email;
  }

  @override
  int get hashCode {
    if (id != null) return id.hashCode;
    return Object.hash(name, address, phone, email);
  }
}
