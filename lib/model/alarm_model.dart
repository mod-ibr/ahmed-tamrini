class AlarmModel {
  int? id;
  String alarmName;
  String alarmTime;
  bool isSwitchedOn;
  int waterQuantity;

  AlarmModel({
    this.id,
    required this.alarmName,
    required this.alarmTime,
    required this.isSwitchedOn,
    required this.waterQuantity,
  });

  // Convert AlarmModel to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'alarmName': alarmName,
      'alarmTime': alarmTime,
      'isSwitchedOn': isSwitchedOn ? 1 : 0,
      'waterQuantity': waterQuantity,
    };
  }

  // Create AlarmModel from a map
  factory AlarmModel.fromMap(Map<String, dynamic> map) {
    return AlarmModel(
      id: map['_id'],
      alarmName: map['alarmName'],
      alarmTime: map['alarmTime'],
      isSwitchedOn: map['isSwitchedOn'] == 1,
      waterQuantity: map['waterQuantity'],
    );
  }

  // CopyWith method to create a copy of the AlarmModel with updated values
  AlarmModel copyWith({
    int? id,
    String? alarmName,
    String? alarmTime,
    bool? isSwitchedOn,
    int? waterQuantity,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      alarmName: alarmName ?? this.alarmName,
      alarmTime: alarmTime ?? this.alarmTime,
      isSwitchedOn: isSwitchedOn ?? this.isSwitchedOn,
      waterQuantity: waterQuantity ?? this.waterQuantity,
    );
  }
}
