import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/extensions.dart';
import 'package:ikleeralles/logic/managers/login.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/pages/home/main.dart';
import 'package:ikleeralles/pages/register/forms/scholar.dart';
import 'package:ikleeralles/pages/register/forms/teacher.dart';
import 'package:ikleeralles/pages/register/registration.dart';
import 'package:ikleeralles/ui/loading_overlay.dart';
import 'package:ikleeralles/ui/snackbar.dart';
import 'package:scoped_model/scoped_model.dart';

class RegisterPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }

}




class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {


  TabController _tabController;

  PlatformDataProvider _platformDataProvider;

  final LoginManager _loginManager = LoginManager();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {

    _platformDataProvider = PlatformDataProvider();
    _platformDataProvider.load();

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onSignInPressed(Registration registration) {
    _loginManager.register(registration).then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) {
                return HomePage();
              }
          ),
              (route) => false
      );
    }).catchError((e) {
      showSnackBar(scaffoldKey: _scaffoldKey, message: FlutterI18n.translate(context, TranslationKeys.loginError), isError: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<PlatformDataProvider>(
      model: _platformDataProvider,
      child: ScopedModelDescendant<PlatformDataProvider>(
          builder: (BuildContext context, Widget widget, PlatformDataProvider platformDataProvider) {
            return Stack(
              children: [
                Scaffold(
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
                    body: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          Container(

                            child: TabBar(
                              tabs: <Tab>[
                                Tab(text: FlutterI18n.translate(context, TranslationKeys.scholar)),
                                Tab(text: FlutterI18n.translate(context, TranslationKeys.teacher)),
                              ],
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
                              children: [
                                ScholarRegisterForm(
                                  platformDataProvider: _platformDataProvider,
                                  onSignInPressed: onSignInPressed,
                                ),
                                TeacherRegisterForm(
                                    onSignInPressed: onSignInPressed
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                ),
                ScopedModel(
                    model: _loginManager.loadingDelegate,
                    child: ScopedModelDescendant<LoadingDelegate>(
                        builder: (BuildContext context, Widget widget, LoadingDelegate loadingDelegate) {
                          return Visibility(
                            visible: _loginManager.loadingDelegate.isLoading,
                            child: LoadingOverlay(),
                          );
                        }
                    )
                )
              ],
            );
          }
      ),
    );
  }


}