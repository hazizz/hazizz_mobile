extension FirstUpper on String {
  String toUpperFirst() {
    String s = this;
    return s[0].toUpperCase() +s.substring(1);
  }
}

