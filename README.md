# AstroCalc

This library is a Dart port of the awesome Vladimir Agafonkin (@mourner)'s JavaScript
library for calculating sun and moon positions and phases for a given location and time.

Calculations for other solar system bodies are also in the works.

## Usage

AstroCalc is available on [Pub](https://pub.dartlang.org).

See the `examples` folder for usage examples.

## Reference

### BaseCalc

```dart
// Latitude and longitude in degrees
var baseCalcChild = BaseCalcChild({ DateTime date, num longitude, num latitude })
```

All celestial body classes inherit from the abstract class BaseCalc. On instantiation,
they all calculate and expose the following properties of the body for the provided
location and time (each is a `Map`):

| Property           | Description                                                                                                  |
| ------------------ | ------------------------------------------------------------------------------------------------------------ |
| `eclipticCoords`   | Earth-based ecliptic coordinates: latitude (`eclipticCoords['lat']`) and longitude (`eclipticCoords['lng']`) |
| `equatorialCoords` | Equatorial coordinates: right ascension (`equatorialCoords['ra']` and declination `equatorialCoords['dec']`) |
| `position`         | Earth-based horizontal coordinates: azimuth (`position['azimuth']`) and altitude (`position['altitude']`)    |
| `times`            | Times of astronomical interest (body-specific)                                                               |

The coordinate systems are returned in radians. For more information on each, see the following links:

- [Ecliptic coordinate system](https://en.wikipedia.org/wiki/Ecliptic_coordinate_system)
- [Equatorial coordinate system](https://en.wikipedia.org/wiki/Equatorial_coordinate_system)
- [Horizontal coordinate system](https://en.wikipedia.org/wiki/Horizontal_coordinate_system)

### SunCalc

```dart
var sunCalc = new SunCalc({ DateTime date, num longitude, num latitude })
```

In addition to the coordinate systems, SunCalc calculates the following times (accessible as properties of the `Map` `sunCalc.times`)

| Property        | Description                                                              |
| --------------- | ------------------------------------------------------------------------ |
| `nightEnd`      | night ends (morning astronomical dawn starts)                            |
| `nauticalDawn`  | nautical dawn (morning nautical dawn starts)                             |
| `dawn`          | dawn (morning nautical dawn ends, morning civil dawn starts)             |
| `sunrise`       | sunrise (top edge of the sun appears on the horizon)                     |
| `sunriseEnd`    | sunrise ends (bottom edge of the sun touches the horizon)                |
| `goldenHourEnd` | morning golden hour (soft light, best time for photography) ends         |
| `solarNoon`     | solar noon (sun is in the highest position)                              |
| `goldenHour`    | evening golden hour starts                                               |
| `sunsetStart`   | sunset starts (bottom edge of the sun touches the horizon)               |
| `sunset`        | sunset (sun disappears below the horizon, evening civil twilight starts) |
| `dusk`          | dusk (evening nautical twilight starts)                                  |
| `nauticalDusk`  | nautical dusk (evening astronomical twilight starts)                     |
| `night`         | night starts (dark enough for astronomical observations)                 |
| `nadir`         | nadir (darkest moment of the night, sun is in the lowest position)       |
