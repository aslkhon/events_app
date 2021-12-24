import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class EventCardShimmer extends StatelessWidget {
  const EventCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 256,
        width: 100.0,
        color: Colors.black,
      ),
    );
  }
}
