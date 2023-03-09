import '../state/import.dart';
import 'package:oshichokin_front/config/size_config.dart';
import 'package:fl_chart/fl_chart.dart';

class donuts{
  
  chart(sum, goal, x, y,Color chartcolor) {
  if (sum == 0) {
    sum = 1;
  }
  if (goal == 0) {
    goal = 1;
  }

  return Container(
    width: WindowSize.w! * x,
    height: WindowSize.h! * y,
    child: Stack(
      alignment: AlignmentDirectional.center,
      clipBehavior: Clip.none,
      children: [
        PieChart(
          PieChartData(
            startDegreeOffset: 270,
            centerSpaceRadius: WindowSize.w! * (x - 60),
            centerSpaceColor: chartcolor,
            sections: [
              PieChartSectionData(
                borderSide: BorderSide(width: 0),
                color: chartcolor,
                value: sum / goal * 100, //ここの値をfirebaseで変更
                radius: WindowSize.w! * 2,
                title: '',
              ),
              
              PieChartSectionData(
                borderSide: BorderSide(width: 0),
                color: Colors.white,
                value: (1 - sum / goal) * 100, //ここの値をfirebaseで変更
                radius: WindowSize.w! * 2,
                title: '',
              ),
            ],
            sectionsSpace: 0,
          ),
        ),
      ],
    ),
  );
}
}

