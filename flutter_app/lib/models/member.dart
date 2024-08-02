class Member {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String? password;

  Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    this.password,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
    );
  }

  String get fullName => '$firstName $lastName';
}
