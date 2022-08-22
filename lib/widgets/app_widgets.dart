import 'package:flutter/material.dart';
import 'package:food_delivery/utils/app_colors.dart';

class AppWidgets {
  static Widget elevatedIconButton({
    required String buttonName,
    required double width,
    required double height,
    required Color color,
    required String path,
    VoidCallback? onPressed,
    required bool loader,
  }) {
    final ButtonStyle flatButtonStyle = ElevatedButton.styleFrom(
      fixedSize: Size(width, height),
      elevation: 0,
      primary: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      alignment: Alignment.center,
    );
    return ElevatedButton(
      onPressed: onPressed,
      style: flatButtonStyle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 40,
            width: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                path,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 90),
          Expanded(
            child: AppWidgets.text(
                buttonName, FontWeight.w600, AppColors.backgroundWhite, 18),
          ),
          loader
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    color: AppColors.backgroundWhite,
                    strokeWidth: 2,
                  ))
              : const SizedBox(
                  height: 0,
                  width: 0,
                )
        ],
      ),
    );
  }

  static Widget text(
      String string, FontWeight fontWeight, Color fontColor, double fontSize,
      {TextDecoration decoration = TextDecoration.none,
      maxLines = 3,
      TextAlign align = TextAlign.justify}) {
    return Text(
      string,
      textAlign: align,
      maxLines: maxLines,
      overflow: TextOverflow.clip,
      style: TextStyle(
          decoration: decoration,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: fontColor),
    );
  }

  static Widget plusMinusButton(void Function()? onMinusPressed,
      void Function()? onPlusPressed, String quantity, Color buttonColor) {
    return Container(
      height: 40,
      width: 150,
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.remove,
                color: AppColors.backgroundWhite,
              ),
              onPressed: onMinusPressed),
          AppWidgets.text(quantity.toString(), FontWeight.w600,
              AppColors.backgroundWhite, 18),
          IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.add,
                color: AppColors.backgroundWhite,
              ),
              onPressed: onPlusPressed)
        ],
      ),
    );
  }
}
