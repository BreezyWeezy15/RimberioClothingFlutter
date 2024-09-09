import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_shop/auth/api_service.dart';
import 'package:car_shop/auth/product_service.dart';
import 'package:car_shop/bloc/app_bloc.dart';
import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/bloc/app_state.dart';
import 'package:car_shop/bloc/product_bloc.dart';
import 'package:car_shop/db/store_helper.dart';
import 'package:car_shop/json/locale_keys.g.dart';
import 'package:car_shop/models/product.dart';
import 'package:car_shop/models/user_model.dart';
import 'package:car_shop/others/utils.dart';
import 'package:car_shop/routes/app_routing.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' hide Trans;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // You can safely remove the event dispatching from initState
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => AppBloc(AuthService())),
              BlocProvider(create: (_) => ProductBloc(ProductService(), StoreHelper())),
            ],
            child: Builder(
              builder: (context) {
                // Schedule the event dispatch after the widget tree has been built
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  BlocProvider.of<AppBloc>(context).add(UserInfoEvent());
                  BlocProvider.of<ProductBloc>(context).add(GetProductsEvent("electronics"));
                });

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getData(context),
                    const Divider(),
                    const SizedBox(height: 25),
                    _buildCarousel(context),
                    const SizedBox(height: 20),
                    Text(
                      LocaleKeys.categories.tr(),
                      style: Utils.getBold().copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(Utils.categories.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              BlocProvider.of<ProductBloc>(context).add(
                                  GetProductsEvent(Utils.categoriesNames[index].toLowerCase()));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.black87),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Center(
                                        child: Image.asset(
                                          Utils.categories[index],
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(Utils.categoriesNames[index].capitalize!),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _showData(context),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
  
  _getData(BuildContext context){
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is UserInfoState) {
          UserModel? userModel = state.userModel;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userModel!.fullName,
                style: Utils.getMedium().copyWith(fontSize: 20),
              ),
              const Spacer(),
              CircleAvatar(
                radius: 17,
                backgroundColor: Colors.grey.shade200,
                child: IconButton(
                  onPressed: () {
                    Get.toNamed(AppRouting.cartPage);
                  },
                  icon: const Icon(Icons.add_shopping_cart_outlined, size: 15),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRouting.settingsPage);
                },
                child: CircleAvatar(
                  radius: 15,
                  child: Image.network(
                    userModel.profileUrl,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
  _buildCarousel(BuildContext context){
    return CarouselSlider(
      items: Utils.banners.map((e) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            e,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
      options: CarouselOptions(
        viewportFraction: 1.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
      ),
    );
  }
  _showData(BuildContext context){
    return Expanded(
      child: BlocBuilder<ProductBloc, AppState>(
        builder: (context, state) {
          if (state is LOADING) {
            return const Center(
              child: SpinKitFadingCube(
                color: Colors.blue,
                size: 20,
              ),
            );
          } else if (state is ERROR) {
            return Center(
              child: Text(
                'No Products',
                style: Utils.getBold().copyWith(fontSize: 25),
              ),
            );
          } else if (state is GetProductsState) {
            List<Product>? data = state.list;
            return GridView.builder(
              restorationId: 'store_data',
              shrinkWrap: true,
              itemCount: data?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AppRouting.detailsPage,
                      arguments: {"productID": data[index].id},
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.black26),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: data![index].image,
                                height: 150,
                                width: 150,
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                },
                                placeholder: (context, url) => const SizedBox(
                                  height: 140,
                                  width: 140,
                                  child: Center(
                                    child: SpinKitFadingCube(
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                              Positioned(
                                right: 0,
                                top: 10,
                                child: Container(
                                  width: 80,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: Colors.red,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "50% OFF",
                                      style: Utils.getBold()
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                          child: Text(
                            data[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Utils.getMedium().copyWith(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            "\$${data[index].price}",
                            style: Utils.getBold()
                                .copyWith(color: Colors.blue, fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: Text(
              'No Products',
              style: Utils.getBold().copyWith(fontSize: 25),
            ),
          );
        },
      ),
    );
  }
}
