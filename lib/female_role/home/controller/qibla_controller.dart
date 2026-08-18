import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class QiblaController extends GetxController {
  // =====================
  // OBSERVABLE VALUES
  // =====================
  var compassHeading = 0.0.obs;
  var qiblaDirection = 267.0.obs; // fallback (Dhaka approx)
  var dialRotation = 0.0.obs;
  var needleRotation = 0.0.obs;

  var needleOffset = 0.0.obs;

  var isSensorAvailable = true.obs;
  var isLoading = true.obs;
  var accuracyStatus = "".obs;

  // =====================
  // STREAM SUBSCRIPTIONS & FILTERING
  // =====================
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

  // =====================
  // COMPASS SENSOR
  // =====================
  void initCompass() {
    _compassSub = FlutterCompass.events?.listen((event) {
      if (event.heading == null) {
        isSensorAvailable.value = false;
        return;
      }

      isSensorAvailable.value = true;
      double rawHeading = event.heading!;

      // normalize 0 - 360
      if (rawHeading < 0) rawHeading += 360;

      // Low-pass filter for sensor smoothing
      if (!_hasInitialHeading) {
        _smoothedHeading = rawHeading;
        _hasInitialHeading = true;
      } else {
        double diff = rawHeading - _smoothedHeading;
        while (diff < -180) diff += 360;
        while (diff > 180) diff -= 360;

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
            accuracyStatus.value =
                "Low Accuracy: Move phone in 8-shape to calibrate compass";
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

  // =====================
  // LOCATION HANDLING
  // =====================
  Future<void> startLocationUpdates() async {
    try {
      isLoading.value = true;

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        isLoading.value = false;
        return;
      }

      // Fast initial position fallback
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        _updateQiblaFromPosition(lastPosition);
      }

      // initial position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      _updateQiblaFromPosition(position);

      // stream updates
      _positionSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((position) {
        _updateQiblaFromPosition(position);
      });
    } catch (e) {
      print("Qibla error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _updateQiblaFromPosition(Position position) {
    qiblaDirection.value = calculateQiblaDirection(
      position.latitude,
      position.longitude,
    );

    _updateRotations();
  }

  // =====================
  // QIBLA CALCULATION
  // =====================
  double calculateQiblaDirection(double lat, double lng) {
    const meccaLat = 21.422487;
    const meccaLng = 39.826206;

    double phi1 = lat * (math.pi / 180);
    double phi2 = meccaLat * (math.pi / 180);
    double deltaLambda = (meccaLng - lng) * (math.pi / 180);

    double y = math.sin(deltaLambda) * math.cos(phi2);
    double x =
        math.cos(phi1) * math.sin(phi2) -
        math.sin(phi1) * math.cos(phi2) * math.cos(deltaLambda);

    double bearing = math.atan2(y, x);

    double bearingDeg = (bearing * 180 / math.pi + 360) % 360;

    return bearingDeg;
  }

  // =====================
  // ROTATION UPDATE
  // =====================
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
}
