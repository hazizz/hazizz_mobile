import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/selected_session_bloc.dart';
import 'package:mobile/widgets/kreta_session_selector_widget.dart';

import 'kreta_session_selector_page.dart';

class KretaServiceHolder extends StatefulWidget {

  Widget child;

  KretaServiceHolder({Key key, this.child}) : super(key: key);

  @override
  _KretaServiceHolder createState() => _KretaServiceHolder();
}

class _KretaServiceHolder extends State<KretaServiceHolder> with TickerProviderStateMixin , AutomaticKeepAliveClientMixin {

  static bool sessionInactive = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: SelectedSessionBloc(),
      builder: (context, state){

        if(state is SelectedSessionEmptyState || state is SelectedSessionInactiveState ){
          return SessionSelectorWidget();
        }

        return widget.child;
      },
    );
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}