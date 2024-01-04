class Message {
  const Message(
      {required this.idSender,
      required this.idSchedule,
      required this.content,
      required this.createDate,
      required this.createTime});
  final int idSender, idSchedule;
  final String content, createDate, createTime;
  get toJson {
    return {
      "id_sender": idSender,
      "id_schedule": idSchedule,
      "content": content,
      "create_date": createDate,
      "create_time": createTime,
    };
  }
}
