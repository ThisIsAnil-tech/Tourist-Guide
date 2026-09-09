import 'emergency_contact_model.dart';
import 'medical_info_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final List<EmergencyContactModel> emergencyContacts;
  final MedicalInfoModel medicalInfo;
  final String identityStatus;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.emergencyContacts,
    required this.medicalInfo,
    required this.identityStatus,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      emergencyContacts: (json['emergency_contacts'] as List<dynamic>? ?? [])
          .map((e) => EmergencyContactModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      medicalInfo: json['medical_info'] != null
          ? MedicalInfoModel.fromJson(json['medical_info'] as Map<String, dynamic>)
          : MedicalInfoModel.empty(),
      identityStatus: json['identity_status'] as String? ?? 'locked',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  bool get isIdentityLocked => identityStatus == 'locked';
}