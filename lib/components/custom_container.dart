import 'package:car_shop/others/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class CustomContainer extends StatelessWidget {
  final String text;
  final bool isLoading;
  final Function() onTap;
  const CustomContainer({super.key,required this.text,required this.isLoading,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.blue
        ),
        child: Center(
          child: isLoading == true ?  const SizedBox(width: 20,height: 20,child: SpinKitFadingCube(color: Colors.white,size: 20,),) :
          Text(text,style: Utils.getMedium().copyWith(color: Colors.white,fontSize: 20),),
        ),
      ),
    );
  }
}
