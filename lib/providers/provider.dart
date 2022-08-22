import 'package:flutter/widgets.dart';
import 'package:logandsign/model/product_model.dart';
import 'package:provider/provider.dart';

class Provider with ChangeNotifier {
  final favoriteChangeNotifierProvider =

  ChangeNotifierProvider<favoriteNotifire>(create: (ref)=>favoriteNotifire());
}
class favoriteNotifire extends ChangeNotifier{
  final List<Carft> _favoriteList=[];
  List<Carft> get favoriteList => _favoriteList;

  void addToFav(Carft product){
    _favoriteList.add(product);
    notifyListeners();
  }
  void removFromFav(Carft product){
    _favoriteList.remove(product);
    notifyListeners();
  }


}