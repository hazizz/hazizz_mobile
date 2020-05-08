import 'package:steel_crypt/steel_crypt.dart';
import 'package:uuid/uuid.dart';

class HazizzCrypt{
  static String generateKey(){
    return Uuid().v4().substring(0, 32);
  }

  static String encrypt(String data, String key){
    AesCrypt _aesEncrypter = AesCrypt(key, 'ecb', 'iso10126-2'); //generate AES block encrypter with key and ISO7816-4 padding
    String encryptedImg = _aesEncrypter.encrypt(data);
    return encryptedImg;
  }

  static String decrypt(String encryptedData, String key){
    AesCrypt _aesEncrypter = AesCrypt(key, 'ecb', 'iso10126-2'); //generate AES block encrypter with key and ISO7816-4 padding
    return _aesEncrypter.decrypt(encryptedData);
  }
}