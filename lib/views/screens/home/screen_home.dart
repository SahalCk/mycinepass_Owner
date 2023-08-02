import 'package:cinepass_owner/utils/colors.dart';
import 'package:cinepass_owner/utils/sized_boxes.dart';
import 'package:cinepass_owner/view_models/home_screen_bloc/home_screen_bloc.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_revenue_widgets.dart';
import 'package:cinepass_owner/views/widgets/cine_pass_snack_bars.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double bookedPercentage;
    double cancelledPercentage;
    int bookedCount;
    int cancelledCount;
    List<dynamic> listOfMonths;

    BlocProvider.of<HomeScreenBloc>(context).add(GetAllValuesEvent());
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          SystemUiOverlayStyle.light.copyWith(statusBarColor: backgroundColor),
      child: Scaffold(
          body: SafeArea(
        child: BlocConsumer<HomeScreenBloc, HomeScreenState>(
          listenWhen: (previous, current) => current is HomeScreenActionState,
          buildWhen: (previous, current) =>
              current is! HomeScreenActionState &&
              current is! HomeScreenPieChartState &&
              current is! HomeScreenGraphState,
          listener: (context, state) {
            if (state is ErrorState) {
              errorSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            if (state is AllValuesFetchedState) {
              bookedPercentage = state.bookedPercentage;
              cancelledPercentage = state.cancelledPercentage;
              bookedCount = cancelledCount = int.parse(state.booked);
              cancelledCount = int.parse(state.cancelled);
              listOfMonths = state.listOfMonths;
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                  child: Column(
                    children: [
                      sizedBoxHeight20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Welcome Back,',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100),
                              ),
                              Text(state.userName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          Container(
                            height: Adaptive.h(5.6),
                            width: Adaptive.w(12),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                image: DecorationImage(
                                    image: AssetImage('assets/admin.png'),
                                    fit: BoxFit.fill)),
                          )
                        ],
                      ),
                      sizedBoxHeight40,
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CinePassRevenueTop(
                                      title: 'Daily Sale',
                                      value: state.dailySale),
                                  CinePassRevenueTop(
                                      title: 'Monthly Sale',
                                      value: state.monthlySale),
                                  CinePassRevenueTop(
                                      title: 'Yearly Sale',
                                      value: state.yearlySale)
                                ],
                              ),
                              sizedBoxHeight15,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GlassmorphicContainer(
                                    width: Adaptive.w(60),
                                    height: Adaptive.h(31),
                                    borderRadius: 8,
                                    blur: 20,
                                    alignment: Alignment.bottomCenter,
                                    border: 0,
                                    linearGradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          cardColor.withOpacity(0.1),
                                          cardColor.withOpacity(0.13),
                                        ]),
                                    borderGradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color(0xFFffffff)
                                            .withOpacity(0.5),
                                        const Color((0xFFFFFFFF))
                                            .withOpacity(0.5),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: Adaptive.h(24),
                                          width: Adaptive.w(100),
                                          child: BlocBuilder<HomeScreenBloc,
                                              HomeScreenState>(
                                            builder: (context, state) {
                                              int touchedIndex = -1;
                                              if (state
                                                  is PiChartIndexIsTouched) {
                                                touchedIndex = state.index;
                                              }
                                              return PieChart(PieChartData(
                                                  borderData: FlBorderData(
                                                    show: false,
                                                  ),
                                                  pieTouchData: PieTouchData(
                                                    touchCallback:
                                                        (FlTouchEvent event,
                                                            pieTouchResponse) {
                                                      if (!event
                                                              .isInterestedForInteractions ||
                                                          pieTouchResponse ==
                                                              null ||
                                                          pieTouchResponse
                                                                  .touchedSection ==
                                                              null) {
                                                        BlocProvider.of<
                                                                    HomeScreenBloc>(
                                                                context)
                                                            .add(
                                                                PiChartIndexTouchedEvent(
                                                                    index: -1));
                                                        return;
                                                      }
                                                      BlocProvider.of<
                                                                  HomeScreenBloc>(
                                                              context)
                                                          .add(PiChartIndexTouchedEvent(
                                                              index: pieTouchResponse
                                                                  .touchedSection!
                                                                  .touchedSectionIndex));
                                                    },
                                                  ),
                                                  centerSpaceRadius: 40,
                                                  sections: [
                                                    PieChartSectionData(
                                                        title: touchedIndex == 0
                                                            ? bookedCount
                                                                .toString()
                                                            : '${bookedPercentage.roundToDouble()}%',
                                                        titleStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13),
                                                        value: bookedPercentage
                                                            .roundToDouble(),
                                                        color: Colors.green,
                                                        radius:
                                                            touchedIndex == 0
                                                                ? 60
                                                                : 50),
                                                    PieChartSectionData(
                                                        title: touchedIndex == 1
                                                            ? cancelledCount
                                                                .toString()
                                                            : '${cancelledPercentage.roundToDouble()}%',
                                                        titleStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13),
                                                        value:
                                                            cancelledPercentage
                                                                .roundToDouble(),
                                                        color: Colors.red,
                                                        radius:
                                                            touchedIndex == 1
                                                                ? 60
                                                                : 50)
                                                  ]));
                                            },
                                          ),
                                        ),
                                        sizedBoxHeight10,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  height: Adaptive.h(1.3),
                                                  width: Adaptive.w(2.7),
                                                ),
                                                SizedBox(
                                                  width: Adaptive.w(2),
                                                ),
                                                const Text(
                                                  'Booked',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  height: Adaptive.h(1.3),
                                                  width: Adaptive.w(2.7),
                                                ),
                                                SizedBox(
                                                  width: Adaptive.w(2),
                                                ),
                                                const Text('Cancelled',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13))
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      CinePassRevenueSide(
                                          title: 'Total Revenue',
                                          value: state.totalRevenue,
                                          ruppeesSymbol: true),
                                      sizedBoxHeight10,
                                      CinePassRevenueSide(
                                          title: 'Total Bookings',
                                          value: state.totalBookings),
                                      sizedBoxHeight10,
                                      CinePassRevenueSide(
                                          title: 'Active Bookings',
                                          value: state.activeBookings),
                                      sizedBoxHeight10,
                                      CinePassRevenueSide(
                                          title: 'Expired Bookings',
                                          value: state.expiredBookings),
                                    ],
                                  )
                                ],
                              ),
                              sizedBoxHeight15,
                              GlassmorphicContainer(
                                padding: EdgeInsets.only(top: Adaptive.h(2)),
                                width: Adaptive.w(100),
                                height: Adaptive.h(38),
                                borderRadius: 8,
                                blur: 20,
                                alignment: Alignment.bottomCenter,
                                border: 0,
                                linearGradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      cardColor.withOpacity(0.1),
                                      cardColor.withOpacity(0.13),
                                    ]),
                                borderGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFFffffff).withOpacity(0.5),
                                    const Color((0xFFFFFFFF)).withOpacity(0.5),
                                  ],
                                ),
                                child: BlocBuilder<HomeScreenBloc,
                                    HomeScreenState>(
                                  builder: (context, state) {
                                    List<FlSpot> listSpots = List.generate(
                                        12,
                                        (index) => FlSpot(
                                            index.toDouble(),
                                            ((listOfMonths[index].toDouble()) *
                                                    5) /
                                                3000));

                                    return SizedBox(
                                      width: Adaptive.w(85),
                                      height: Adaptive.h(37),
                                      child: LineChart(LineChartData(
                                          minX: 0,
                                          maxX: 11,
                                          minY: 0,
                                          maxY: 6,
                                          titlesData: FlTitlesData(
                                              show: true,
                                              topTitles: const AxisTitles(
                                                  sideTitles: SideTitles(
                                                      showTitles: false)),
                                              rightTitles: const AxisTitles(
                                                  sideTitles: SideTitles(
                                                      showTitles: false)),
                                              leftTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                showTitles: true,
                                                getTitlesWidget: (value, meta) {
                                                  switch (value.toInt()) {
                                                    case 0:
                                                      return const Text('0',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));

                                                    case 1:
                                                      return const Text('600',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));
                                                    case 2:
                                                      return const Text('1.2k',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));
                                                    case 3:
                                                      return const Text('1.8k',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));
                                                    case 4:
                                                      return const Text('2.4k',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));
                                                    case 5:
                                                      return const Text('3.0k',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));

                                                    default:
                                                      return const SizedBox();
                                                  }
                                                },
                                              )),
                                              bottomTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                showTitles: true,
                                                getTitlesWidget: (value, meta) {
                                                  switch (value.toInt()) {
                                                    case 0:
                                                      return const Text('Jan',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));

                                                    case 1:
                                                      return const Text('Feb',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));
                                                    case 2:
                                                      return const Text('Mar',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));
                                                    case 3:
                                                      return const Text('Apr',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));
                                                    case 4:
                                                      return const Text('May',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));
                                                    case 5:
                                                      return const Text('Jun',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));
                                                    case 6:
                                                      return const Text('Jul',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));
                                                    case 7:
                                                      return const Text('Aug',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));
                                                    case 8:
                                                      return const Text('Sep',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));
                                                    case 9:
                                                      return const Text('Oct',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));
                                                    case 10:
                                                      return const Text('Nov',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));
                                                    case 11:
                                                      return const Text('Dec',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .white));
                                                    default:
                                                  }
                                                  return const SizedBox();
                                                },
                                              ))),
                                          gridData: FlGridData(
                                            show: true,
                                            getDrawingHorizontalLine: (value) {
                                              return const FlLine(
                                                  color: Color.fromARGB(
                                                      255, 49, 85, 54),
                                                  strokeWidth: 2);
                                            },
                                            getDrawingVerticalLine: (value) {
                                              return const FlLine(
                                                  color: Color.fromARGB(
                                                      255, 49, 85, 54),
                                                  strokeWidth: 2);
                                            },
                                          ),
                                          borderData: FlBorderData(
                                            show: true,
                                            border:
                                                Border.all(color: Colors.green),
                                          ),
                                          lineBarsData: [
                                            LineChartBarData(
                                                spots: listSpots,
                                                isCurved: true,
                                                barWidth: 3,
                                                belowBarData: BarAreaData(
                                                  show: true,
                                                  gradient:
                                                      LinearGradient(colors: [
                                                    const Color(0xff23b6e6)
                                                        .withOpacity(0.3),
                                                    const Color(0xff02d39a)
                                                        .withOpacity(0.3)
                                                  ]),
                                                ),
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0xff23b6e6),
                                                      Color(0xff02d39a)
                                                    ]))
                                          ])),
                                    );
                                  },
                                ),
                              ),
                              sizedBoxHeight120
                            ],
                          ),
                        ),
                      ),
                    ],
                  ));
            } else {
              return Center(
                child: LottieBuilder.asset(
                  'animations/content_loading.json',
                  width: Adaptive.h(20),
                  height: Adaptive.w(38),
                ),
              );
            }
          },
        ),
      )),
    );
  }
}
