import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap._internal({
    this.height,
    this.width,
    super.key,
  });

  factory Gap.v48({Key? key}) => Gap._internal(key: key, height: 48);
  factory Gap.v40({Key? key}) => Gap._internal(key: key, height: 40);
  factory Gap.v32({Key? key}) => Gap._internal(key: key, height: 32);
  factory Gap.v24({Key? key}) => Gap._internal(key: key, height: 24);
  factory Gap.v16({Key? key}) => Gap._internal(key: key, height: 16);
  factory Gap.v12({Key? key}) => Gap._internal(key: key, height: 12);
  factory Gap.v8({Key? key}) => Gap._internal(key: key, height: 8);
  factory Gap.v6({Key? key}) => Gap._internal(key: key, height: 6);
  factory Gap.v4({Key? key}) => Gap._internal(key: key, height: 4);

  factory Gap.h32({Key? key}) => Gap._internal(key: key, width: 32);
  factory Gap.h24({Key? key}) => Gap._internal(key: key, width: 24);
  factory Gap.h20({Key? key}) => Gap._internal(key: key, width: 20);
  factory Gap.h16({Key? key}) => Gap._internal(key: key, width: 16);
  factory Gap.h12({Key? key}) => Gap._internal(key: key, width: 12);
  factory Gap.h8({Key? key}) => Gap._internal(key: key, width: 8);
  factory Gap.h4({Key? key}) => Gap._internal(key: key, width: 4);

  factory Gap.custom({
    Key? key,
    double? height,
    double? width,
  }) =>
      Gap._internal(
        key: key,
        height: height,
        width: width,
      );

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: height,
      );
}
