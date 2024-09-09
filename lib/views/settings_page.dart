import 'package:car_shop/bloc/app_bloc.dart';
import 'package:car_shop/bloc/app_event.dart';
import 'package:car_shop/json/locale_keys.g.dart';
import 'package:car_shop/others/utils.dart';
import 'package:car_shop/storage/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  ThemeMode themeMode = ThemeMode.light;
  bool isDark = false;
  int selectedPos = 0;
  int paymentPos = 0;


  @override
  void initState() {
    super.initState();

    isDark = StorageHelper.getMode();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                IconButton(onPressed: (){
                  Get.back();
                }, icon: const Icon(Icons.arrow_back,
                size: 30,)),
                Text(LocaleKeys.settings.tr(),style: Utils.getBold().copyWith(fontSize: 20),)
              ],
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
              child: Row(
                children: [
                  Text(LocaleKeys.theme.tr(),style: Utils.getBold().copyWith(fontSize: 20),),
                  const Spacer(),
                  Switch(value: isDark, onChanged: (value){

                    setState(() {
                      isDark = value;
                      isDark ? themeMode = ThemeMode.dark : themeMode = ThemeMode.light;
                    });
                    StorageHelper.setMode(isDark);
                    Get.changeThemeMode(themeMode);
                    BlocProvider.of<AppBloc>(context).add(GetThemeEvent(themeMode));

                  })
                ],
              ),
            ),
            const Divider(),
            Padding(
               padding: const EdgeInsets.only(left: 20,right: 20,top: 5),
              child: Row(
                children: [
                  Text(LocaleKeys.language.tr(),style: Utils.getBold().copyWith(fontSize: 20),),
                  const Spacer(),
                  IconButton(onPressed: (){

                     // show dialog
                    showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(Utils.flags.length, (index){
                                return Row(
                                  children: [
                                    Image.asset(Utils.flags[index],width: 40,height: 40,fit: BoxFit.cover,),
                                    const SizedBox(width: 10,),
                                    Text(Utils.languages[index],style: Utils.getBold().copyWith(fontSize: 20),),
                                    const Spacer(),
                                    Radio<int>(
                                        value: index,
                                        groupValue: selectedPos,
                                        onChanged: (int? value) async {
                                          setState(() {
                                            selectedPos = value!;
                                          });
                                          StorageHelper.setLanguage(Utils.languagesIso[index]);
                                          await context.setLocale(Locale(Utils.languagesIso[index]));
                                          Get.updateLocale(Locale(Utils.languagesIso[index]));
                                          if(context.mounted) Navigator.pop(context);
                                        })
                                  ],
                                );
                              }),
                            ),
                          );
                        });

                  }, icon: const Icon(Icons.sign_language_outlined))
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,top: 5),
              child: Row(
                children: [
                  Text(LocaleKeys.paymentMethod.tr(),style: Utils.getBold().copyWith(fontSize: 20),),
                  const Spacer(),
                  IconButton(onPressed: (){

                    showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(Utils.paymentsLogos.length, (index){
                                return Row(
                                  children: [
                                    Image.asset(Utils.paymentsLogos[index],width: 90,height: 40,fit: BoxFit.cover,),
                                    const Spacer(),
                                    Radio(
                                        value: index,
                                        groupValue: paymentPos,
                                        onChanged: (value){
                                          setState(() {
                                            paymentPos = value!;
                                          });
                                          StorageHelper.setPaymentMethod(Utils.payments[index]);
                                          Navigator.pop(context);

                                        })
                                  ],
                                );
                              }),
                            ),
                          );
                        });

                  }, icon: const Icon(Icons.payment))
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,top: 5),
              child: Row(
                children: [
                  Text(LocaleKeys.feedback.tr(),style: Utils.getBold().copyWith(fontSize: 20),),
                  const Spacer(),
                  IconButton(onPressed: (){}, icon: const Icon(Icons.feedback))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
