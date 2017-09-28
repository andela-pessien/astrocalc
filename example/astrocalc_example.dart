import 'package:astrocalc/astrocalc.dart';

main() {
  SunCalc sunCalc = new SunCalc(
    date: new DateTime.now(),
    longitude: 3.3839178,
    latitude: 6.5069113
  );
  print(sunCalc.position);
  print(sunCalc.times);
}
