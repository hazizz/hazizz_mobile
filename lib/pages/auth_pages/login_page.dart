
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/auth/google_login_bloc.dart';
import 'package:mobile/blocs/auth/login_bloc.dart';
import 'package:mobile/blocs/auth/social_login_bloc.dart';
import 'package:mobile/dialogs/loading_dialog.dart';
import 'package:mobile/widgets/login_widget.dart';

class LoginPage extends StatefulWidget {

  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder(
          bloc: LoginBlocs().googleLoginBloc,
          builder: (context, state){
            return BlocBuilder(
              bloc: LoginBlocs().facebookLoginBloc,
              builder: (context2, state2){

                if(state is SocialLoginWaitingState || state2 is SocialLoginWaitingState){
                  _isLoading = true;
                }else{
                  _isLoading = false;
                }
                return LoadingDialog(
                child: LoginWidget(),
                show: _isLoading,
                );

              },
            );
          },
        )
    );
  }
}
