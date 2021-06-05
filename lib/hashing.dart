import 'package:crypt/crypt.dart';

Crypt hashing(String pass) {
  final c1 = Crypt.sha256(pass);
  return c1;
}
