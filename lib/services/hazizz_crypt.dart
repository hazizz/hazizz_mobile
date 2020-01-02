import 'package:steel_crypt/steel_crypt.dart';
import 'package:uuid/uuid.dart';

class HazizzCrypt{

  static String generateKey(){
  //  return CryptKey().genFortuna();
    return Uuid().v4().substring(0, 32);
  }
  static String generateIv(){
    return CryptKey().genDart(8);
  }

  static String encrypt(String data, String key){
    print("melody2.1: ${key}");
    var _aesEncrypter = AesCrypt(key, 'ecb', 'iso10126-2'); //generate AES block encrypter with key and ISO7816-4 padding
   // var _aesEncrypter = AesCrypt(key, 'ecb'); //generate AES block encrypter with key and ISO7816-4 padding

    print("melody2.2");
    String encryptedImg = _aesEncrypter.encrypt(data); //encrypt

    print("melody2.3");
    return encryptedImg;

  }

  static String decrypt(String encryptedData, String key){
    var _aesEncrypter = AesCrypt(key, 'ecb', 'iso10126-2'); //generate AES block encrypter with key and ISO7816-4 padding
  //  var _aesEncrypter = AesCrypt(key, 'ecb'); //generate AES block encrypter with key and ISO7816-4 padding

    return _aesEncrypter.decrypt(encryptedData);
  }
  
  
}