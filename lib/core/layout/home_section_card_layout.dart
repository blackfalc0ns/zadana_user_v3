class HomeSectionCardLayout {
  const HomeSectionCardLayout._();

  static bool isTabletWidth(double width) => width >= 600;

  static double classicCardWidth(double viewportWidth) {
    if (!isTabletWidth(viewportWidth)) return 120;
    return (viewportWidth * 0.23).clamp(156.0, 184.0).toDouble();
  }

  static double classicSectionHeight(double viewportWidth) {
    if (!isTabletWidth(viewportWidth)) return 140;
    return (classicCardWidth(viewportWidth) * 1.16)
        .clamp(184.0, 214.0)
        .toDouble();
  }

  static double compactCardWidth(double viewportWidth) {
    if (!isTabletWidth(viewportWidth)) {
      return (viewportWidth / 2.2).clamp(140.0, 200.0).toDouble();
    }
    return (viewportWidth * 0.34).clamp(220.0, 280.0).toDouble();
  }

  static double compactSectionHeight(double viewportWidth) {
    return isTabletWidth(viewportWidth) ? 96 : 78;
  }

  static double featuredSectionHeight(double viewportWidth) {
    return isTabletWidth(viewportWidth) ? 360 : 285;
  }
}
