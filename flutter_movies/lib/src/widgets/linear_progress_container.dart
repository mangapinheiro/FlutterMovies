import 'package:flutter/material.dart';

class LinearProgressContainer extends StatelessWidget {
  const LinearProgressContainer({
    Key key,
    @required this.stream,
    @required this.child,
  }) : super(key: key);

  final Stream<bool> stream;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        StreamBuilder<bool>(
          stream: stream,
          initialData: true,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data) {
              return SizedBox(
                height: 3,
                child: LinearProgressIndicator(),
              );
            } else {
              return SizedBox(
                height: 3,
              );
            }
          },
        ),
      ],
    );
  }
}
