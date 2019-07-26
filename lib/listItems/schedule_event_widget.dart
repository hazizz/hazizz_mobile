import 'package:flutter/material.dart';

class ScheduleEventWidget extends StatelessWidget{

  ScheduleEventWidget();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: InkWell(
            onTap: () {
              print("tap tap");
            },
            child:
            Align(
                alignment: Alignment.centerLeft,
                child:
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                  child: Text("25 perc maradt a Matek órából", // "8 perc maradt a szünetből" "25 perc a szünetig"
                    style: TextStyle(
                        fontSize: 24
                    ),
                  ),
                )
            )
        )
    );
  }
}
