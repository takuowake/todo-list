import 'package:flutter/material.dart';

Widget buildCustomListTile({
  required BuildContext context,
  required String title,
  required Widget destination,
}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 4.0), // 各ListTileの上下に余白を追加
    padding: EdgeInsets.symmetric(horizontal: 16.0), // 内側の余白を設定
    height: 70,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.7), // 背景色を透明な白に設定
      borderRadius: BorderRadius.circular(15), // 角を丸める
    ),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      borderRadius: BorderRadius.circular(15), // インクのエフェクトを角丸に設定
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black, // 文字の色を灰色に設定
                fontWeight: FontWeight.bold, // 文字を太字に設定
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), // 右矢印アイコンを追加
        ],
      ),
    ),
  );
}