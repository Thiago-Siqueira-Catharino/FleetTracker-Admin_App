class Car {
  String id;
  String tagUid;
  String model;
  String plate;

  Car({
    required this.id,
    required this.tagUid,
    required this.model,
    required this.plate
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as String,
      tagUid: json['tagUid'] as String,
      model: json['model'] as String,
      plate: (json['plate'] as Map<String, dynamic>)['value'] as String
    );
  }
}

class Path {
  String id;
  String carId;
  DateTime createdAt;

  Path({
    required this.id,
    required this.carId,
    required this.createdAt
  });

  factory Path.fromJson(Map<String, dynamic> json) {
    return Path(
      id: json['id'] as String, 
      carId: json['carId'] as String,
      createdAt: DateTime.parse(json['createdAt'])
    );
  }
}

class Location {
  String id;
  String pathId;
  DateTime timeStamp;
  double latitude;
  double longitude;
  double fuelLevel;
  double speed;
  
  Location({
    required this.id,
    required this.pathId,
    required this.timeStamp,
    required this.latitude,
    required this.longitude,
    required this.fuelLevel,
    required this.speed
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as String, 
      pathId: json['pathId'] as String, 
      timeStamp: DateTime.parse(json['timeStamp']), 
      latitude: (json['coordinate']['latitude'] as num).toDouble(), 
      longitude: (json['coordinate']['longitude'] as num).toDouble(), 
      fuelLevel: (json['fuelLevel'] as num).toDouble(), 
      speed: (json['speed'] as num).toDouble()
    );
  }
}