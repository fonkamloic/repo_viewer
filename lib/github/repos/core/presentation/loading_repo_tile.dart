import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingRepoTile extends StatelessWidget {
  const LoadingRepoTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: ListTile(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            height: 14,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(2)),
          ),
        ),
        subtitle: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            height: 14,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(2)),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(Icons.star_border),
            SizedBox(
              height: 5,
            ),
            Text('0000')
          ],
        ),
        leading: CircleAvatar(),
      ),
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade300,
    );
  }
}
