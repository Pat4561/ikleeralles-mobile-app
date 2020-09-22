import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/ui/bottomsheets/options.dart';

class SearchTextField extends StatelessWidget {

  final String hint;
  final TextEditingController textEditingController;
  final Function(String) onChanged;
  final Function(String) onSubmitted;

  SearchTextField ({ this.hint, this.textEditingController, this.onChanged, this.onSubmitted });

  InputBorder inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: BrandColors.lightGreyBackgroundColor),
      borderRadius: BorderRadius.circular(8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      style: TextStyle(
          fontSize: 14,
          fontFamily: Fonts.ubuntu
      ),
      onSubmitted: this.onSubmitted,
      onChanged: this.onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: BrandColors.lightGreyBackgroundColor,
        prefixIcon: Padding(
          padding: EdgeInsets.all(0),
          child: Container(
            height: 40,
            width: 40,
            child: Center(
              child: Icon(
                Icons.search,
                size: 24,
                color: BrandColors.textColorLighter,
              ),
            ),
          ),
        ),
        contentPadding: EdgeInsets.only(left: 14.0, bottom: 12.0, top: 0.0),
        focusedBorder: inputBorder(),
        hintText: hint,
        enabledBorder: inputBorder(),
      ),
    );
  }

}


class SelectBox extends StatelessWidget  {

  final String labelText;
  final String placeholder;
  final double height;
  final double iconContainerWidth;
  final Function onPressed;


  SelectBox ({ @required this.placeholder, this.labelText, this.height = 24, this.iconContainerWidth = 30, this.onPressed });

  TextStyle textStyle({ FontWeight fontWeight = FontWeight.bold, double fontSize = 14, Color color = Colors.white}) {
    return TextStyle(
        color: color,
        fontFamily: Fonts.ubuntu,
        fontSize: fontSize,
        fontWeight: fontWeight
    );
  }

  Widget button(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              10
          ),
          color: Colors.white
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: height,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                      child: Text(this.placeholder, style: textStyle(
                          color: BrandColors.textColorLighter
                      )),
                      margin: EdgeInsets.only(
                          left: 12
                      ),
                    )
                ),
                Container(
                  width: iconContainerWidth,
                  height: height,
                  margin: EdgeInsets.only(
                      right: 5
                  ),
                  child: Icon(Icons.keyboard_arrow_down),
                )
              ],
            ),
          ),
          onTap: () {
            onPressed(context);
          },
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    if (this.labelText != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(this.labelText, style: textStyle()),
          button(context)
        ],
      );
    } else {
      return button(context);
    }
  }

}

class _SearchAppBar extends StatefulWidget implements PreferredSizeWidget  {

  final List<String> years;
  final List<String> levels;
  final Function(String search, String year, String level) onPerformSearch;

  _SearchAppBar ({ @required this.years, @required this.levels, @required this.onPerformSearch });

  @override
  State<StatefulWidget> createState() {
    return _SearchAppBarState();
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(155);
  }
}

class _SearchAppBarState extends State<_SearchAppBar>  {



  ValueNotifier<String> _yearNotifier;
  ValueNotifier<String> _levelNotifier;

  final TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _yearNotifier = ValueNotifier<String>(widget.years.first);
    _levelNotifier = ValueNotifier<String>(widget.levels.first);

    _yearNotifier.addListener(_shouldUpdate);
    _levelNotifier.addListener(_shouldUpdate);

  }

  void _shouldUpdate() {

  }

  Widget selectBox({ String labelText, ValueNotifier<String> notifier, List<String> options }) {
    return ValueListenableBuilder(
        valueListenable: notifier,
        builder: (BuildContext context, String value, Widget widget) {
          return SelectBox(
              placeholder: notifier.value,
              labelText: labelText,
              onPressed: (BuildContext context) {
                OptionsBottomSheetPresenter<String>(
                    title: labelText,
                    items: options,
                    selectedItem: notifier.value,
                    onPressed: (item) {
                      Navigator.pop(context);
                      notifier.value = item;
                    }
                ).show(context);
              }
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 8,
      leading: Container(),
      flexibleSpace: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 75,
              child: Row(
                children: <Widget>[
                  Visibility(
                    child: Container(
                      width: 64,
                      child: IconButton(
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
                          child: SearchTextField(
                            hint: "Wat zoek je?",
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
              color: BrandColors.secondaryButtonColor,
              height: 80,
              padding: EdgeInsets.symmetric(
                  horizontal: 20
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: selectBox(
                        labelText: "Jaar",
                        options: this.widget.years,
                        notifier: _yearNotifier,
                      )
                  ),
                  SizedBox(width: 20),
                  Expanded(
                      child: selectBox(
                        labelText: "Opleiding",
                        options: this.widget.levels,
                        notifier: _levelNotifier,
                      )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }



  @override
  void dispose() {
    super.dispose();

    _yearNotifier.removeListener(_shouldUpdate);
    _levelNotifier.removeListener(_shouldUpdate);
  }


}

class SearchPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }

}


class _SearchPageState extends State<SearchPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _SearchAppBar(
        years: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Anders"],
        levels: ["basisschool","vwo","havo","vmbo-t","vmbo-gt","vmbo-k","vmbo-b","a","a2/b1","lwoo/vmbo-b","lwoo/vmbo-bk","vmbo-b/lwoo","vmbo-gt/havo","vmbo-kgt/havo","vmbo-t/havo","havo/vwo","mbo","universiteit","vavo","cursus"],
        onPerformSearch: (String search, String year, String level) {

        }
      )
    );
  }

}