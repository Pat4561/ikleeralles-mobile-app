import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/network/auth/userinfo.dart';


class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;

  ThemedAppBar ({ this.title });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: AutoSizeText(
                          this.title,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 17,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontFamily: Fonts.ubuntu,
                              fontWeight: FontWeight.w600
                          ),
                        )),
                        SizedBox(width: 8),
                        ValueListenableBuilder(
                          valueListenable: AuthService().userInfoValueNotifier,
                          builder: (BuildContext context, UserInfo userInfo, Widget widget) {
                            if (userInfo != null && userInfo.userResult != null) {
                              return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                      color: BrandColors.secondaryButtonColor,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Text(userInfo.userResult.username, style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: Fonts.ubuntu,
                                      fontWeight: FontWeight.w500
                                  ))
                              );
                            }
                            return Visibility(
                              visible: false,
                              child: Container(),
                            );
                          },
                        )
                      ],
                    )
                )
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(75);
  }

}
