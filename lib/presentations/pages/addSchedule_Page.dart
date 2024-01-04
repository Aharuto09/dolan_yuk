import 'dart:io';

import 'package:dolan_yuk/components/cards/dolanDialog.dart';
import 'package:dolan_yuk/components/widgets/dolanField.dart';
import 'package:dolan_yuk/components/widgets/mainButton.dart';
import 'package:dolan_yuk/models/schedule.dart';
import 'package:dolan_yuk/providers/dolan_provider.dart';
import 'package:dolan_yuk/providers/user_provider.dart';
import 'package:dolan_yuk/services/schedule_Service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({super.key});
  // final Map<String, dynamic> dolans;
  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  TextEditingController title = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController min = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime = TimeOfDay.now();
  String? selectedDolan;
  int selectedId = 0;
  @override
  Widget build(BuildContext context) {
    final dolanList = context.read<DolanProvider>().dolans;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: const Text("Buat Jadwal"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Bikin jadwal dolananmu yuk!"),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 50,
                    // width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black45),
                        borderRadius: BorderRadius.circular(7)),
                    child: Text(
                      (selectedDate != null)
                          ? selectedDate!.toString().substring(0, 10)
                          : "2020-02-02",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              initialDate: selectedDate,
                              lastDate:
                                  DateTime.now().add(const Duration(days: 30)))
                          .then((value) {
                        setState(() {
                          selectedDate = value;
                        });
                      });
                    },
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size(100, 58),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7))),
                    child: const Text("Date"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    // width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black45),
                        borderRadius: BorderRadius.circular(7)),
                    child: Text(
                      (selectedTime != null)
                          ? selectedTime!.format(context)
                          : "00:00",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      showTimePicker(
                              context: context,
                              initialTime: selectedTime ?? TimeOfDay.now())
                          .then((value) {
                        setState(() {
                          selectedTime = value;
                        });
                      });
                    },
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size(100, 58),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7))),
                    child: const Text("Time"),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            DolanField(controller: location, label: "Lokasi Dolan"),
            const SizedBox(height: 20),
            DolanField(controller: address, label: "Alamat Dolan"),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black45, width: 1)),
              child: DropdownButton(
                  value: selectedDolan,
                  underline: const SizedBox(),
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  borderRadius: BorderRadius.circular(5),
                  hint: const Text("Dolans Utama"),
                  items: [
                    ...dolanList.map((item) => DropdownMenuItem(
                        value: item.name,
                        onTap: () {
                          min.text = item.min.toString();
                          setState(() {
                            selectedId = item.id;
                          });
                        },
                        child: Text(item.name)))
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedDolan = value as String;
                    });
                  }),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: min,
              readOnly: true,
              decoration: const InputDecoration(
                label: Text("Email"),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerRight,
              child: MainButton(
                  onPressed: () {
                    if (selectedDate != null &&
                        selectedTime != null &&
                        location.text.isNotEmpty &&
                        address.text.isNotEmpty &&
                        selectedId != 0) {
                      Schedule temp = Schedule(
                          date_for: selectedDate!.toString().substring(0, 10),
                          time_for: selectedTime!
                              .format(context)
                              .replaceAll(':', '-'),
                          location: location.text,
                          address: address.text,
                          id_group: selectedId);
                      ScheduleService.addSchedule(
                              temp, context.read<UserProvider>().currentUser.id)
                          .then((response) {
                        if (response.statusCode == HttpStatus.ok) {
                          showDialog(
                              context: context,
                              builder: (context) => DolanDialog(
                                    title: "Sukses Mengirim",
                                    content: "Berhasil menambahkan jadwal baru",
                                    buttonText: "Keren!",
                                    onPressed: () {
                                      context.pop();
                                      context.pop();
                                    },
                                  ));
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => const DolanDialog(
                                  title: "Oppss!",
                                  content:
                                      "Mohon maaf terjadi kesalahan, silahkan coba lagi",
                                  buttonText: "Ok"));
                        }
                      });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => const DolanDialog(
                              title: "Oppss!",
                              content:
                                  "Mohon memastikan field tidak ada yang kosong",
                              buttonText: "Ok"));
                    }
                  },
                  title: "Buat Jadwal"),
            )
          ],
        ),
      ),
    );
  }
}
