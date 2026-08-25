class User {
  const User({
    required this.id,
    required this.mobileNumber,
    this.name,
  });

  final String id;
  final String mobileNumber;
  final String? name;
}
