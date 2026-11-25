class User {
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.city,
  });

  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String city;

  factory User.fromJson(Map<String, dynamic> j) {
    final address = j['address'] as Map<String, dynamic>? ?? const {};
    return User(
      id: j['id'] as int? ?? 0,
      name: j['name'] as String? ?? '',
      username: j['username'] as String? ?? '',
      email: j['email'] as String? ?? '',
      phone: j['phone'] as String? ?? '',
      website: j['website'] as String? ?? '',
      city: address['city'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'username': username,
    'email': email,
    'phone': phone,
    'website': website,
    'address': {'city': city},
  };

  String get phoneDigits =>
      phone.split('x').first.replaceAll(RegExp(r'\D'), '');
}
