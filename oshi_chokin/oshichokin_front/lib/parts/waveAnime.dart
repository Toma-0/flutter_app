import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../config/size_config.dart';
import 'dart:math' as math;
import "../info/user_info.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WaveClipper extends CustomClipper<Path> {
  // 1
  final BuildContext context;
  final double waveControllerValue; // waveController.valueの値
  final double offset; // 波のずれ
  final List<Offset> coordinateList = []; // 波の座標のリスト

  WaveClipper(this.context, this.waveControllerValue, this.offset) {
    final width = MediaQuery.of(context).size.width; // 画面の横幅
    final height = MediaQuery.of(context).size.height; // 画面の高さ

    // coordinateListに波の座標を追加
    for (var i = 0; i <= width * 10; i++) {
      final step = ((i / width) - waveControllerValue) * 8;
      coordinateList.add(
        Offset(
            i.toDouble() * 4, // X座標
            math.sin(step * 2 * math.pi - offset) * 3 + height * 0.3),
      );
    }
  }
  // 2
  @override
  Path getClip(size) {
    final path = Path()
      // addPolygon: coordinateListに入っている座標を直線で結ぶ。
      //             false -> 最後に始点に戻らない
      ..addPolygon(coordinateList, false)
      ..lineTo(size.width, size.height) // 画面右下へ
      ..lineTo(0, size.height) // 画面左下へ
      ..close(); // 始点に戻る
    return path;
  }

  // 3
  // 再クリップするタイミング -> animationValueが更新されていたとき
  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      waveControllerValue != oldClipper.waveControllerValue;
}

high(ref) {
  UserInformation().userInfo(ref);
  List highList = [UserInformation.sum_money, UserInformation.goal_money];
  return highList;
}

class makeWave {
  @override
  wave(waveController, x, y, ref, color) {
    high(ref);
    return AnimatedBuilder(
      animation: waveController,
      builder: (context, child) => Stack(
        children: [
          ClipPath(
            child: Container(
              width: (Size.w! * (x - 60)) * 2,
              height: Size.h! * y! * 10,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                shape: BoxShape.circle,
              ),
            ),
            clipper: WaveClipper(context, waveController.value, 0),
          ),
          ClipPath(
            child: Container(
              width: (Size.w! * (x - 60)) * 2,
              height: Size.h! * y!,
              decoration: BoxDecoration(
                color: Color.fromARGB(149, 255, 255, 255),
                shape: BoxShape.circle,
              ),
            ),
            clipper: WaveClipper(context, waveController.value, 0.6),
          ),
        ],
      ),
    );
  }
}
