import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/auth/social_login_bloc.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/dialogs/loading_dialog.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/managers/deep_link_controller.dart';
import 'package:mobile/managers/welcome_manager.dart';
import 'package:mobile/navigation/business_navigator.dart';
import 'package:mobile/widgets/google_sign_in_widget.dart';
import 'package:mobile/widgets/kreta_login_widget.dart';
import 'package:mobile/widgets/notebook_background_widget.dart';
import 'package:mobile/dialogs/dialogs_collection.dart';
import 'package:mobile/custom/hazizz_tab_bar_view.dart';
import 'package:mobile/custom/hazizz_tab_controller.dart';
import 'package:mobile/custom/hazizz_localizations.dart';
import "dart:math" show pi;
import 'package:mobile/communication/hazizz_response.dart';
import 'package:mobile/theme/hazizz_theme.dart';
import 'package:mobile/communication/request_sender.dart';

class IntroPage extends StatefulWidget {

  IntroPage({Key key}) : super(key: key);

  @override
  _IntroPage createState() => _IntroPage();
}

class _IntroPage extends State<IntroPage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin{
  static const double angle = pi / 16;

  static const double dy = -86;

  HazizzTabController _tabController;

  bool joinLater = false;

  bool processingDeepLink = false;

  Future joinGroup() async {
    HazizzResponse hazizzResponse = await RequestSender().getResponse(RetrieveGroup.withoutMe(p_groupId: groupId));

    if(hazizzResponse.isSuccessful){
      PojoGroupWithoutMe groupWithoutMe = hazizzResponse.convertedData;
      if(groupWithoutMe != null){
        HazizzLogger.printLog("GROUPCOUNT: ${ groupWithoutMe.userCount}, ${ groupWithoutMe.userCountWithoutMe}");
        if(groupWithoutMe.userCount == groupWithoutMe.userCountWithoutMe){

          WidgetsBinding.instance.addPostFrameCallback((_) =>
              showJoinedGroupDialog(context, group: groupWithoutMe)
          );

        }else{
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showToast(locText(context, key: "already_in_group"), duration: Duration(seconds: 3));

           // Toast.show(locText(context, key: ""), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          });
        }
        setState(() {
          processingDeepLink = false;
        });
      }else{
        setState(() {
          processingDeepLink = false;
        });
      }
    }else{
      setState(() {
        processingDeepLink = false;
      });
    }
  }

  int groupId;

  List<Widget> slides;

  @override
  void initState() {
    DeepLinkController.initUniLinks(context);
    _tabController = new HazizzTabController(length: 4, vsync: this);
    super.initState();
  }


  @override
  void dispose() {
    LoginBlocs().googleLoginBloc.reset();
    super.dispose();
  }

  Widget introPageBuilder(Widget title, Widget description, {int backgroundIndex, bool scrollMode = false}){
    Widget child = Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          child: SvgPicture.asset(
            "assets/images/hatter-$backgroundIndex.svg",
            fit: BoxFit.fitHeight,

            height: MediaQuery.of(context).size.height -  MediaQuery.of(context).padding.top,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,

          child: Column(
            children: <Widget>[
              Container(
                //  height: MediaQuery.of(context).size.height,

                child: Stack(
                  children: <Widget>[
                    SafeArea(
                      child: Container(
                          child: NotebookBackgroundWidget()
                      ),
                    ),
                    Center(child: title)
                  ],
                ),
              ),
              Expanded(child: description)
            ],
          ),
        ),
      ],
    );

    return scrollMode ?
    SingleChildScrollView(
        child: child
    ) :
    Container(
    //  height: MediaQuery.of(context).size.height,
      child: child
    );
  }

  void exitIntro(){
    WelcomeManager.haveSeenIntro();
    BusinessNavigator().state().pushReplacementNamed('/',);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final autoSizeGroup = AutoSizeGroup();

    void nextPage(){
      _tabController.animateTo(_tabController.index+1,  duration: Duration(milliseconds:  2000));
    }

    slides = [
      Builder(
        builder: (context){
          SocialSignInButtonWidget googleSignInButtonWidget = SocialSignInButtonWidget.google();
          SocialSignInButtonWidget facebookSignInButtonWidget = SocialSignInButtonWidget.facebook();
          return BlocBuilder(
            bloc: LoginBlocs().googleLoginBloc,
            builder: (context, state){
              return BlocBuilder(
                  bloc: LoginBlocs().facebookLoginBloc,
                  builder: (context, state2){
                    bool _isLoading;
                    HazizzLogger.printLog("log: ggoogle: $state");

                    if(state is SocialLoginSuccessfulState || state2 is SocialLoginSuccessfulState ){
                      _isLoading = false;

                      if(joinLater){
                        joinGroup();
                      }

                      AppState.mainAppPartStartProcedure();
                      nextPage();
                    }
                    else if(state is SocialLoginWaitingState || state2 is SocialLoginWaitingState/* || state is GoogleLoginFineState && googleSignInButtonWidget.googleLoginBloc*/){
                      _isLoading = true;

                    }else{
                      _isLoading = false;
                    }

                    return LoadingDialog(
                      child: introPageBuilder(Transform.translate(
                        offset: const Offset(0.0, -30.0),
                        child: Container(
                          // padding: const EdgeInsets.all(8.0),
                          //  color: const Color(0xFF7F7F7F),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Image.asset(
                              'assets/images/Logo.png',
                            ),
                          ),
                        ),
                      ),
                        Container(
                         height: MediaQuery.of(context).size.height,

                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,

                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.height * 0.4 ,

                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8),
                                  child: AutoSizeText(
                                    locText(context, key: "hazizz_intro"),
                                      style: TextStyle(fontSize: 20),
                                   //   maxLines: 10,
                                      maxFontSize: 20,
                                      minFontSize: 8,
                                      textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  googleSignInButtonWidget,
                                  facebookSignInButtonWidget
                                ],
                              ),
                            ],
                          ),
                        ),
                        backgroundIndex: 1,
                      ),
                      show: _isLoading,
                    );
                  }
              );
            }
          );
        },
      ),

      introPageBuilder(
          Padding(
            padding: const EdgeInsets.only(top: 42, left: 6, right: 6),
            child: AutoSizeText(
              locText(context, key: "about_group_title"),
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w800),
              minFontSize: 20,
              maxFontSize: 50,
              maxLines: 1,
              textAlign: TextAlign.center,),


          ),
            Padding(
                padding: const EdgeInsets.only(top: 48, left: 8, right:8),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    AutoSizeText(
                      locText(context, key: "about_group_description1"),
                      group: autoSizeGroup,
                      style: TextStyle(fontSize: 20),
                      minFontSize: 10,
                      maxFontSize: 20,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(child: Text(locText(context, key: "create_group").toUpperCase()), onPressed: () async {
                        bool success = await showCreateGroupDialog(context);
                        if(success != null && success){
                          showToast(locText(context, key: "group_created"), duration: Duration(seconds: 3));

                        //  Toast.show(locText(context, key: ""), context, duration: 2);
                          nextPage();
                        }
                      },
                      ),
                    ),
                    AutoSizeText(
                      locText(context, key: "about_group_description2"),
                      group: autoSizeGroup,
                      style: TextStyle(fontSize: 20),
                      minFontSize: 10,
                      maxFontSize: 20,
                      maxLines: 5,
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FloatingActionButton(child: Icon(FontAwesomeIcons.chevronRight),
                            onPressed: (){
                              nextPage();
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            backgroundIndex: 2
          ),

      introPageBuilder(Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(locText(context, key: "ekreta"), style: TextStyle(fontSize: 80, fontWeight: FontWeight.w800, color: HazizzTheme.blue, )),
      ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 8.0, right: 8),
                child: Center(
                    child: Text(locText(context, key: "kreta_intro"), style: TextStyle(fontSize: 20, ), textAlign: TextAlign.center,)
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FlatButton(child: Text(locText(context, key: "skip").toUpperCase()),
                    onPressed: () async {
                      if(await showIntroCancelDialog(context)){
                        exitIntro();
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FloatingActionButton(child: Icon(FontAwesomeIcons.chevronRight),
                      onPressed: (){
                        nextPage();
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        backgroundIndex: 3
      ),
    introPageBuilder(
      Padding(
       padding: const EdgeInsets.only(top: 20.0, bottom: 0),
       child: Text(locText(context, key: "ekreta"), style: TextStyle(fontSize: 80, fontWeight: FontWeight.w800, color: HazizzTheme.blue, ),),
      ) ,
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0.0, bottom: 10),
            child: Text(locText(context, key: "login"), style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: HazizzTheme.blue),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: KretaLoginWidget(
              onSuccess: (){
                exitIntro();
              },
            ),
          ),
          Spacer(),
          Row(
            children: <Widget>[
              FlatButton(child: Text(locText(context, key:  "skip").toUpperCase()),
                onPressed: () async {
                  if(await showIntroCancelDialog(context)){
                    exitIntro();
                  }
                },
              ),
            ],
          )
        ],),
      ),
      backgroundIndex: 2, scrollMode: true
    ),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,

      child: Scaffold(
        body: SafeArea(
          child: HazizzTabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: slides,
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return await false;
  }

  @override
  bool get wantKeepAlive => true;
}


