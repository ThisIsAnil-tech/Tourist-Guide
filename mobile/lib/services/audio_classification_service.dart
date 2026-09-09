import 'dart:async';
import 'dart:typed_data';
import 'package:record/record.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/test_result_model.dart';
import 'api/test_results_api.dart';
import 'sos_pipeline_service.dart';

class AudioClassificationService {
  static const _modelVersion = 'tflite-v1.0';
  static const _windowSeconds = 3;

  final AudioRecorder _recorder = AudioRecorder();
  final SosPipelineService _pipeline;

  Interpreter? _interpreter;
  Timer? _loopTimer;
  double _threshold = 0.85;
  bool _isRunning = false;

  AudioClassificationService({required SosPipelineService pipeline}) : _pipeline = pipeline;

  void setThreshold(double value) => _threshold = value;

  Future<void> _loadModel() async {
    _interpreter ??= await Interpreter.fromAsset('assets/models/distress_audio_model.tflite');
  }

  Future<void> start() async {
    if (_isRunning) return;
    await _loadModel();

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) return;

    _isRunning = true;
    _loopTimer = Timer.periodic(const Duration(seconds: _windowSeconds), (_) => _captureAndClassify());
  }

  Future<void> stop() async {
    _loopTimer?.cancel();
    _isRunning = false;
  }

  Future<void> _captureAndClassify() async {
    if (!_isRunning || _interpreter == null) return;

    final startTime = DateTime.now();
    final Uint8List? audioBytes = await _captureAudioWindow();
    if (audioBytes == null) return;

    final spectrogram = _computeMelSpectrogram(audioBytes);
    final output = List.filled(1 * 3, 0.0).reshape([1, 3]);

    _interpreter!.run(spectrogram, output);

    final probabilities = output[0] as List<double>;
    final screamConfidence = probabilities[0];
    final glassBreakConfidence = probabilities[1];

    final inferenceTimeMs = DateTime.now().difference(startTime).inMilliseconds.toDouble();

    await TestResultsApi.instance.submitResult(TestResultModel(
      modelVersion: _modelVersion,
      predictedClass: screamConfidence > glassBreakConfidence ? 'scream' : 'glass_break',
      confidence: screamConfidence > glassBreakConfidence ? screamConfidence : glassBreakConfidence,
      inferenceTimeMs: inferenceTimeMs,
      deviceInfo: {'platform': 'mobile'},
    ));

    if (screamConfidence >= _threshold) {
      await _pipeline.triggerFromDetector(eventType: 'SCREAM');
    } else if (glassBreakConfidence >= _threshold) {
      await _pipeline.triggerFromDetector(eventType: 'GLASS_BREAK');
    }
  }

  Future<Uint8List?> _captureAudioWindow() async {
    return null;
  }

  List<List<double>> _computeMelSpectrogram(Uint8List audioBytes) {
    return [List.filled(128, 0.0)];
  }
}