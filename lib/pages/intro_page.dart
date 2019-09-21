import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/google_login_bloc.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/custom/hazizz_logger.dart';
import 'package:mobile/dialogs/loading_dialog.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/managers/deep_link_receiver.dart';
import 'package:mobile/managers/welcome_manager.dart';
import 'package:mobile/navigation/business_navigator.dart';
import 'package:mobile/widgets/google_sign_in_widget.dart';
import 'package:mobile/widgets/kreta_login_widget.dart';
import 'package:mobile/widgets/notebook_background_widget.dart';
import 'package:mobile/widgets/registration_widget.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/custom/hazizz_tab_bar_view.dart';
import 'package:mobile/custom/hazizz_tab_controller.dart';
import 'package:toast/toast.dart';
import 'package:uni_links/uni_links.dart';
import '../hazizz_localizations.dart';

import "dart:math" show pi;

import '../hazizz_response.dart';
import '../hazizz_theme.dart';
import '../request_sender.dart';

class IntroPage extends StatefulWidget {

  IntroPage({Key key}) : super(key: key);

  @override
  _IntroPage createState() => _IntroPage();
}

class _IntroPage extends State<IntroPage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin{
  static const double angle = pi / 16;

  static const double dy = -86;

  HazizzTabController _tabController;

  //List<Widget> slides;

  /*
  void _handleTabSelection() {
    setState(() {

    });
  }
  */

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
            Toast.show(locText(context, key: "already_in_group"), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
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





  bool googleSignInButtonPressed = false;

  var slides;

  @override
  void initState() {

    DeepLink.initUniLinks(context);

    _tabController = new HazizzTabController(length: 4, vsync: this);
  //  _tabController.addListener(_handleTabSelection);
    super.initState();
  }



  @override
  void dispose() {
    // TODO: implement dispose

    LoginBlocs().googleLoginBloc.reset();

  //  LoginBlocs().googleLoginBloc().dispose();
    super.dispose();
  }

  Widget introPageBuilder(Widget title, Widget description, {int backgroundIndex}){
    return SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height, //-  MediaQuery.of(context).padding.top,
              //  width: MediaQuery.of(context).size.width,
                child: SvgPicture.asset(
                  "assets/images/hatter-$backgroundIndex.svg",
                  // semanticsLabel: 'Acme Logo'
                  fit: BoxFit.fitHeight,

                  height: MediaQuery.of(context).size.height -  MediaQuery.of(context).padding.top,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            //    width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          SafeArea(
                            child: Container(
                              // height: 100,
                                child: NotebookBackgroundWidget()
                            ),
                          ),
                          Center(child: title)
                        ],
                      ),
                   // description,
                      Expanded(child: description)
                    ],
                  ),
                ),
              ),
            ],
          ),

      );
  }

  @override
  Widget build(BuildContext context) {

    void nextPage(){
      _tabController.animateTo(_tabController.index+1,  duration: Duration(milliseconds:  2000));
    }


    EdgeInsets padding = MediaQuery.of(context).padding;
    double height = MediaQuery.of(context).size.height;

    double height1 = height - padding.top - padding.bottom;

    // 5 db
    List<Color> gradientColor = [HazizzTheme.blue, Colors.green, Colors.yellow,  Colors.red, HazizzTheme.blue];

    int _counter = 0;

    /*
    Widget pageGenerator(Widget content, {bool withSingleChildScrollView} ){

      Widget decorWidget;

      if(_counter%2 == 0){
        decorWidget = decorBottomToTop(gradientColor[_counter], gradientColor[_counter+1]);
      }else{
        decorWidget = decorTopToBottom(gradientColor[_counter], gradientColor[_counter+1]);
      }
      _counter++;

      if(withSingleChildScrollView == true){
        return Stack(
          //  fit: StackFit.,
            children: [
              SingleChildScrollView(
                child: Container(
                  height: height1,//-appBar.preferredSize.height - padding*3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      decorWidget,
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                  child: content
              )
            ]
        );
      }

      return Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: height1,//-appBar.preferredSize.height - padding*3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    decorWidget,
                  ],
                ),
              ),
            ),
             content
          ]
      );
    }
    */

    slides = [
      Builder(
        builder: (context){
          GoogleSignInButtonWidget googleSignInButtonWidget = GoogleSignInButtonWidget();

          return BlocBuilder(
              bloc: LoginBlocs().googleLoginBloc,
              builder: (context, state){

                bool _isLoading;

                HazizzLogger.printLog("log: ggoogle: $state");

                // ProgressDialog pg;
                //  pg = new ProgressDialog(context,ProgressDialogType.Normal);


                if(state is GoogleLoginSuccessfulState && !googleSignInButtonPressed){
                  _isLoading = false;

                  if(joinLater){
                    joinGroup();

                  }

                  AppState.mainAppPartStartProcedure();
                  nextPage();
                }else if(state is GoogleLoginWaitingState/* || state is GoogleLoginFineState && googleSignInButtonWidget.googleLoginBloc*/){
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
                  ), Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Center(
                            child: Text(locText(context, key: "hazizz_intro"), style: TextStyle(fontSize: 19), textAlign: TextAlign.center)
                        ),
                      ),

                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: googleSignInButtonWidget,
                      ),
                    )
                  ],),
                    backgroundIndex: 1,
                  ),
                  show: _isLoading,
                );
              }
          );
        },
      ),

      introPageBuilder(Padding(
            padding: const EdgeInsets.only(top: 44.0),
            child: Text(locText(context, key: "about_group_title"), style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800), textAlign: TextAlign.center,),
          ),
            Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 8, right:8),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[

                    // Text(locText(context, key: "login"), style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: HazizzTheme.blue, ),),

                    Text(locText(context, key: "about_group_description1"), style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(child: Text(locText(context, key: "create_group").toUpperCase()), onPressed: () async {
                        bool success = await showCreateGroupDialog(context);
                        if(success){
                          Toast.show(locText(context, key: "group_created"), context, duration: 2);
                          nextPage();
                        }
                      },),
                    ),

                     Text(locText(context, key: "about_group_description2"), style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),

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
                        WelcomeManager.haveSeenIntro();

                        Navigator.pushReplacementNamed(context, "/");
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

    /*
      pageGenerator(
          SingleChildScrollView(
            child: Container(
              height: height1,
              child: Stack(
                children: <Widget>[
                  Center(
                    child:

                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 35.0, bottom: 0),
                          child: Text(locText(context, key: "ekreta"), style: TextStyle(fontSize: 80, fontWeight: FontWeight.w800, color: HazizzTheme.blue, ),),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 60, left: 24.0, right: 24),
                          child: Center(
                              child: Text(locText(context, key: "kreta_intro"), style: TextStyle(fontSize: 22, ), textAlign: TextAlign.center,)
                          ),
                        ),
                      ],
                    )
                  ),


                  Positioned(
                    left: 4,
                    bottom: 8,
                    child: FlatButton(child: Text(locText(context, key: "skip").toUpperCase()),
                      onPressed: () async {
                        if(await showIntroCancelDialog(context)){
                          WelcomeManager.haveSeenIntro();

                          Navigator.pushReplacementNamed(context, "/");
                        }
                      },
                    ),

                  ),

                  Positioned(
                      bottom: 12,
                      right: 14,
                      child:
                      FloatingActionButton(child: Icon(FontAwesomeIcons.chevronRight),
                        onPressed: (){
                          nextPage();
                        },
                      )
                  )
                ],
              ),
            ),
          ),
      ),
      */

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
              //  Navigator.pushReplacementNamed(context, "/");
                HazizzLogger.printLog("HazizzLog: Navigation with businessNavigator -> to main app");
                BusinessNavigator().currentState().pushReplacementNamed('/',);


              },
            ),
          ),
          Spacer(),
          Row(
            children: <Widget>[
              FlatButton(child: Text(locText(context, key:  "skip").toUpperCase()),
                onPressed: () async {
                  if(await showIntroCancelDialog(context)){
                    WelcomeManager.haveSeenIntro();

                    Navigator.pushReplacementNamed(context, "/");
                  }
                },
              ),
            ],
          )
        ],),
      ),
      backgroundIndex: 2,),

    /*
      pageGenerator(

            Container(
              height: height1,
              child: Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Stack(
                  children: <Widget>[
                    KretaLoginWidget(
                      onSuccess: (){
                        Navigator.popAndPushNamed(context, "/");
                      },
                    ),

                    Positioned(
                      bottom: 8,
                      left: 4,
                      child:
                      FlatButton(child: Text(locText(context, key:  "skip").toUpperCase()),
                        onPressed: () async {
                          if(await showIntroCancelDialog(context)){
                            WelcomeManager.haveSeenIntro();

                            Navigator.pushReplacementNamed(context, "/");
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),

          withSingleChildScrollView: true
      ),
      */
    ];

    return WillPopScope(
      onWillPop: _onWillPop,

      child: Scaffold(
       //   resizeToAvoidBottomPadding: false,
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
    /*
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
    */
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


