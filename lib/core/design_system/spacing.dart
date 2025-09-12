import 'package:flutter/material.dart';

class AppSpacing {
  // Private constructor
  AppSpacing._();

  // Base spacing unit (4px)
  static const double _unit = 4.0;

  // Spacing values
  static const double none = 0.0;
  static const double xs = _unit * 1; // 4px
  static const double sm = _unit * 2; // 8px
  static const double md = _unit * 3; // 12px
  static const double lg = _unit * 4; // 16px
  static const double xl = _unit * 5; // 20px
  static const double xxl = _unit * 6; // 24px
  static const double xxxl = _unit * 8; // 32px
  static const double huge = _unit * 10; // 40px
  static const double giant = _unit * 12; // 48px

  // Padding values
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);
  static const EdgeInsets paddingXXXL = EdgeInsets.all(xxxl);

  // Symmetric padding
  static const EdgeInsets paddingHorizontalXS = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets paddingHorizontalXXL = EdgeInsets.symmetric(horizontal: xxl);

  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets paddingVerticalXXL = EdgeInsets.symmetric(vertical: xxl);

  // Margin values
  static const EdgeInsets marginXS = EdgeInsets.all(xs);
  static const EdgeInsets marginSM = EdgeInsets.all(sm);
  static const EdgeInsets marginMD = EdgeInsets.all(md);
  static const EdgeInsets marginLG = EdgeInsets.all(lg);
  static const EdgeInsets marginXL = EdgeInsets.all(xl);
  static const EdgeInsets marginXXL = EdgeInsets.all(xxl);
  static const EdgeInsets marginXXXL = EdgeInsets.all(xxxl);

  // SizedBox values for spacing
  static const Widget spaceXS = SizedBox(width: xs, height: xs);
  static const Widget spaceSM = SizedBox(width: sm, height: sm);
  static const Widget spaceMD = SizedBox(width: md, height: md);
  static const Widget spaceLG = SizedBox(width: lg, height: lg);
  static const Widget spaceXL = SizedBox(width: xl, height: xl);
  static const Widget spaceXXL = SizedBox(width: xxl, height: xxl);
  static const Widget spaceXXXL = SizedBox(width: xxxl, height: xxxl);

  // Horizontal spacing
  static const Widget hSpaceXS = SizedBox(width: xs);
  static const Widget hSpaceSM = SizedBox(width: sm);
  static const Widget hSpaceMD = SizedBox(width: md);
  static const Widget hSpaceLG = SizedBox(width: lg);
  static const Widget hSpaceXL = SizedBox(width: xl);
  static const Widget hSpaceXXL = SizedBox(width: xxl);
  static const Widget hSpaceXXXL = SizedBox(width: xxxl);

  // Vertical spacing
  static const Widget vSpaceXS = SizedBox(height: xs);
  static const Widget vSpaceSM = SizedBox(height: sm);
  static const Widget vSpaceMD = SizedBox(height: md);
  static const Widget vSpaceLG = SizedBox(height: lg);
  static const Widget vSpaceXL = SizedBox(height: xl);
  static const Widget vSpaceXXL = SizedBox(height: xxl);
  static const Widget vSpaceXXXL = SizedBox(height: xxxl);

  // Border radius values
  static const double radiusNone = 0.0;
  static const double radiusXS = xs; // 4px
  static const double radiusSM = sm; // 8px
  static const double radiusMD = md; // 12px
  static const double radiusLG = lg; // 16px
  static const double radiusXL = xl; // 20px
  static const double radiusXXL = xxl; // 24px
  static const double radiusCircle = 999.0; // Full circle

  // Border radius objects
  static const BorderRadius borderRadiusNone = BorderRadius.zero;
  static const BorderRadius borderRadiusXS = BorderRadius.all(Radius.circular(radiusXS));
  static const BorderRadius borderRadiusSM = BorderRadius.all(Radius.circular(radiusSM));
  static const BorderRadius borderRadiusMD = BorderRadius.all(Radius.circular(radiusMD));
  static const BorderRadius borderRadiusLG = BorderRadius.all(Radius.circular(radiusLG));
  static const BorderRadius borderRadiusXL = BorderRadius.all(Radius.circular(radiusXL));
  static const BorderRadius borderRadiusXXL = BorderRadius.all(Radius.circular(radiusXXL));
  static const BorderRadius borderRadiusCircle = BorderRadius.all(Radius.circular(radiusCircle));

  // Icon sizes
  static const double iconXS = lg; // 16px
  static const double iconSM = xl; // 20px
  static const double iconMD = xxl; // 24px
  static const double iconLG = xxxl; // 32px
  static const double iconXL = huge; // 40px
  static const double iconXXL = giant; // 48px

  // Button heights
  static const double buttonHeightSM = xxxl; // 32px
  static const double buttonHeightMD = huge; // 40px
  static const double buttonHeightLG = giant; // 48px
  static const double buttonHeightXL = _unit * 14; // 56px

  // Input heights
  static const double inputHeightSM = xxxl; // 32px
  static const double inputHeightMD = huge; // 40px
  static const double inputHeightLG = giant; // 48px
  static const double inputHeightXL = _unit * 14; // 56px

  // Container heights
  static const double containerHeightSM = _unit * 16; // 64px
  static const double containerHeightMD = _unit * 20; // 80px
  static const double containerHeightLG = _unit * 24; // 96px
  static const double containerHeightXL = _unit * 28; // 112px

  // Helper methods
  static EdgeInsets all(double value) => EdgeInsets.all(value);
  static EdgeInsets symmetric({double vertical = 0, double horizontal = 0}) =>
      EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal);
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);

  static SizedBox width(double value) => SizedBox(width: value);
  static SizedBox height(double value) => SizedBox(height: value);
  static SizedBox size(double width, double height) => SizedBox(width: width, height: height);

  static BorderRadius radius(double value) => BorderRadius.circular(value);
  static BorderRadius onlyRadius({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) =>
      BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      );
}