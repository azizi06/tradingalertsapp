import 'package:flutter/material.dart';
import 'package:stocksalertapp/models/candel_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyCandelchart extends StatefulWidget {
  late List<CandelModel> chartData;

  MyCandelchart({super.key, required this.chartData});

  @override
  State<MyCandelchart> createState() => _MyCandelchartState();
}

class _MyCandelchartState extends State<MyCandelchart> {
  late TrackballBehavior _trackballBehavior;
  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      trackballBehavior: _trackballBehavior,
      zoomPanBehavior: ZoomPanBehavior(enablePinching: true,),
      primaryXAxis: DateTimeAxis(),
      series: <CandleSeries>[
        CandleSeries<CandelModel, DateTime>(
            dataSource: widget.chartData,
            xValueMapper: (CandelModel sales, _) => sales.time,
            lowValueMapper: (CandelModel sales, _) => sales.low,
            highValueMapper: (CandelModel sales, _) => sales.high,
            openValueMapper: (CandelModel sales, _) => sales.open,
            closeValueMapper: (CandelModel sales, _) => sales.close)
      ],
    );
    ;
  }
}
