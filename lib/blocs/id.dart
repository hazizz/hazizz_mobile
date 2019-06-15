class Id{
  static final Id _singleton = new Id._internal();
  factory Id() {
    return _singleton;
  }
  Id._internal();

   int _id = 0;

   int get(){
    _id++;
    return _id;
  }

}