import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/network/models/group.dart';

class GroupCell extends StatelessWidget {

  final Group group;

  final Function(Group) onPressed;

  GroupCell (this.group, { @required this.onPressed });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: BrandColors.borderColor,
                  width: 1
              )
          )
      ),
      child: Material(
        child: InkWell(
          onTap: () => onPressed(group),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        this.group.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: Fonts.ubuntu,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                          ),
                          SizedBox(width: 5),
                          Text(
                            FlutterI18n.translate(context, TranslationKeys.members, { "count": this.group.members.length.toString() }),
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: Fonts.ubuntu
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  child: Icon(Icons.chevron_right),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}