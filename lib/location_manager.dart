import 'package:geolocator/geolocator.dart';

class LocationManager
{

  /*
    user some not see anyone who is greater than 1.5 degrees greater than the lat and long on their
    location. As 1.5 degree difference is 194 km or 120 miles.*/

  double difference = 1.5;

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

  double _getMax(double startValue, double distance)
  {
    double differencePerMile = difference / 120;
    double max = startValue + (differencePerMile * distance);
    return max;
  }

  double _getMin(double startValue, double distance)
  {
    double differencePerMile = difference / 120;
    double min = startValue - (differencePerMile * distance);
    return min;

  }

  double getMaxLat(double startLat, double distance)
  {
    return _getMax(startLat, distance);
  }

  double getMinLat(double startLat, double distance)
  {
    return _getMin(startLat, distance);
  }

  double getMaxLong(double startLong, double distance)
  {
    return _getMax(startLong, distance);
  }

  double getMinLong(double startLong, double distance)
  {
    return _getMin(startLong, distance);
  }

  bool withInRange(accountLat, accountLong, Position usersPosition, double distance)
  {
    double maxLat = getMaxLat(usersPosition.latitude, distance);
    double minLat = getMinLat(usersPosition.latitude, distance);
    double maxLong = getMaxLong(usersPosition.longitude, distance);
    double minLong = getMinLong(usersPosition.longitude, distance);

    if(accountLat >= minLat && accountLat <= maxLat && accountLong >= minLong && accountLong <= maxLong)
      {
        return true;
      }
    else
      {
        return false;
      }
  }

}