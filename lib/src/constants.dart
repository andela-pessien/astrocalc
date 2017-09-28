import 'dart:math';

/// The number of milliseconds in one day
const msPerDay = 1000 * 60 * 60 * 24;

/// (Astronomical) Julian date for 1970 and 2000
const julian1970 = 2440588;
const julian2000 = 2451545;

/// One radian is one-one-hundred-and-eightieth of pi
const rad = PI / 180;

/// DateTime object for 28th September, 2017 at 12 noon UTC
final sept28Date = new DateTime.utc(2017, DateTime.SEPTEMBER, 28, 12);

/// True obliquity (in degrees) on 28th September, 2017 at 12 noon
const sept28Obliquity = 23.43697;

/// Obliquity shift per hour
/// The Earth's obliquity fluctuates between 22.1 and 24.5 over a period of
/// 40,000 years, and is currently decreasing.
const obliquityShift = 2.4 / (365.2422 * 40000 * 24);

/// Sidereal time in degrees at longitude 0 at zero hour on January 1, 2000
const siderealZero = const {
  'Earth': 280.1470
};

/// Rate of change of sidereal time
const deltaSidereal = const {
  'Earth': 360.9856235
};

/// Mean anomaly at zero hour on January 1, 2000
const meanAnomalyZero = const {
  'Sun': 357.5291,
};

/// Rate of change of mean anomaly
const deltaMeanAnomaly = const {
  'Sun': 0.98560028,
};

const planetocentricPerihelion = const {
  'Earth': rad * 102.9372,
};

const sunTransit = const {
  'Earth': const [0.0009, 0.0053, -0.0068, 1.0000000],
};
