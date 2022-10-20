import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NoResultDisplay extends StatelessWidget {
  final String message;
  const NoResultDisplay({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          MdiIcons.emoticonPoop,
          size: 96,
        ),
        Text(
          message,
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}
