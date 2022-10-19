import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyBanner extends StatelessWidget {

    final BannerAd banner = BannerAd(
    adUnitId: "ca-app-pub-3940256099942544/6300978111", // test unitId
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  )..load();

  @override
  Widget build(BuildContext context) {
    return AdWidget(ad: banner);
  }
}
