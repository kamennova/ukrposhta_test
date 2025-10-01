enum TrafficLightMode {
  regular,
  blinkingYellow,
  stopped;
}

enum LightColor {
  red("red"),
  green("green"),
  yellow("yellow");

  final String name;

  const LightColor(this.name);
}
