import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'constants.dart';

class MyBanner extends StatelessWidget {

  MyBanner({Key? key}) : super(key: key);

  final BannerAd _banner = BannerAd(
    adUnitId: "ca-app-pub-3940256099942544/6300978111", // test unitId
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  )..load();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bannerFieldHeight,
      width: double.infinity,
      color: Colors.black,
      child: AdWidget(ad: _banner),
    );
  }
}
