extension StringFirstUpperExtension on String {
  String toUpperFirst() {
    if(this.length == 0) return this;
    String s = this;
    return s[0].toUpperCase() +s.substring(1);
  }
}

