import 'package:flutter/material.dart';

import '../consts/constants.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.onTap,
  });
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      // margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 157, 166, 239),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.download,
                color: Color.fromARGB(255, 205, 19, 19),
              ),
              gapw(20),
              const Text(
                'Download Student details',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
