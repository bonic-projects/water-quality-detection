import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import 'package:wqd_flutter/ui/smart_widgets/online_status.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      // onViewModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        // print(model.node?.lastSeen);
        return Scaffold(
          appBar: AppBar(
            title: const Text('WQD'),
            actions: [
              const IsOnlineWidget(),
              IconButton(
                  onPressed: model.logout, icon: const Icon(Icons.logout)),
            ],
          ),
          body: model.node != null
              ? GridView.count(
                  crossAxisCount: 2,
                  children: [
                    GaugeCustom(
                      text: "pH",
                      value: model.node!.ph,
                      minvalue: 0,
                      maxvalue: 12,
                    ),
                    GaugeCustom(
                      text: "TDS",
                      value: model.node!.tds,
                      minvalue: 0,
                      maxvalue: 20,
                    ),
                    GaugeCustom(
                      text: "Temperature",
                      value: model.node!.temp,
                      minvalue: -10,
                      maxvalue: 60,
                    ),
                  ],
                )
              :  const Center(child: CircularProgressIndicator()),
        );
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}

class GaugeCustom extends StatelessWidget {
  final String text;
  final double value;
  final double minvalue;
  final double maxvalue;

  const GaugeCustom(
      {super.key,
      required this.text,
      required this.value,
      required this.minvalue,
      required this.maxvalue});

  /// Build method of your widget.
  @override
  Widget build(BuildContext context) {
    // Create animated radial gauge.
    // All arguments changes will be automatically animated.
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(text),
              Expanded(
                child: AnimatedRadialGauge(
                  duration: const Duration(seconds: 1),
                  curve: Curves.elasticOut,
                  radius: 100,
                  value: value,
                  builder: (context, child, value) => RadialGaugeLabel(
                    value: value,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  axis: GaugeAxis(
                    min: minvalue,
                    max: maxvalue,
                    degrees: 180,
                    style: const GaugeAxisStyle(
                      thickness: 20,
                      background: Color(0xFFDFE2EC),
                      segmentSpacing: 4,
                    ),

                    /// Define the pointer that will indicate the progress (optional).
                    pointer: const GaugePointer.triangle(
                      width: 16,
                      height: 20,
                      color: Color(0xFF193663),
                    ),

                    /// Define the progress bar (optional).
                    progressBar: const GaugeProgressBar.rounded(
                      color: Color(0xFFB4C2F8),
                    ),

                    /// Define axis segments (optional).
                    // segments: [
                    //   GaugeSegment(
                    //     from: 0,
                    //     to: 33.3,
                    //     color: Color(0xFFD9DEEB),
                    //     cornerRadius: Radius.zero,
                    //   ),
                    //   GaugeSegment(
                    //     from: 33.3,
                    //     to: 66.6,
                    //     color: Color(0xFFD9DEEB),
                    //     cornerRadius: Radius.zero,
                    //   ),
                    //   GaugeSegment(
                    //     from: 66.6,
                    //     to: 100,
                    //     color: Color(0xFFD9DEEB),
                    //     cornerRadius: Radius.zero,
                    //   ),
                    // ],
                  ),
                ),
              ),
              Text(
                  "${value} ${text == "Temperature" ? "°C" : text == "TDS" ? "PPM" : ""}"),
            ],
          ),
        ),
      ),
    );
  }
}

class Option extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final String file;

  const Option(
      {Key? key, required this.name, required this.onTap, required this.file})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 1.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: onTap,
          child: Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Lottie.asset(file),
                      )),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(6)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
