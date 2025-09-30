enum TrafficLightMode {
  regular,
  blinkingYellow;
}

enum LightColor {
  red("red"),
  green("green"),
  yellow("yellow");

  final String name;

  const LightColor(this.name);
}
