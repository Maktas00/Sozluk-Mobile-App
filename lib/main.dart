
import 'package:flutter/material.dart';
import 'package:sozluk_uygulamasi/DetaySayfa.dart';
import 'package:sozluk_uygulamasi/Kelimelerdao.dart';

import 'Kelimeler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {


  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaYapiliyormu=false;
  String aramaKelimesi="";

  Future<List<Kelimeler>> tumKelimeleriGoster() async{
    var kelimelerListesi=await Kelimelerdao().tumKelimeler();

    return kelimelerListesi;

  }
  Future<List<Kelimeler>> aramaYap(String aramaKelimesi) async{
    var kelimelerListesi=await Kelimelerdao().kelimeAra(aramaKelimesi);

    return kelimelerListesi;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYapiliyormu ?
            TextField(
              decoration: InputDecoration(hintText: "Arama için bir şey yazın"),
              onChanged: (aramaSonucu){
                print("Arama Sonucu :$aramaSonucu");
                setState(() {
                  aramaKelimesi=aramaSonucu;

                });
              },

            ): Text("Sözlük Uygulaması"),
        actions: [
          aramaYapiliyormu ?
      IconButton(
      icon: Icon(Icons.cancel),
      onPressed: (){
        setState(() {
          aramaYapiliyormu=false;
          aramaKelimesi="";
        });
      },
    )
          : IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              setState(() {
                aramaYapiliyormu=true;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Kelimeler>>(
        future: aramaYapiliyormu ? aramaYap(aramaKelimesi):  tumKelimeleriGoster(),
        builder: (context,snaphshot){
          if(snaphshot.hasData){
            var kelimelerListesi=snaphshot.data;
            return ListView.builder(
              itemCount: kelimelerListesi!.length,
              itemBuilder: (context,indeks){
                var kelime=kelimelerListesi[indeks];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DetaySayfa(kelime: kelime,)));
                  },
                  child: SizedBox(
                    height: 50,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(kelime.ingilizce,style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(kelime.turkce),

                        ],
                      ),
                    ),
                  ),
                );
              },
            );

          }else{
            return Center();
          }
        },
      ),

    );
  }
}
