import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/network/auth/userinfo.dart';
import 'package:ikleeralles/ui/themed/select.dart';
import 'package:ikleeralles/ui/themed/textfield.dart';
import 'package:scoped_model/scoped_model.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  final bool disablePopping;
  final bool showUserInfo;
  final List<Widget> actions;
  final Widget leading;

  ThemedAppBar ({ this.title, this.actions, this.disablePopping = false, this.showUserInfo = false, this.leading });

  bool canPop(BuildContext context) {
    return Navigator.canPop(context) && !disablePopping;
  }


  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Container(),
      flexibleSpace: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Visibility(
                      child: Container(
                        width: 64,
                        child: leading ?? IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      visible: leading != null || canPop(context),
                    ),
                    Expanded(
                      child: Container(
                          padding: canPop(context) || leading != null ? EdgeInsets.only(
                              right: 20,
                              left: 5
                          ) : EdgeInsets.symmetric(
                              horizontal: 20
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: AutoSizeText(
                                this.title ?? "",
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
                              Visibility(
                                child: Row(
                                  children: actions ?? <Widget>[],
                                ),
                                visible: actions != null && actions.length > 0,
                              ),
                              Visibility(
                                visible: showUserInfo,
                                child: ValueListenableBuilder(
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
                                ),
                              )
                            ],
                          )
                      ),
                    )
                  ],
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

class ThemedSearchAppBar extends StatefulWidget implements PreferredSizeWidget  {

  final PlatformDataProvider platformDataProvider;
  final Function(String search, String year, String level) onPerformSearch;
  final Widget leading;

  ThemedSearchAppBar ({ @required this.platformDataProvider, @required this.onPerformSearch, this.leading });

  @override
  State<StatefulWidget> createState() {
    return ThemedSearchAppBarState();
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(155);
  }
}

class ThemedSearchAppBarState extends State<ThemedSearchAppBar>  {



  ValueNotifier<String> _yearNotifier;
  ValueNotifier<String> _levelNotifier;

  final TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _yearNotifier = ValueNotifier<String>(widget.platformDataProvider.years.first);
    _levelNotifier = ValueNotifier<String>(widget.platformDataProvider.levels.first);

    widget.platformDataProvider.addListener(_onPlatformDataUpdate);

    _yearNotifier.addListener(_shouldUpdate);
    _levelNotifier.addListener(_shouldUpdate);

  }

  void _onPlatformDataUpdate() {
    if (_yearNotifier.value != null && !widget.platformDataProvider.years.contains(_yearNotifier.value)) {
      _yearNotifier.value = widget.platformDataProvider.years.first;
    }

    if (_levelNotifier.value != null && !widget.platformDataProvider.levels.contains(_levelNotifier.value)) {
      _levelNotifier.value = widget.platformDataProvider.levels.first;
    }
  }

  void _shouldUpdate() {
    widget.onPerformSearch(
      searchTextController.text,
      _yearNotifier.value,
      _levelNotifier.value
    );
  }


  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 8,
        leading: Container(),
        flexibleSpace: ScopedModel<PlatformDataProvider>(
          model: widget.platformDataProvider,
          child: ScopedModelDescendant<PlatformDataProvider>(
            builder: (BuildContext context, Widget widget, PlatformDataProvider provider) {
              return SafeArea(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 75,
                      child: Row(
                        children: <Widget>[
                          Visibility(
                            child: Container(
                              width: 64,
                              child: this.widget.leading ?? IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: 20
                                ),
                                child: SizedBox(
                                  height: 40,
                                  child: ThemedSearchTextField(
                                      hint: FlutterI18n.translate(context, TranslationKeys.searchHint),
                                      textEditingController: this.searchTextController,
                                      onSubmitted: (value) {
                                        _shouldUpdate();
                                      }
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      height: 80,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: ThemedSelect.selectBox(
                                labelText: FlutterI18n.translate(context, TranslationKeys.year),
                                options: this.widget.platformDataProvider.years,
                                notifier: _yearNotifier,
                              )
                          ),
                          SizedBox(width: 20),
                          Expanded(
                              child: ThemedSelect.selectBox(
                                labelText: FlutterI18n.translate(context, TranslationKeys.level),
                                options: this.widget.platformDataProvider.levels,
                                notifier: _levelNotifier,
                              )
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        )
    );
  }



  @override
  void dispose() {
    super.dispose();
    widget.platformDataProvider.removeListener(_onPlatformDataUpdate);
    _yearNotifier.removeListener(_shouldUpdate);
    _levelNotifier.removeListener(_shouldUpdate);
  }


}
