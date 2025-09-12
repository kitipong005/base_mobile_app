import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'base_response.dart';

part 'auth_models.g.dart';

class LoginRequest extends Equatable {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  @override
  List<Object> get props => [email, password];
}

class LoginData extends Equatable {
  final String? token;
  final UserData? user;

  const LoginData({
    this.token,
    this.user,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    UserData? user;
    
    // Try to parse user data from different possible locations in the response
    if (json['user'] != null) {
      user = UserData.fromJson(json['user']);
    } else if (json['data'] != null && json['data']['user'] != null) {
      user = UserData.fromJson(json['data']['user']);
    }
    
    return LoginData(
      token: json['token'] as String?,
      user: user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user?.toJson(),
    };
  }

  @override
  List<Object?> get props => [token, user];
}

class LoginResponse extends BaseResponseData<LoginData> {
  const LoginResponse({
    super.success,
    super.data,
    super.message,
    super.pagination,
    super.error,
    super.url,
    super.statusCode,
    super.statusMessage,
    super.stack,
    super.messages,
    super.details,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // Handle legacy format where token and user are at top level
    LoginData? loginData;
    if (json['data'] != null) {
      loginData = LoginData.fromJson(json['data']);
    } else if (json['token'] != null || json['user'] != null) {
      loginData = LoginData.fromJson(json);
    }

    return LoginResponse(
      success: json['success'] as bool?,
      data: loginData,
      message: json['message'] as String?,
      pagination: json['pagination'] != null 
          ? BasePagination.fromJson(json['pagination']) 
          : null,
      error: json['error'] as bool?,
      url: json['url'] as String?,
      statusCode: json['statusCode'] as int?,
      statusMessage: json['statusMessage'] as String?,
      stack: json['stack'] != null ? List<String>.from(json['stack']) : null,
      messages: json['messages'] != null 
          ? MultiMessage.fromJson(json['messages']) 
          : null,
      details: json['details'] != null ? List<String>.from(json['details']) : null,
    );
  }

  // Legacy getters for backward compatibility
  String? get token => data?.token;
  UserData? get user => data?.user;
}

class UserData extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? department;
  final String? position;

  const UserData({
    required this.id,
    required this.email,
    this.name,
    this.department,
    this.position,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    try {
      return UserData(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? 'unknown_id',
        email: json['email']?.toString() ?? '',
        name: json['name']?.toString() ?? json['fullName']?.toString(),
        department: json['department']?.toString(),
        position: json['position']?.toString(),
      );
    } catch (e) {
      // Fallback with minimal data if parsing fails
      return UserData(
        id: 'unknown_id',
        email: json['email']?.toString() ?? 'unknown@email.com',
        name: 'Unknown User',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'department': department,
      'position': position,
    };
  }

  @override
  List<Object?> get props => [id, email, name, department, position];
}

@HiveType(typeId: 1)
class AuthToken extends Equatable {
  @HiveField(0)
  final String token;
  
  @HiveField(1)
  final DateTime expiresAt;

  const AuthToken({
    required this.token,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object> get props => [token, expiresAt];
}