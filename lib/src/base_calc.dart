import 'dart:math';
import './constants.dart';

abstract class BaseCalc {
  final DateTime date;
  final String name;
  final num _longitude;
  final num _latitude;



  Map<String, double> eclipticCoords;
  Map<String, double> equatorialCoords;
  double _hourAngle;
  Map<String, double> position;
  Map<String, DateTime> times;



  num get longitude { return -1 * _longitude * rad; }
  num get latitude { return _latitude * rad; }
  num get julian { return BaseCalc.dateToJulian(date); }
  num get daysSince2000 { return julian - julian2000; }
  num get obliquity { return BaseCalc.trueObliquity(date); }
  num get siderealTime { return rad * (siderealZero['Earth'] + deltaSidereal['Earth'] * daysSince2000) - longitude; }



  BaseCalc(this.name, this.date, this._longitude, this._latitude) {
    eclipticCoords = {
      'lat': eclipticLatitude(),
      'lng': eclipticLongitude(),
    };
    equatorialCoords = {
      'ra': rightAscension(),
      'dec': declination(),
    };
    _hourAngle = siderealTime - equatorialCoords['ra'];
    position = {
      'azimuth': azimuth(),
      'altitude': altitude(),
    };
    times = getTimes();
  }



  double eclipticLongitude();
  double eclipticLatitude();
  Map<String, DateTime> getTimes();



  double meanAnomaly(num days) {
    return rad * (meanAnomalyZero[name] + deltaMeanAnomaly[name] * days);
  }

  /**
   * Calculates the right ascension for a celestial body given its ecliptic
   * longitude and latitude.
   * The right ascension helps determine when the body is visible.
   */
  double rightAscension({ double lng, double lat }) {
    if (lng == null) lng = eclipticCoords['lng'];
    if (lat == null) lat = eclipticCoords['lat'];
    return atan2(
      (sin(lng) * cos(obliquity)) - (tan(lat) * sin(obliquity)),
      cos(lng)
    );
  }

  /**
   * Calculates the declination for a celestial body given its ecliptic
   * longitude and latitude.
   * The declination determines where the body is visible from.
   */
  double declination({ double lng, double lat }) {
    if (lng == null) lng = eclipticCoords['lng'];
    if (lat == null) lat = eclipticCoords['lat'];
    return asin(
      (sin(lat) * cos(obliquity)) + 
      (cos(lat) * sin(obliquity) * sin(lng))
    );
  }

  /**
   * Calculates the azimuth of a celestial body (direction along the horizon from
   * south to west. South is 0 degrees).
   */
  double azimuth() {
    return atan2(
      sin(_hourAngle),
      (cos(_hourAngle) * sin(latitude)) - (tan(equatorialCoords['dec']) * cos(latitude))
    );
  }

  /**
   * Calculates the altitude of a celestial body above the horizon, expressed in degrees
   * (the horizon is 0)
   */
  double altitude() {
    return asin(
      (sin(latitude) * sin(equatorialCoords['dec'])) +
      (cos(latitude) * cos(equatorialCoords['dec']) * cos(_hourAngle))
    );
  }



  static num dateToJulian(DateTime date) {
    return date.millisecondsSinceEpoch / msPerDay - 0.5 + julian1970;
  }

  static DateTime dateFromJulian(num julian) {
    return new DateTime.fromMillisecondsSinceEpoch(
      (julian + 0.5 - julian1970) * msPerDay
    );
  }

  static double trueObliquity(DateTime date) {
    int hoursPassed = date.toUtc().difference(sept28Date).inHours;
    return rad * (sept28Obliquity - (hoursPassed * obliquityShift));
  }

  static double atmosphericRefraction([num altitude = 0]) {
    if (altitude < 0) altitude = 0;
    return 0.0002967 / tan(altitude + 0.00312536 / (altitude + 0.08901179));
  }
}
