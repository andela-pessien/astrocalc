import 'dart:math';
import './base_calc.dart';
import './constants.dart';

class SunCalc extends BaseCalc {
  static const _times = const [
    const [-0.833 * rad, 'sunrise',       'sunset'      ],
    const [  -0.3 * rad, 'sunriseEnd',    'sunsetStart' ],
    const [    -6 * rad, 'dawn',          'dusk'        ],
    const [   -12 * rad, 'nauticalDawn',  'nauticalDusk'],
    const [   -18 * rad, 'nightEnd',      'night'       ],
    const [     6 * rad, 'goldenHourEnd', 'goldenHour'  ]
  ];

  SunCalc({ date, longitude, latitude }) : super('Sun', date, longitude, latitude);

  double eclipticLongitude({ num days }) {
    if (days == null) days = daysSince2000;
    double mA = meanAnomaly(days);
    double center = rad * (1.9148 * sin(mA) + 0.02 * sin(2 * mA) + 0.0003 * sin(3 * mA));

    return mA + center + planetocentricPerihelion['Earth'] + pi;
  }

  double eclipticLatitude() {
    return 0.0;
  }

  Map<String, DateTime> getTimes() {
    double Jnoon, Jset, Jrise;
    Map<String, DateTime> solarTimes;

    int julianCycle = (daysSince2000 - sunTransit['Earth'][0] - longitude / (2 * pi)).round();
    double noonTransit = approxTransit(0, longitude, julianCycle);
    double mA = meanAnomaly(noonTransit);
    double eclipticLng = eclipticLongitude(days: noonTransit);
    double dec = declination(lng: eclipticLng);

    Jnoon = transitJulian(noonTransit, mA, eclipticLng);

    solarTimes = {
      'noon': BaseCalc.dateFromJulian(Jnoon),
      'nadir': BaseCalc.dateFromJulian(Jnoon - 0.5),
    };

    _times.forEach((time) {
      Jset = getSetJulian(time[0], longitude, latitude, dec, julianCycle, mA, eclipticLng);
      Jrise = 2 * Jnoon - Jset;
      solarTimes[time[1]] = BaseCalc.dateFromJulian(Jrise);
      solarTimes[time[2]] = BaseCalc.dateFromJulian(Jset);
    });

    return solarTimes;
  }

  static double approxTransit(num hAngle, double longitude, int julianCycle) {
    double J0 = sunTransit['Earth'][0];
    return J0 + (hAngle + longitude) / (2 * pi) + julianCycle;
  }

  static double transitJulian(double transit, double mA, double eclipticLng) {
    List<double> J = sunTransit['Earth'];
    return julian2000 + transit + J[1] * sin(mA) + J[2] * sin(2 * eclipticLng);
  }

  static double getSetJulian(
    double altitude,
    double longitude,
    double latitude,
    double declination,
    int julianCycle,
    double mA,
    double eclipticLng) {
      double hAngle = acos((sin(altitude) - sin(latitude) * sin(declination)) / (cos(latitude) * cos(declination)));
      double setTransit = approxTransit(hAngle, longitude, julianCycle);

      return transitJulian(setTransit, mA, eclipticLng);
    }
}
