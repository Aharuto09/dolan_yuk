class Dolan {
  const Dolan({
    required this.id,
    required this.name,
    required this.min,
  });
  final int id, min;
  final String name;

  toMap() {
    return {"id": this.id, "name": this.name, "min": this.min};
  }
}
