import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/google_login_bloc.dart';
import 'package:mobile/communication/pojos/PojoGroup.dart';
import 'package:mobile/communication/requests/request_collection.dart';
import 'package:mobile/dialogs/loading_dialog.dart';
import 'package:mobile/managers/app_state_manager.dart';
import 'package:mobile/managers/welcome_manager.dart';
import 'package:mobile/widgets/google_sign_in_widget.dart';
import 'package:mobile/widgets/kreta_login_widget.dart';
import 'package:mobile/widgets/notebook_background_widget.dart';
import 'package:mobile/widgets/registration_widget.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/custom/hazizz_tab_bar_view.dart';
import 'package:mobile/custom/hazizz_tab_controller.dart';
import 'package:progress_dialog/progress_dialog.dart';
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
        print("GROUPCOUNT: ${ groupWithoutMe.userCount}, ${ groupWithoutMe.userCountWithoutMe}");
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

  void onLinkReceived(Uri deepLink) async{

    print("DEEP LINK RECEIVED: ${deepLink.toString()}");
    if (deepLink != null) {
      setState(() {
        setState(() {
          processingDeepLink = true;
        });
      });
      String str_groupId = deepLink.queryParameters["group"];

      groupId = int.parse(str_groupId);
      if(groupId != null){
        if(await AppState.isLoggedIn()){
          joinGroup();
        }else{
          WidgetsBinding.instance.addPostFrameCallback((_) {
            joinLater= true;
            Toast.show(locText(context, key: "you_have_to_log_in_to_join"), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          });
        }


      }else{
        setState(() {
          processingDeepLink = false;
        });
      }
    }
  }


  StreamSubscription _sub;

  Future<Null> initUniLinks() async {
    Uri initialUri = await getInitialUri();


    onLinkReceived(initialUri);
    // Attach a listener to the stream
    _sub = getUriLinksStream().listen((Uri uri) {
      onLinkReceived(uri);
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }




  bool googleSignInButtonPressed = false;

  var slides;

  @override
  void initState() {

    initUniLinks();

    _tabController = new HazizzTabController(length: 4, vsync: this);
  //  _tabController.addListener(_handleTabSelection);
    super.initState();
  }



  @override
  void dispose() {
    // TODO: implement dispose
    _sub.cancel();

    LoginBlocs().googleLoginBloc.reset();

  //  LoginBlocs().googleLoginBloc().dispose();
    super.dispose();
  }

  Widget introPageBuilder(Widget title, Widget description, {int backgroundIndex}){
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height -  MediaQuery.of(context).padding.top,
            width: MediaQuery.of(context).size.width,
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
            width: MediaQuery.of(context).size.width,
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
                Expanded(child: description)
              ],
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

    Widget decorBottomToTop(Color decorColor1, Color decorColor2 ){
      return Transform.scale(
        scale: 1.2,
        child: Transform.rotate(
          alignment: Alignment.topRight,
          angle: -angle,
          child: Transform.translate(
            offset: Offset(-0, dy),
            child: Container(

              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [decorColor1, decorColor2]),
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 6,
                      color: Colors.grey,
                      blurRadius: 50.0,
                    ),
                  ]
              ),
              height: MediaQuery.of(context).size.height/100*18/1.2,
              width:  MediaQuery.of(context).size.width*10,
            ),
          ),
        ),
      );
    }

    Widget decorTopToBottom(Color decorColor1, Color decorColor2 ){
      return Transform.scale(
        scale: 1.2,
        child: Transform.rotate(
          alignment: Alignment.topLeft,
          angle: angle,
          child: Transform.translate(
            offset: Offset(-0, dy),
            child: Container(
              decoration: BoxDecoration(
                // shape: BoxShape.circle, // BoxShape.circle or BoxShape.retangle
                  gradient: LinearGradient(colors: [decorColor1, decorColor2 ]),
                  // introPageBuilderBlendMode: BlendMode.colorBurn,
                 // color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 6,
                      color: Colors.grey,
                      blurRadius: 50.0,
                    ),
                  ]
              ),
              height: MediaQuery.of(context).size.height/100*18/1.2,
              width:  MediaQuery.of(context).size.width*10,
            ),
          ),
        ),
      );
    }

    EdgeInsets padding = MediaQuery.of(context).padding;
    double height = MediaQuery.of(context).size.height;

    double height1 = height - padding.top - padding.bottom;

    // 5 db
    List<Color> gradientColor = [HazizzTheme.blue, Colors.green, Colors.yellow,  Colors.red, HazizzTheme.blue];

    int _counter = 0;

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

    slides = [
      pageGenerator(

        Builder(
          builder: (context){
            GoogleSignInButtonWidget googleSignInButtonWidget = GoogleSignInButtonWidget();

            return BlocBuilder(
                bloc: LoginBlocs().googleLoginBloc,
                builder: (context, state){

                  bool _isLoading;

                  print("log: ggoogle: $state");

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
                        padding: const EdgeInsets.only(left: 12.0, right: 12),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 12.0, right: 12),
                            child: Center(
                                child: Text(locText(context, key: "hazizz_intro"), style: TextStyle(fontSize: 22), textAlign: TextAlign.center)
                            ),
                          ),

                      ),

                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: googleSignInButtonWidget,
                      )
                    ],),
                    backgroundIndex: 1
                    ),
                    show: _isLoading,
                  );
                }
            );
          },
        ),



      ),

      pageGenerator(

          introPageBuilder(Padding(
            padding: const EdgeInsets.only(top: 44.0),
            child: Text(locText(context, key: "about_group_title"), style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800), textAlign: TextAlign.center,),
          ),
            Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 30, right: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[

                    // Text(locText(context, key: "login"), style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: HazizzTheme.blue, ),),

                    Text(locText(context, key: "about_group_description1"), style: TextStyle(fontSize: 22), textAlign: TextAlign.center,),


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

                     Text(locText(context, key: "about_group_description2"), style: TextStyle(fontSize: 22), textAlign: TextAlign.center,),

                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
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
          withSingleChildScrollView: true
      ),

    /*
      pageGenerator(
        Builder(
          builder: (context){
            GoogleSignInButtonWidget googleSignInButtonWidget = GoogleSignInButtonWidget();

            return BlocBuilder(
              bloc: LoginBlocs().googleLoginBloc,
              builder: (context, state){

                bool _isLoading;

                print("log: ggoogle: $state");

               // ProgressDialog pg;
              //  pg = new ProgressDialog(context,ProgressDialogType.Normal);


                if(state is GoogleLoginSuccessfulState && !googleSignInButtonPressed){
                  _isLoading = false;

                  nextPage();
                }else if(state is GoogleLoginWaitingState/* || state is GoogleLoginFineState && googleSignInButtonWidget.googleLoginBloc*/){
                /*  Future.delayed(Duration.zero,() => setState(() {
                    print("asd: is true");
                    _isLoading = true;
                  }));
                  */

                  _isLoading = true;



                  // Future.delayed(Duration.zero,() => pg.show());

                }else{
                //  if(pg.isShowing())
                //    Future.delayed(Duration.zero,() => pg.hide());
                  _isLoading = false;

                  /*
                  WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                    print("asd: is true");
                    _isLoading = false;
                  }));
                  */

                }


                return LoadingDialog(
                  child: Column(
                    children: <Widget>[
                      RegistrationWidget(),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(locText(context, key: "or").toUpperCase()),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: googleSignInButtonWidget
                      ),
                    ],
                  ),
                  show: _isLoading,
                );
              }
            );
          },
        ),
        withSingleChildScrollView: true
      ),
      */

      introPageBuilder(Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(locText(context, key: "ekreta"), style: TextStyle(fontSize: 80, fontWeight: FontWeight.w800, color: HazizzTheme.blue, )),
      ),
          Column(
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(top: 60, left: 24.0, right: 24),
                child: Center(
                    child: Text(locText(context, key: "kreta_intro"), style: TextStyle(fontSize: 22, ), textAlign: TextAlign.center,)
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
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0.0, bottom: 30),
            child: Text(locText(context, key: "login"), style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: HazizzTheme.blue),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: KretaLoginWidget(
              onSuccess: (){
                Navigator.popAndPushNamed(context, "/");
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


