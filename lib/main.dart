import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'ktp.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<ktp>(ktpAdapter());
  await Hive.openBox<ktp>('myBox');
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyFormModel(),
      child: MyApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'first',
      path: '/',
      builder: (context, state) => MyForm(),
    ),
    GoRoute(
      name: 'second',
      path: '/second',
      builder: (context, state) => ListForm(),
    ),
  ],
);

Future<String> loadAsset1() async {
  return await rootBundle.loadString('regencies.json');
}

Future<String> loadAsset2() async {
  return await rootBundle.loadString('provinces.json');
}

Future DataProvinsi() async {
  try {
    String jsonContent = await loadAsset2();
    List<dynamic> jsonData = jsonDecode(jsonContent);
    List<dynamic> provinsi = List.generate(jsonData.length, (index) => jsonData[index]);
    // print('${kabupaten}');
    return provinsi;
    // Now you can use the parsed data
  } catch (e) {
    print('Error reading or parsing the JSON file: $e');
  }
}

Future DataKabupaten() async {
  try {
    String jsonContent = await loadAsset1();
    List<dynamic> jsonData = jsonDecode(jsonContent);
    List<dynamic> kabupaten = List.generate(jsonData.length, (index) => jsonData[index]);
    // print('${kabupaten}');
    return kabupaten;
    // Now you can use the parsed data
  } catch (e) {
    print('Error reading or parsing the JSON file: $e');
  }
}


class MyFormModel extends ChangeNotifier {
  String selectedOption = 'Pilih Kabupaten';
  String selectedProvince = '';
  List<dynamic> kabupatenList = [];
  List<dynamic> provinsiList = [];
  String indexProvinsi = '';
  String provinsinya = 'Provinsi';
  var box = Hive.box<ktp>('myBox');
  List<dynamic> dataList = [];

  void setSelectedOption(String newValue) {
    selectedOption = newValue;
    notifyListeners();
  }

  void setProvince(String newValue) {
        provinsinya = newValue;
        print(provinsinya);
        notifyListeners();
      }

  void setProvinceIndex(String kabupatenPilihan){
    for (var i = 0 ; i <= kabupatenList.length ; i++){
      if(kabupatenList[i]['name'] == kabupatenPilihan){
        indexProvinsi = kabupatenList[i]['province_id'];
        print(indexProvinsi);
        notifyListeners();
      }
    }
  }

  void setDataFromBox(){
    dataList = box.values.toList().reversed.toList();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class MyForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _namacontroller = TextEditingController();
  TextEditingController _ttlcontroller = TextEditingController();
  TextEditingController _kabupatencontroller = TextEditingController();
  TextEditingController _provinsicontroller = TextEditingController();
  TextEditingController _pekerjaancontroller = TextEditingController();
  TextEditingController _pendidikancontroller = TextEditingController();

  MyForm(){
  }

  @override
  Widget build(BuildContext context) {
    MyFormModel formModel = Provider.of<MyFormModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Project KTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namacontroller,
                decoration: InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 5.0
                      )
                    )),
                // validator: (){},
                onChanged: (value) {
                },
              ),
              SizedBox(height: 5.0),
              TextFormField(
                controller: _ttlcontroller,
                decoration: InputDecoration(
                    labelText: 'Tempat, Tanggal Lahir',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 5.0
                        )
                    )),
                // validator: () {},
              ),
              SizedBox(height: 5.0),
              FutureBuilder (
                future: DataKabupaten(),
                builder: (context, snapshot){
                  if (snapshot.hasData){
                    formModel.kabupatenList = snapshot.data!;
                    // print('${snapshot.data!}');
                    // print('${formModel.kabupatenList}');
                return Row(
                  children: [
                    Text('Kabupaten '),
                    DropdownButton(
                        items: List.generate(formModel.kabupatenList.length, (index) =>
                            DropdownMenuItem(
                                value: formModel.kabupatenList[index]['name'],
                                child: Text('${formModel.kabupatenList[index]['name']}'))),
                        onChanged: (newValue){
                          Provider.of<MyFormModel>(context, listen: false).setSelectedOption('${newValue}');
                          // formModel.setProvinceIndex(formModel.selectedOption);
                          // print(formModel.indexProvinsi);
                        }),
                    Consumer<MyFormModel>(
                        builder: (context, dropdown, child){
                          return Text('${dropdown.selectedOption}');}

                    )],
                );}
                  else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                  }else {
                    return Text('');
                  }
                  },
              ),
              SizedBox(height: 5.0),
              FutureBuilder (
                future: DataProvinsi(),
                builder: (context, snapshot){
                  if (snapshot.hasData){
                    formModel.provinsiList = snapshot.data!;
                    // print('${snapshot.data!}');
                    // print('${formModel.kabupatenList}');
                    return Row(
                      children: [
                        Text('Provinsi'),
                        ElevatedButton(onPressed: (){
                          Provider.of<MyFormModel>(context, listen: false).setProvinceIndex('${formModel.selectedOption}');
                          List.generate(formModel.provinsiList.length, (index) {
                            if(formModel.provinsiList[index]['id'] == formModel.indexProvinsi){
                              formModel.provinsinya = formModel.provinsiList[index]['name'];
                              print(formModel.provinsinya);
                            }
                          } );
                        }, child: Text('Index Provinsi')),
                        ElevatedButton(onPressed: (){
                          // Provider.of<MyFormModel>(context, listen: false).setProvinceIndex('${formModel.selectedOption}');
                          List.generate(formModel.provinsiList.length, (index) {
                            if(formModel.provinsiList[index]['id'] == formModel.indexProvinsi){
                              Provider.of<MyFormModel>(context, listen: false).setProvince(formModel.provinsiList[index]['name']);
                            }
                          } );
                        }, child: Text('Ambil Provinsi')),
                        Consumer<MyFormModel>(builder: (context, province, child){
                          return Text('${formModel.provinsinya}');
                        })
                      ],
                    );}
                  else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }else {
                    return Text('');
                  }
                },
              ),
              SizedBox(height: 5.0),
              TextFormField(

                controller: _pekerjaancontroller,
                decoration: InputDecoration(
                    labelText: 'Pekerjaan',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 5.0
                        )
                    )),
                // validator: () {},
              ),
              SizedBox(height: 5.0),
              TextFormField(
                controller: _pendidikancontroller,
                decoration: InputDecoration(
                    labelText: 'Pendidikan',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 5.0
                        )
                    )),
                // validator: () {},
              ),
              SizedBox(height: 5.0),
              ElevatedButton(
                onPressed: () {
                    
                    // Form is valid, process the data
                    String name = _namacontroller.text;
                    String ttl = _ttlcontroller.text;
                    String kabupaten = formModel.selectedOption;
                    String provinsi = formModel.provinsinya;
                    String pekerjaan = _pekerjaancontroller.text;
                    String pendidikan = _pendidikancontroller.text;
                    // You can now use the name and email variables as needed
                    ktp dataktp = ktp(
                        nama: name,
                        ttl: ttl,
                        kabupaten: kabupaten,
                        provinsi: provinsi,
                        pekerjaan: pekerjaan,
                        pendidikan: pendidikan);
                    // For demonstration, just printing the values
                    formModel.box.add(dataktp);
                    Provider.of<MyFormModel>(context, listen: false).setDataFromBox();
                    context.go('/second');
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    MyFormModel formModel = Provider.of<MyFormModel>(context);
    return Scaffold(body :Consumer(builder: (context, list, child){return
          ListView(
                      children: List.generate(formModel.dataList.length, (index) =>
                          ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: EdgeInsets.zero,
                            leading: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: (){
                                formModel.box.delete(index);
                                Provider.of<MyFormModel>(context, listen: false).setDataFromBox();
                                },
                            ),
                            title: Text('${formModel.dataList[index].nama}'),

                          )),
                    );},

      ),
    );
  }
}
