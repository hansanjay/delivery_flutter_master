class Profile {
  final int id;
  final int distributorId;
  final String mobile;
  final String email;
  final String firstName;
  final String lastName;
  final String panCard;
  final String aadharCard;
  final bool active;
  final DateTime verificationExpiry;

  Profile({
    required this.id,
    required this.distributorId,
    required this.mobile,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.panCard,
    required this.aadharCard,
    required this.active,
    required this.verificationExpiry,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      distributorId: json['distributor_id'],
      mobile: json['mobile'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      panCard: json['pan_card'],
      aadharCard: json['aadhar_card'],
      active: json['active'],
      verificationExpiry: DateTime.parse(json['verification_expiry']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'distributor_id': distributorId,
      'mobile': mobile,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'pan_card': panCard,
      'aadhar_card': aadharCard,
      'active': active,
      'verification_expiry': verificationExpiry.toIso8601String(),
    };
  }
}
