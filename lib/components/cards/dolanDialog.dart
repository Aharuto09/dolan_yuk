import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DolanDialog extends StatelessWidget {
  const DolanDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.buttonText,
      this.onPressed});
  final String title, content, buttonText;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      constraints: const BoxConstraints(maxHeight: 250, maxWidth: 350),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.deepPurple[50],
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Expanded(
              child: Text(
            content,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          )),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: onPressed ??
                    () {
                      context.pop();
                    },
                child: Text(buttonText)),
          ),
        ],
      ),
    ));
  }
}
