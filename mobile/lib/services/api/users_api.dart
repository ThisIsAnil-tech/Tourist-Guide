import '../../models/user_model.dart';
import '../../models/emergency_contact_model.dart';
import 'api_client.dart';

class UsersApi {
  static final UsersApi instance = UsersApi._internal();
  UsersApi._internal();

  final _dio = ApiClient.instance.dio;

  Future<UserModel> getMe() async {
    final response = await _dio.get('/users/me');
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserModel> updateProfile({String? name}) async {
    final response = await _dio.put('/users/me', data: {
      if (name != null) 'name': name,
    });
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserModel> addEmergencyContact(EmergencyContactModel contact) async {
    final response = await _dio.post('/users/me/emergency-contacts', data: contact.toJson());
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserModel> updateMedicalInfo({
    String? bloodGroup,
    List<String>? conditions,
  }) async {
    final response = await _dio.put('/users/me', data: {
      'medical_info': {
        'blood_group': bloodGroup,
        'conditions': conditions,
      },
    });
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteAccount() async {
    await _dio.delete('/users/me');
  }
}