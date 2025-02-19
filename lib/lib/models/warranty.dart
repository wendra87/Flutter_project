class Warranty {
  int? id;
  String warrantyCode;
  String name;
  String phone;
  String damage;
  int warrantyDuration;
  DateTime expiryDate;

  Warranty({
    this.id,
    required this.warrantyCode,
    required this.name,
    required this.phone,
    required this.damage,
    required this.warrantyDuration,
    required this.expiryDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'warrantyCode': warrantyCode,
      'name': name,
      'phone': phone,
      'damage': damage,
      'warrantyDuration': warrantyDuration,
      'expiryDate': expiryDate.toIso8601String(),
      if (id != null) 'id': id,
    };
  }

  factory Warranty.fromMap(Map<String, dynamic> map) {
    return Warranty(
      id: map['id'],
      warrantyCode: map['warrantyCode'],
      name: map['name'],
      phone: map['phone'],
      damage: map['damage'],
      warrantyDuration: map['warrantyDuration'],
      expiryDate: DateTime.parse(map['expiryDate']),
    );
  }
}
