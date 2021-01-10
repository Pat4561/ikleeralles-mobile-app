import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/ui/themed/button.dart';
import 'package:ikleeralles/ui/themed/select.dart';
import 'package:ikleeralles/ui/themed/textfield.dart';

class RegisterPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }

}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {


  Validators _validators;

  TabController _tabController;

  TextEditingController usernameTextController = TextEditingController();

  final List<Tab> _tabs = <Tab>[
    Tab(text: 'Scholier'),
    Tab(text: 'Docent'),
  ];


  @override
  void initState() {

    _tabController = TabController(vsync: this, length: _tabs.length);
    _validators = Validators(context);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onSignInPressed() {

  }

  Widget _usernameTextField() {
    return ThemedTextField(
      labelText: FlutterI18n.translate(context, TranslationKeys.username),
      labelColor: Colors.black,
      borderRadius: 15,
      borderColor: Color.fromRGBO(210, 210, 210, 1),
      validator: _validators.notEmptyValidator,
    );
  }

  Widget _passwordTextField() {
    return ThemedTextField(
      labelText: FlutterI18n.translate(context, TranslationKeys.password),
      labelColor: Colors.black,
      borderRadius: 15,
      borderColor: Color.fromRGBO(210, 210, 210, 1),
      validator: _validators.notEmptyValidator,
    );
  }

  Widget _yearSelector() {
    return Container(

      child: ThemedSelect(
          placeholder: "1",
          labelText: FlutterI18n.translate(context, TranslationKeys.year),
          boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            border: Border.all(
              color: Color.fromRGBO(210, 210, 210, 1),
              width: 2
            )
          ),
          height: 48,
          textColor: Colors.black,
          color: Colors.transparent,
          onPressed: (BuildContext context) {

          }
      ),
    );
  }

  Widget _levelSelector() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: ThemedSelect(
          placeholder: "Havo",
          labelText: FlutterI18n.translate(context, TranslationKeys.level),
          boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                  color: Color.fromRGBO(210, 210, 210, 1),
                  width: 2
              )
          ),
          height: 48,
          textColor: Colors.black,
          color: Colors.transparent,
          onPressed: (BuildContext context) {

          }
      ),
    );
  }


  Widget _emailTextField() {
    return ThemedTextField(
      labelText: FlutterI18n.translate(context, TranslationKeys.email),
      labelColor: Colors.black,
      borderRadius: 15,
      borderColor: Color.fromRGBO(210, 210, 210, 1),
      validator: _validators.notEmptyValidator,
    );
  }




  Widget _signUpButton() {
    return Container(
      child: ThemedButton(
        FlutterI18n.translate(context, TranslationKeys.signIn),
        buttonColor: BrandColors.primaryButtonColor,
        labelColor: Colors.white,
        fontSize: 17,
        contentPadding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        onPressed: _onSignInPressed,
      ),
      margin: EdgeInsets.only(
        top: 10
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          FlutterI18n.translate(context, TranslationKeys.register),
          style: TextStyle(
            color: Colors.white,
            fontFamily: Fonts.ubuntu,
            fontWeight: FontWeight.bold,
            fontSize: 17
          ),
        ),
      ),
      body: Column(
        children: [
          Container(

            child: TabBar(
              controller: _tabController,
              tabs: _tabs,
              unselectedLabelColor: Colors.black45,
              labelColor: BrandColors.themeColor,
              labelStyle: TextStyle(
                fontSize: 15,
                fontFamily: Fonts.ubuntu
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  child: ListView(
                    padding: EdgeInsets.all(15),
                    children: [
                      _usernameTextField(),
                      _passwordTextField(),
                      _emailTextField(),
                      _yearSelector(),
                      _levelSelector(),
                      _signUpButton()
                    ],
                  ),
                ),
                Container(
                  child: Form(child: ListView(
                    padding: EdgeInsets.all(15),
                    children: [
                      _usernameTextField(),
                      _passwordTextField(),
                      _emailTextField(),
                      _signUpButton()
                    ],
                  )),
                )
              ],
            ),
          )
        ],
      )
    );
  }


}