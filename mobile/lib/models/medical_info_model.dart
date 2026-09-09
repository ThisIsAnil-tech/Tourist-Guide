class MedicalInfoModel {
  final String? bloodGroup;
  final List<String> conditions;

  MedicalInfoModel({this.bloodGroup, this.conditions = const []});

  factory MedicalInfoModel.fromJson(Map<String, dynamic> json) {
    return MedicalInfoModel(
      bloodGroup: json['blood_group'] as String?,
      conditions: (json['conditions'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'blood_group': bloodGroup, 'conditions': conditions};
  }

  factory MedicalInfoModel.empty() => MedicalInfoModel(conditions: []);
}