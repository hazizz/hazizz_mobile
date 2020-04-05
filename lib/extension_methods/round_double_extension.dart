import 'dart:math';

extension RoundDoubleExtension on double{
  double round2({int decimals = 2}){
    int fac = pow(10, decimals);
    return (this * fac).round() / fac;
  }
}