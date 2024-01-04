import 'dart:convert';

import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:dolan_yuk/components/widgets/dolanField.dart';
import 'package:dolan_yuk/models/message.dart';
import 'package:dolan_yuk/models/room.dart';
import 'package:dolan_yuk/providers/user_provider.dart';
import 'package:dolan_yuk/services/message_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomChat extends StatefulWidget {
  const RoomChat({super.key, required this.room});
  final Room room;

  @override
  State<RoomChat> createState() => _RoomChatState();
}

class _RoomChatState extends State<RoomChat> {
  final uri = Uri.parse('ws://localhost:8080/ws');
  late final WebSocketChannel channel;
  final TextEditingController message = TextEditingController();
  Map<String, dynamic> listChat = {};
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    channel = WebSocketChannel.connect(uri);
    channel.stream.listen((message) {
      final Map<String, dynamic> received = jsonDecode(message);
      if (received["id_schedule"] == widget.room.id_schedule) {
        setState(() {
          listChat.addAll({listChat.length.toString(): received});
        });
      }
      // print(listChat);
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              reverse: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FutureBuilder(
                        future:
                            MessageService.getMessage(widget.room.id_schedule),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            final data = snapshot.data!.body;
                            final Map<String, dynamic> result =
                                jsonDecode(data);
                            listChat.clear();
                            listChat = result;
                            return Column(
                              children: listChat.entries.map((item) {
                                bool isMine = item.value["name_sender"] ==
                                    widget.room.username;
                                return Align(
                                  alignment: isMine
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                      constraints:
                                          BoxConstraints(maxWidth: width - 80),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          color: (isMine)
                                              ? Colors.deepPurple
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                                blurRadius: 12,
                                                color: Colors.black12)
                                          ]),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          isMine
                                              ? const SizedBox()
                                              : Text(
                                                  item.value["name_sender"] ??
                                                      "",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.deepPurple),
                                                ),
                                          Text(
                                            item.value["content"] ?? "",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: isMine
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ],
                                      )),
                                );
                              }).toList(),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: SizedBox.square(
                                dimension: 50,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            return const Text("Belum ada pesan");
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: DolanField(
              controller: message,
              label: "Message",
              suffix: InkWell(
                child: const Icon(Icons.send),
                onTap: () {
                  if (message.text.isNotEmpty) {
                    final DateTime date = DateTime.now();
                    final TimeOfDay time = TimeOfDay.now();
                    final Message temp = Message(
                        idSender: context.read<UserProvider>().currentUser.id,
                        idSchedule: widget.room.id_schedule,
                        content: message.text,
                        createDate: date.toString().substring(0, 10),
                        createTime: time.format(context).replaceAll(':', '-'));
                    channel.sink.add(jsonEncode(temp.toJson));
                    message.clear();
                    // print
                    // (temp.toJson);
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
