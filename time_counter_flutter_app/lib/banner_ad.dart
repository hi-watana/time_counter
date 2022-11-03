import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'constants.dart';

const String _adUnitIdEnvName = 'AD_UNIT_ID';

class MyBanner extends StatelessWidget {
  static final String _adUnitId = (const bool.hasEnvironment(_adUnitIdEnvName))
      ? const String.fromEnvironment(_adUnitIdEnvName)
      : FlutterConfig.get(_adUnitIdEnvName);

  MyBanner({Key? key}) : super(key: key);

  final BannerAd _banner = BannerAd(
    adUnitId:  _adUnitId,
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
