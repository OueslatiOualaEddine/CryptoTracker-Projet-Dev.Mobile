import 'dart:convert';
import 'package:cryptotracker/models/cryptocurrenct.dart';
import 'package:cryptotracker/providers/market_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final String id;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isLoading = true;
  bool isFirstTime = true;
  List<FlSpot> flSpotList = [];
  double minX = 0;
  double minY = 0;
  double maxX = 0;
  double maxY = 0;

  void getChartData(String days, CryptoCurrency currentCrypto) async {
    if (!isFirstTime) {
      setState(() {
        isLoading = true;
      });
    } else {
      isFirstTime = false;
    }
    String api =
        'https://api.coingecko.com/api/v3/coins/${currentCrypto.id}/market_chart?vs_currency=usd&days=$days';
    try {
      final response = await http.get(Uri.parse(api));
      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        List rawList = result['prices'];
        List<List> chartData = rawList.map((e) => e as List).toList();
        List<PriceAndTime> priceAndTimeList = chartData
            .map((e) => PriceAndTime(time: e[0] as int, price: e[1] as double))
            .toList();

        setState(() {
          flSpotList = priceAndTimeList
              .map((chart) => FlSpot(chart.time.toDouble(), chart.price))
              .toList();
          minX = priceAndTimeList.first.time.toDouble();
          maxX = priceAndTimeList.last.time.toDouble();
          priceAndTimeList.sort((a, b) => a.price.compareTo(b.price));
          minY = priceAndTimeList.first.price;
          maxY = priceAndTimeList.last.price;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        // Handle error response
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle exception
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Coin Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Consumer<MarketProvider>(
          builder: (context, marketProvider, child) {
            CryptoCurrency currentCrypto =
            marketProvider.fetchCryptoById(widget.id);

            return RefreshIndicator(
              onRefresh: () => marketProvider.fetchGraphData(widget.id),
              child: ListView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                padding: const EdgeInsets.all(20),
                children: [
                  _buildHeader(currentCrypto),
                  const SizedBox(height: 20),
                  _buildStatistics(currentCrypto),
                  const SizedBox(height: 30),
                  _buildLineChart(currentCrypto),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(CryptoCurrency currentCrypto) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          height: 75,
          width: 75,
          child: Image.network(currentCrypto.image!),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${currentCrypto.name!} (${currentCrypto.symbol!.toUpperCase()})",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "\$ ${currentCrypto.currentPrice!.toStringAsFixed(4)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                Builder(
                  builder: (context) {
                    double priceChange = currentCrypto.priceChange24h!;
                    if (priceChange < 0) {
                      return const Icon(Icons.arrow_downward, color: Colors.red);
                    } else {
                      return const Icon(Icons.arrow_upward, color: Colors.green);
                    }
                  },
                ),
                const SizedBox(width: 5),
                Text(
                  "${currentCrypto.priceChangePercentage24h!.toStringAsFixed(2)}%",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: currentCrypto.priceChange24h! < 0 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLineChart(CryptoCurrency currentCrypto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Price Variation",
          style: TextStyle(
              fontSize: 17, color: Colors.grey, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 10),
        const SizedBox(height: 10),
        if (isLoading)
          const CircularProgressIndicator()
        else if (flSpotList.isNotEmpty)
          SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minX: minX,
                  minY: minY,
                  maxX: maxX,
                  maxY: maxY,
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    getDrawingHorizontalLine: (value) => FlLine(strokeWidth: 0),
                    getDrawingVerticalLine: (value) => FlLine(strokeWidth: 0),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: flSpotList,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              )
          )
        else
          const Text("No data available for the selected range"),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => getChartData('1', currentCrypto),
              child: const Text('1D'),
            ),
            ElevatedButton(
              onPressed: () => getChartData('7', currentCrypto),
              child: const Text('7D'),
            ),
            ElevatedButton(
              onPressed: () => getChartData('15', currentCrypto),
              child: const Text('15D'),
            ),
            ElevatedButton(
              onPressed: () => getChartData('30', currentCrypto),
              child: const Text('30D'),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildStatistics(CryptoCurrency currentCrypto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Statistics",
          style: TextStyle(
              fontSize: 17, color: Colors.grey, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatTile("Today's Low",
                "\$ ${currentCrypto.low24h!.toStringAsFixed(2)}"),
            _buildStatTile("Today's High",
                "\$ ${currentCrypto.high24h!.toStringAsFixed(2)}"),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatTile("Market Rank", "#${currentCrypto.marketCapRank}"),
            _buildStatTile("Market Cap",
                "\$ ${currentCrypto.marketCap!.toStringAsFixed(2)}"),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatTile("ATH", "\$ ${currentCrypto.ath!.toStringAsFixed(2)}"),
            _buildStatTile("ATL", "\$ ${currentCrypto.atl!.toStringAsFixed(2)}"),
          ],
        ),
      ],
    );
  }

  Widget _buildStatTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class PriceAndTime {
  final int time;
  final double price;
  PriceAndTime({required this.time, required this.price});
}
