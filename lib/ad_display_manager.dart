
import 'package:ads/ads.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/widgets.dart';

import 'ApiKeys.dart';

class AppAds {
  static Ads _ads;

  static MobileAdListener _eventListener  = (MobileAdEvent event) {
    if (event == MobileAdEvent.opened) {
      print("eventListener: The opened ad is clicked on.");
    }
  };

  static void showAd(State screenState)
  {
    _ads?.showVideoAd(state: screenState);
  }

  static void init() => _ads ??= Ads(
    AdInfo.appId,
    //bannerUnitId: bannerUnitId,
    //screenUnitId: screenUnitId,
    keywords: <String>['ibm', 'computers'],
    //contentUrl: 'http://www.ibm.com',
    childDirected: false,
    testDevices: ['37500F182BF23450755FAA910F826A24'],
    testing: false,
    listener: _eventListener,
  );

  static void setVideo(var listener)
  {
    _ads?.setVideoAd(
      adUnitId: AdInfo.rewardedAdUnitId,
      keywords: ['dart', 'java'],
      //contentUrl: 'http://www.publang.org',
      childDirected: true,
      testDevices: null,
      listener: listener,

        //print("The ad was sent a reward amount.");


    );
  }

  static void dispose() => _ads?.dispose();
}