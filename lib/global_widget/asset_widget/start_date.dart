import 'package:assets_manager/component/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StartDate extends StatelessWidget {
  StartDate({
    Key? key,
    required this.stream,
    required this.sinkStartDate,
    required this.sinkEndDate,
    required this.flagStartDate,
    required this.userTime,
    required this.startDateController,
    /*this.sinkDepreciation,
    this.numberMonths,
    this.originalPrice,
    this.accumulatedDouble,*/
  }) : super(key: key);
  bool flagStartDate;
  int userTime;
  final Stream<String>? stream;
  final Sink<String>? sinkStartDate;
  final Sink<String>? sinkEndDate;
  //final Sink<String>? sinkDepreciation;
  final TextEditingController startDateController;

  // final int? numberMonths;
  // final String? originalPrice;
  // final double? accumulatedDouble;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color(0xffCED0D2),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white,
      ),
      child: StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          startDateController.value =
              startDateController.value.copyWith(text: snapshot.data);

          return GestureDetector(
            onTap: () async {
              if (flagStartDate) {
                String _pickerDate = await Alert.selectDatetime(
                  context,
                  selectedDate: snapshot.data,
                  minTime: DateTime.parse(snapshot.data),
                );
                startDateController.text = _pickerDate;
                sinkStartDate?.add(_pickerDate);
                final endDate = Alert.addMonth(userTime, _pickerDate);
                sinkEndDate?.add(endDate);
                // final depreciationDouble = Alert.onChangeDepreciation(
                //   userTimeInt: userTime,
                //   numberMonths: numberMonths,
                //   originalPrice: originalPrice,
                //   accumulatedDouble: accumulatedDouble,
                // );
                // sinkDepreciation?.add(depreciationDouble.toInt().toVND());
              }
            },
            child: Row(
              children: <Widget>[
                GlobalStyles.sizedBoxWidth,
                Icon(
                  Icons.start_outlined,
                  size: 18.0,
                  color: Colors.black54,
                ),
                GlobalStyles.sizedBoxWidth,
                Text(
                  AssetString.START_DATE,
                  style: GlobalStyles.textStyleLabelTextFormField,
                ),
                Text(
                  DateFormat('dd/ MM/ yyyy')
                      .format(DateTime.parse(snapshot.data)),
                  style: GlobalStyles.textStyleTextFormField,
                ),
                GlobalStyles.iconArrowDropDown,
              ],
            ),
          );
        },
      ),
    );
  }
}
