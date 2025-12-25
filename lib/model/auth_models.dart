class UserModel {
  final String id;
  final String name;
  final String lastName;
  final String username;
  final String email;
  final String userType;

  const UserModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.username,
    required this.email,
    required this.userType,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      lastName: map['lastName']?.toString() ?? '',
      username: map['username']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      userType: map['userType']?.toString() ?? '',
    );
  }
}

class AuthData {
  final UserModel user;
  final String token;

  const AuthData({required this.user, required this.token});
}

class AuthResponse {
  final bool success;
  final String? message;
  final AuthData? data;

  const AuthResponse({required this.success, this.message, this.data});

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    final success = map['success'] == true;
    final message = map['message']?.toString();
    AuthData? data;

    final dataMap = map['data'];
    if (dataMap is Map<String, dynamic>) {
      final user = UserModel.fromMap(dataMap);
      final token = dataMap['token']?.toString() ?? '';
      data = AuthData(user: user, token: token);
    }

    return AuthResponse(success: success, message: message, data: data);
  }
}
