class AuthResponse {
  final String token;
  final DateTime tokenExpiration; // Keep this as DateTime
  final String refreshToken;
  final bool passwordChanged;
  final bool isAdminRole;
  final bool active;
  final bool locked;
  final String otpRequired;
  final String email;
  final String mobileNo;
  final String username;
  final String firstName;
  final String otherNames;
  final String roles;

  AuthResponse({
    required this.token,
    required this.tokenExpiration,
    required this.refreshToken,
    required this.passwordChanged,
    required this.isAdminRole,
    required this.active,
    required this.locked,
    required this.otpRequired,
    required this.email,
    required this.mobileNo,
    required this.username,
    required this.firstName,
    required this.otherNames,
    required this.roles,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> j) {
    return AuthResponse(
      token: j['token'] as String,
      tokenExpiration: DateTime.parse(j['tokenExpiration'] as String),
      refreshToken: j['refreshToken'] as String,
      passwordChanged: j['passwordchanged'] as bool,
      isAdminRole: j['isAdminRole'] as bool,
      active: j['active'] as bool,
      locked: j['locked'] as bool,
      otpRequired: j['otpRequired']?.toString() ?? "0", // Default to "0"
      email: j['email'] as String? ?? '',
      mobileNo: j['mobileno'] as String? ?? '',
      username: j['username'] as String? ?? '',
      firstName: j['firstname'] as String? ?? '',
      otherNames: j['othernames'] as String? ?? '',
      roles: j['roles'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'tokenExpiration': tokenExpiration
            .toUtc()
            .toIso8601String(), // Convert DateTime to String
        'refreshToken': refreshToken,
        'passwordchanged': passwordChanged,
        'isAdminRole': isAdminRole,
        'active': active,
        'locked': locked,
        'otpRequired': otpRequired,
        'email': email,
        'mobileno': mobileNo,
        'username': username,
        'firstname': firstName,
        'othernames': otherNames,
        'roles': roles,
      };
}
