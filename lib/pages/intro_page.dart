import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/blocs/google_login_bloc.dart';
import 'package:mobile/dialogs/loading_dialog.dart';
import 'package:mobile/widgets/google_sign_in_widget.dart';
import 'package:mobile/widgets/kreta_login_widget.dart';
import 'package:mobile/widgets/registration_widget.dart';
import 'package:mobile/dialogs/dialogs.dart';
import 'package:mobile/custom/hazizz_tab_bar_view.dart';
import 'package:mobile/custom/hazizz_tab_controller.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../hazizz_localizations.dart';

import "dart:math" show pi;

import '../hazizz_theme.dart';

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

  bool googleSignInButtonPressed = false;

  var slides;

  @override
  void initState() {
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
                  // backgroundBlendMode: BlendMode.colorBurn,
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
        Center(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/Logo.png',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 50),
                    child: Center(
                        child: Text(locText(context, key: "hazizz_intro"), style: TextStyle(fontSize: 22), textAlign: TextAlign.center)
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 12,
                bottom: 14,
                child:
                FloatingActionButton(child: Icon(FontAwesomeIcons.chevronRight),
                  onPressed: (){
                    nextPage();
                  },
                ),
              )


            ],
          ),
        ),
      ),

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

      pageGenerator(
          SingleChildScrollView(
            child: Container(
              height: height1,
              child: Stack(
                children: <Widget>[
                  Center(
                    child:
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, right: 50),
                      child: Center(
                          child: Text(locText(context, key: "kreta_intro"), style: TextStyle(fontSize: 22, ), textAlign: TextAlign.center,)
                      ),
                    ),
                  ),


                  Positioned(
                    left: 4,
                    bottom: 8,
                    child: FlatButton(child: Text(locText(context, key: "skip").toUpperCase()),
                      onPressed: () async {
                        if(await showIntroCancelDialog(context)){
                          Navigator.pop(context);
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

      pageGenerator(
          Container(
            height: height1,
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
                        Navigator.pop(context);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          withSingleChildScrollView: true
      ),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,

      child: Scaffold(
       //   resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: HazizzTabBarView(
            physics: AlwaysScrollableScrollPhysics(),
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


