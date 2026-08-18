import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class MaleQiblaController extends GetxController {
  var compassHeading = 0.0.obs;
  var qiblaDirection = 267.0.obs; // Default fallback (~Dhaka Qibla)
  var dialRotation = 0.0.obs;   // Angle for compass dial (in turns)
  var needleRotation = 0.0.obs; // Angle for Qibla needle (in turns)

  var needleOffset = 0.0.obs;

  var isSensorAvailable = true.obs;
  var isLoading = true.obs;
  var accuracyStatus = "".obs;

  StreamSubscription? _compassSub;
  StreamSubscription? _positionSub;

  double _smoothedHeading = 0.0;
  bool _hasInitialHeading = false;

  double _continuousHeadingAngle = 0.0;
  double _continuousNeedleAngle = 0.0;

  int _lowAccuracyCount = 0;

  @override
  void onInit() {
    super.onInit();
    initCompass();
    startLocationUpdates();
  }

  @override
  void onClose() {
    _compassSub?.cancel();
    _positionSub?.cancel();
    super.onClose();
  }

  void initCompass() {
    _compassSub = FlutterCompass.events?.listen((CompassEvent event) {
      if (event.heading == null) {
        isSensorAvailable.value = false;
        return;
      }

      isSensorAvailable.value = true;
      double rawHeading = event.heading!;
      if (rawHeading < 0) rawHeading += 360;

      // Filter sensor noise (Low-Pass Filter)
      if (!_hasInitialHeading) {
        _smoothedHeading = rawHeading;
        _hasInitialHeading = true;
      } else {
        double diff = rawHeading - _smoothedHeading;
        while (diff < -180) diff += 360;
        while (diff > 180) diff -= 360;

        // Apply smooth exponential moving average
        if (diff.abs() > 0.2) {
          _smoothedHeading = (_smoothedHeading + diff * 0.25) % 360;
          if (_smoothedHeading < 0) _smoothedHeading += 360;
        }
      }

      compassHeading.value = _smoothedHeading;
      _updateRotations();

      // Accuracy check (Safe for Android & iOS)
      final accuracy = event.accuracy;
      if (accuracy != null) {
        bool isLowAccuracy = false;
        if (Platform.isAndroid) {
          // Android SensorManager status: 0=unreliable, 1=low
          if (accuracy == 0 || accuracy == 1) {
            isLowAccuracy = true;
          }
        } else {
          // iOS: deviation in degrees (>30 or negative)
          if (accuracy < 0 || accuracy > 30) {
            isLowAccuracy = true;
          }
        }

        if (isLowAccuracy) {
          _lowAccuracyCount++;
          if (_lowAccuracyCount > 5) {
            accuracyStatus.value = "Low Accuracy: Move phone in 8-shape to calibrate compass";
          }
        } else {
          _lowAccuracyCount = 0;
          accuracyStatus.value = "";
        }
      } else {
        accuracyStatus.value = "";
      }
    });
  }

  void _updateRotations() {
    // 1. Dial rotation (True North)
    double targetDialAngle = -compassHeading.value;
    double dialDiff = targetDialAngle - (_continuousHeadingAngle % 360);
    while (dialDiff < -180) dialDiff += 360;
    while (dialDiff > 180) dialDiff -= 360;
    _continuousHeadingAngle += dialDiff;
    dialRotation.value = _continuousHeadingAngle / 360.0;

    // 2. Needle rotation (Qibla relative to heading)
    double relativeAngle = qiblaDirection.value - compassHeading.value;
    while (relativeAngle < 0) relativeAngle += 360;
    while (relativeAngle >= 360) relativeAngle -= 360;

    double needleDiff = relativeAngle - (_continuousNeedleAngle % 360);
    while (needleDiff < -180) needleDiff += 360;
    while (needleDiff > 180) needleDiff -= 360;
    _continuousNeedleAngle += needleDiff;
    needleRotation.value = _continuousNeedleAngle / 360.0;
  }

  Future<void> startLocationUpdates() async {
    try {
      isLoading(true);

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        isLoading(false);
        return;
      }

      // Fast initial position fallback
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        _updateQiblaFromPosition(lastPosition);
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );
      _updateQiblaFromPosition(position);

      _positionSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        _updateQiblaFromPosition(position);
      });
    } catch (e) {
      print("Error in location updates: $e");
    } finally {
      isLoading(false);
    }
  }

  void _updateQiblaFromPosition(Position position) {
    double calculatedQibla = calculateQiblaDirection(
      position.latitude,
      position.longitude,
    );

    qiblaDirection.value = calculatedQibla;
    print("Qibla: Precise bearing: ${qiblaDirection.value.toStringAsFixed(2)} at ${position.latitude}, ${position.longitude}");
    _updateRotations();
  }

  double calculateQiblaDirection(double latitude, double longitude) {
    // Mecca coordinates (High Precision)
    const double meccaLat = 21.422487;
    const double meccaLng = 39.826206;

    double phi1 = latitude * (math.pi / 180.0);
    double lambda1 = longitude * (math.pi / 180.0);
    double phi2 = meccaLat * (math.pi / 180.0);
    double lambda2 = meccaLng * (math.pi / 180.0);

    double deltaLambda = lambda2 - lambda1;

    double y = math.sin(deltaLambda) * math.cos(phi2);
    double x = math.cos(phi1) * math.sin(phi2) -
        math.sin(phi1) * math.cos(phi2) * math.cos(deltaLambda);

    double qibla = math.atan2(y, x);
    double qiblaDegrees = qibla * (180.0 / math.pi);

    return (qiblaDegrees + 360.0) % 360.0;
  }
}
