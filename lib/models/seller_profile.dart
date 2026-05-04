class SellerProfile {
  final int? id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String bank;
  final String? logoPath;
  final String? stampPath;
  final String? signaturePath;

  SellerProfile({
    this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.bank,
    this.logoPath,
    this.stampPath,
    this.signaturePath,
  });

  factory SellerProfile.fromMap(Map<String, dynamic> map) {
    return SellerProfile(
      id: map['id'] as int?,
      name: map['name'] as String,
      address: map['address'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      bank: map['bank'] as String,
      logoPath: map['logo_path'] as String?,
      stampPath: map['stamp_path'] as String?,
      signaturePath: map['signature_path'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'bank': bank,
      'logo_path': logoPath,
      'stamp_path': stampPath,
      'signature_path': signaturePath,
    };
  }

  SellerProfile copyWith({
    int? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    String? bank,
    String? logoPath,
    String? stampPath,
    String? signaturePath,
  }) {
    return SellerProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      bank: bank ?? this.bank,
      logoPath: logoPath ?? this.logoPath,
      stampPath: stampPath ?? this.stampPath,
      signaturePath: signaturePath ?? this.signaturePath,
    );
  }
}
