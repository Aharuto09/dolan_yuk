class Schedule {
  const Schedule(
      {this.id = 0,
      required this.date_for,
      required this.time_for,
      required this.location,
      required this.address,
      required this.id_group});
  final int id, id_group;
  final String date_for, time_for, location, address;

  get toJson {
    return {
      "date_for": this.date_for,
      "time_for": this.time_for,
      "loc": this.location,
      "address": this.address,
      "id_group": this.id_group,
    };
  }
}
