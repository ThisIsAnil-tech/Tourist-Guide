class TestResultModel {
  final String? sosEventId;
  final String modelVersion;
  final String predictedClass;
  final double confidence;
  final double inferenceTimeMs;
  final Map<String, dynamic> deviceInfo;

  TestResultModel({
    this.sosEventId,
    required this.modelVersion,
    required this.predictedClass,
    required this.confidence,
    required this.inferenceTimeMs,
    required this.deviceInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'sos_event_id': sosEventId,
      'model_version': modelVersion,
      'predicted_class': predictedClass,
      'confidence': confidence,
      'inference_time_ms': inferenceTimeMs,
      'device_info': deviceInfo,
    };
  }
}