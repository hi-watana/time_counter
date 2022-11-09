import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:time_counter_flutter_library/banner_ad_height.dart';

const String _adUnitIdEnvName = 'AD_UNIT_ID';

class MyBanner extends StatefulWidget {
  static final String adUnitId = (const bool.hasEnvironment(_adUnitIdEnvName))
      ? const String.fromEnvironment(_adUnitIdEnvName)
      : FlutterConfig.get(_adUnitIdEnvName);

  const MyBanner({Key? key}) : super(key: key);

  @override
  State<MyBanner> createState() => _MyBannerState();
}

class _MyBannerState extends State<MyBanner> {
  BannerAd? _anchoredAdaptiveAd;
  static AnchoredAdaptiveBannerAdSize? _adSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd().then((_) {
      if (_adSize != null) {
        context.read<BannerAdHeightHolder>().setAdHeight(_adSize!.height);
      }
    });
  }

  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    if (_adSize == null) {
      _adSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate(),
      );
      if (_adSize == null) {
        return;
      }
    }

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: MyBanner.adUnitId,
      size: _adSize!,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _anchoredAdaptiveAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    final size = _adSize;
    if (size == null) {
      return Container();
    }
    if (_anchoredAdaptiveAd == null) {
      return Container(
        color: Colors.black,
        width: size.width.toDouble(),
        height: size.height.toDouble(),
      );
    }
    return Container(
      color: Colors.black,
      width: _anchoredAdaptiveAd!.size.width.toDouble(),
      height: _anchoredAdaptiveAd!.size.height.toDouble(),
      child: AdWidget(ad: _anchoredAdaptiveAd!),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _anchoredAdaptiveAd?.dispose();
  }
}
