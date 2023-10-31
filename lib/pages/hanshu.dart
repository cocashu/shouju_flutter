import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import "package:pointycastle/export.dart";

Uint8List aesCbcEncrypt(
    Uint8List key, Uint8List iv, Uint8List paddedPlaintext) {
  assert([128, 192, 256].contains(key.length * 8));
  assert(128 == iv.length * 8);
  assert(128 == paddedPlaintext.length * 8);

  // Create a CBC block cipher with AES, and initialize with key and IV

  final cbc = CBCBlockCipher(AESEngine())
    ..init(true, ParametersWithIV(KeyParameter(key), iv)); // true=encrypt

  // Encrypt the plaintext block-by-block

  final cipherText = Uint8List(paddedPlaintext.length); // allocate space

  var offset = 0;
  while (offset < paddedPlaintext.length) {
    offset += cbc.processBlock(paddedPlaintext, offset, cipherText, offset);
  }
  assert(offset == paddedPlaintext.length);

  return cipherText;
}

Uint8List aesCbcDecrypt(Uint8List key, Uint8List iv, Uint8List cipherText) {
  assert([128, 192, 256].contains(key.length * 8));
  assert(128 == iv.length * 8);
  assert(128 == cipherText.length * 8);

  // Create a CBC block cipher with AES, and initialize with key and IV

  final cbc = CBCBlockCipher(AESEngine())
    ..init(false, ParametersWithIV(KeyParameter(key), iv)); // false=decrypt

  // Decrypt the cipherText block-by-block

  final paddedPlainText = Uint8List(cipherText.length); // allocate space

  var offset = 0;
  while (offset < cipherText.length) {
    offset += cbc.processBlock(cipherText, offset, paddedPlainText, offset);
  }
  assert(offset == cipherText.length);

  return paddedPlainText;
}
