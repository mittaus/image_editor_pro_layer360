import 'package:flutter/material.dart';

class BottomBarContainer extends StatelessWidget {
  final Color colors;
  final Function ontap;
  final String title;
  final IconData icons;
  final Color iconColor;

  const BottomBarContainer(
      {Key key, this.ontap, this.title, this.icons, this.colors, this.iconColor=Colors.white})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width / 5,
      color: colors,
      child: Material(
        //color: Colors.black87,
        color: colors,
        child: InkWell(
          onTap: ontap,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Icon(
                icons,
                color: iconColor,
              ),
              new SizedBox(
                height: 4,
              ),
              /* new Text(
                title,
                style: TextStyle(color: Colors.white),
              ) */
            ],
          ),
        ),
      ),
    );
  }
}
