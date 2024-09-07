

import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/storage/storage_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/product_service.dart';
import '../db/store_helper.dart';
import '../models/product.dart';
import 'app_state.dart';

class ProductBloc extends Bloc<AppEvent,AppState> {

  StoreHelper storeHelper;
  ProductService productService;
  ProductBloc(this.productService,this.storeHelper) : super(INITIAL()){

    on<GetProductsEvent>((event,emit) => _getProducts(event, emit));
    on<GetProductEvent>((event,emit) => _getProduct(event, emit));
    on<GetCartItemsEvent>((event,emit) => _getCartItems(event, emit));
    on<GetSaveCartEvent>((event,emit) => _saveCart(event, emit));
    on<GetDeleteCartItemEvent>((event,emit) => _deleteCartItem(event, emit));
    on<GetDeleteCartEvent>((event,emit) => _deleteCart(event, emit));
    on<GetTotalPriceEvent>((event,emit) => _getTotalPrice(event, emit));
    on<GetUpdateCartEvent>((event,emit) => _updateCart(event, emit));
  }

  _getProducts(GetProductsEvent event,Emitter<AppState> emit) async {
    try {
      emit(LOADING());
      List<Product>? list = await productService.getProducts(event.productCategory);
      emit(GetProductsState(list));
    } catch(e){
      emit(ERROR(e.toString()));
    }
  }
  _getProduct(GetProductEvent event,Emitter<AppState> emit) async {
    try {
      emit(LOADING());
      Product? product = await productService.getProduct(event.productId);
      emit(GetProductState(product));
    } catch(e){
      emit(ERROR(e.toString()));
    }
  }
  _getCartItems(GetCartItemsEvent event, Emitter<AppState> emit) async {
    try {
      emit(LOADING());
      List<StoreData> cartItems = await storeHelper.getCartItems();  // Replace with your actual service method
      emit(GetCartItemsState(cartItems));
    } catch (e) {
      emit(ERROR(e.toString()));
    }
  }
  _saveCart(GetSaveCartEvent event, Emitter<AppState> emit) async {
    try {
      emit(LOADING());
      int result = await storeHelper.saveCart(event.companion);  // Replace with your actual service method and event parameter
      emit(GetSaveCartState(result));
    } catch (e) {
      emit(ERROR(e.toString()));
    }
  }
  _deleteCartItem(GetDeleteCartItemEvent event, Emitter<AppState> emit) async {
    try {
      emit(LOADING());
      int itemId = await storeHelper.deleteCartItem(event.itemId);  // Replace with your actual service method
      emit(GetDeleteCartItemState(itemId));
    } catch (e) {
      emit(ERROR(e.toString()));
    }
  }
  _deleteCart(GetDeleteCartEvent event, Emitter<AppState> emit) async {
    try {
      emit(LOADING());
      int result = await storeHelper.deleteCart();  // Replace with your actual service method
      emit(GetDeleteCartState(result));
    } catch (e) {
      emit(ERROR(e.toString()));
    }
  }

  _updateCart(GetUpdateCartEvent event, Emitter<AppState> emit) async {
    int result = await storeHelper.updateCart(event.companion);  // Replace with your actual service method
    emit(GetUpdateCartState(result));
  }

  _getTotalPrice(GetTotalPriceEvent event, Emitter<AppState> emit) async {
    double result = await storeHelper.getTotalPrice();  // Replace with your actual service method
    emit(GetTotalPriceState(result));
  }

}
