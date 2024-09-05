import 'package:car_shop/others/utils.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool isDark = false;
  int selectedPos = 0;
  int paymentPos = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back,
                size: 30,)),
                Text("Settings",style: Utils.getBold().copyWith(fontSize: 20),)
              ],
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
              child: Row(
                children: [
                  Text("Theme",style: Utils.getBold().copyWith(fontSize: 20),),
                  const Spacer(),
                  Switch(value: isDark, onChanged: (value){

                    setState(() {
                      isDark = value;
                    });

                  })
                ],
              ),
            ),
            const Divider(),
            Padding(
               padding: const EdgeInsets.only(left: 20,right: 20,top: 5),
              child: Row(
                children: [
                  Text("Language",style: Utils.getBold().copyWith(fontSize: 20),),
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
                                    Radio(
                                        value: index,
                                        groupValue: selectedPos,
                                        onChanged: (value){
                                          setState(() {
                                            selectedPos = value!;
                                          });
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
                  Text("Payment Method",style: Utils.getBold().copyWith(fontSize: 20),),
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
                  Text("Feedback",style: Utils.getBold().copyWith(fontSize: 20),),
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
