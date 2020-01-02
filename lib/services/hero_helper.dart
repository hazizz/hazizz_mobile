class HeroHelper{

  static int _count = 0;

  static String get uniqueTag{
    return (_count++).toString();
  }
}