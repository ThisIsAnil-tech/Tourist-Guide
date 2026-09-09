enum DeviceConnectionState { discovered, connecting, connected, relaying, lost }

class NearbyDeviceModel {
  final String endpointId;
  final String displayName;
  final DeviceConnectionState state;
  final bool hasInternet;
  final int reportedHops;

  NearbyDeviceModel({
    required this.endpointId,
    required this.displayName,
    required this.state,
    this.hasInternet = false,
    this.reportedHops = 0,
  });

  NearbyDeviceModel copyWith({
    DeviceConnectionState? state,
    bool? hasInternet,
    int? reportedHops,
  }) {
    return NearbyDeviceModel(
      endpointId: endpointId,
      displayName: displayName,
      state: state ?? this.state,
      hasInternet: hasInternet ?? this.hasInternet,
      reportedHops: reportedHops ?? this.reportedHops,
    );
  }
}