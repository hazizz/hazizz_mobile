import 'package:steel_crypt/steel_crypt.dart';

class HazizzCrypt{

  static String generateKey(){
    return CryptKey().genFortuna();
  }
  static String generateIv(){
    return CryptKey().genDart(8);
  }

  static String encrypt(String data, String key, String iv){
    print("melody2.1");
    var encrypter3 = LightCrypt(key, "ChaCha20/12"); //generate ChaCha20/12 encrypter

   // var _aesEncrypter = AesCrypt(key, 'cbc',
  //      'iso10126-2'); //generate AES block encrypter with key and ISO7816-4 padding
    print("melody2.2");
   // String encryptedImg = _aesEncrypter.encrypt(data, iv);
    String encryptedImg = encrypter3.encrypt(data, iv); //encrypt

    print("melody2.3");
    return encryptedImg;

  }

  static String decrypt(String encryptedData, String key, String iv){
   // var _aesEncrypter = AesCrypt(key, 'cbc',
   //     'iso10126-2'); //generate AES block encrypter with key and ISO7816-4 padding
    var encrypter3 = LightCrypt(key, "ChaCha20/12"); //generate ChaCha20/12 encrypter

    return encrypter3.decrypt(encryptedData, iv);
  }
  
  
}