import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:muslim_community/core/utils/helpers.dart';

class QiblaController extends GetxController {
  final compassHeading = 0.0.obs;
  final qiblaDirection = 267.0.obs;
  final dialRotation = 0.0.obs;
  final needleRotation = 0.0.obs;
  final isSensorAvailable = true.obs;
  final isLoading = true.obs;
  final accuracyStatus = "".obs;

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
    _compassSub?.cancel();
    _compassSub = FlutterCompass.events?.listen((CompassEvent event) {
      final headingVal = event.heading ?? event.headingForCameraMode;
      if (headingVal == null) {
        isSensorAvailable.value = false;
        return;
      }

      isSensorAvailable.value = true;
      double rawHeading = headingVal;
      if (rawHeading < 0) rawHeading += 360;

      if (!_hasInitialHeading) {
        _smoothedHeading = rawHeading;
        _hasInitialHeading = true;
      } else {
        double diff = rawHeading - _smoothedHeading;
        while (diff < -180) {
          diff += 360;
        }
        while (diff > 180) {
          diff -= 360;
        }

        if (diff.abs() > 0.1) {
          _smoothedHeading = (_smoothedHeading + diff * 0.4) % 360;
          if (_smoothedHeading < 0) _smoothedHeading += 360;
        }
      }

      compassHeading.value = _smoothedHeading;
      _updateRotations();

      final accuracy = event.accuracy;
      if (accuracy != null) {
        bool isLowAccuracy = false;
        if (Platform.isAndroid) {
          // 0 = SENSOR_STATUS_UNRELIABLE. 1, 2, 3 are acceptable accuracy levels
          if (accuracy == 0) isLowAccuracy = true;
        } else {
          // iOS: negative value means uncalibrated/unreliable
          if (accuracy < 0) isLowAccuracy = true;
        }

        if (isLowAccuracy) {
          _lowAccuracyCount++;
          if (_lowAccuracyCount > 25) {
            accuracyStatus.value =
                "Low Accuracy: Move phone in 8-shape to calibrate";
          }
        } else {
          _lowAccuracyCount = 0;
          accuracyStatus.value = "";
        }
      } else {
        _lowAccuracyCount = 0;
        accuracyStatus.value = "";
      }
    });
  }

  void _updateRotations() {
    double targetDialAngle = -compassHeading.value;
    double dialDiff = targetDialAngle - (_continuousHeadingAngle % 360);
    while (dialDiff < -180) {
      dialDiff += 360;
    }
    while (dialDiff > 180) {
      dialDiff -= 360;
    }
    _continuousHeadingAngle += dialDiff;
    dialRotation.value = _continuousHeadingAngle / 360.0;

    double relativeAngle = qiblaDirection.value - compassHeading.value;
    while (relativeAngle < 0) {
      relativeAngle += 360;
    }
    while (relativeAngle >= 360) {
      relativeAngle -= 360;
    }

    double needleDiff = relativeAngle - (_continuousNeedleAngle % 360);
    while (needleDiff < -180) {
      needleDiff += 360;
    }
    while (needleDiff > 180) {
      needleDiff -= 360;
    }
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

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        isLoading(false);
        return;
      }

      // Re-init compass after permission is granted
      initCompass();

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
      Helpers.error("Location updates error: $e");
    } finally {
      isLoading(false);
    }
  }

  void _updateQiblaFromPosition(Position position) {
    double calculated = calculateQiblaDirection(
      position.latitude,
      position.longitude,
    );
    qiblaDirection.value = calculated;
    _updateRotations();
  }

  double calculateQiblaDirection(double latitude, double longitude) {
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
