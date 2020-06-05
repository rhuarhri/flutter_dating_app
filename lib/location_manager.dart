import 'package:geolocator/geolocator.dart';
import 'dart:math';

class LocationManager
{
  Future<Position> getCurrentLocation() async
  {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    return position;
  }

  Future<int> getDistance(startLat, startLong, endLat, endLong) async
  {
    double distance = await Geolocator().distanceBetween(startLat, startLong, endLat, endLong);

    return distance.round();
  }



}