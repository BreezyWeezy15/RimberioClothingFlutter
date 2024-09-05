import 'package:car_shop/others/utils.dart';
import 'package:car_shop/routes/app_routing.dart';
import 'package:car_shop/storage/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  late final PageController _pageController = PageController();
  int dotIndex = 0;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 30,),
            Expanded(child:  PageView(
              controller: _pageController,
              onPageChanged: (index){
                setState(() {
                  dotIndex = index;

                  if(index == 3){
                    isVisible = true;
                  } else {
                    isVisible = false;
                  }

                });

              },
              children: List.generate(Utils.titles.length, (index){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Utils.titles[index],style: Utils.getBold()
                      .copyWith(fontSize: 25),),
                    Image.asset(Utils.images[index],width: 250,height: 250,),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,bottom: 50),
                      child: Text(Utils.descriptions[index],style: Utils.getMedium()
                        .copyWith(fontSize: 25),textAlign: TextAlign.center,),
                    )
                  ],
                );
              }),
            )),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){

                      StorageHelper.setStatus();
                      Get.offNamed(AppRouting.loginPage);

                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 25,right: 25,top: 10,bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue
                      ),
                      child:  Center(
                        child: Text("Skip",style: Utils.getMedium().copyWith(
                            color: Colors.white
                        ),),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(4, (index){
                      return Container(
                        margin: const EdgeInsets.only(left: 5),
                        width: 10,
                        height: dotIndex == index ? 15 : 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: dotIndex == index ? Colors.black87 : Colors.black38
                        ),
                      );
                    }),
                  ),
                  Visibility(
                    visible: isVisible,
                    child: const Spacer(),
                  ),
                  Visibility(
                    visible: isVisible,
                    child: GestureDetector(
                      onTap: (){
                        StorageHelper.setStatus();
                        Get.offNamed(AppRouting.loginPage);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 25,right: 25,top: 10,bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue
                        ),
                        child:  Center(
                          child: Text("Go",style: Utils.getMedium().copyWith(
                              color: Colors.white
                          ),),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


}
