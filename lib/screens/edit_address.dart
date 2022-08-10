import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitax/screens/profile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:monitax/config.dart';
import 'package:monitax/models/indonesia.dart';
import 'package:change_case/change_case.dart';

class EditAddress extends StatefulWidget {
  final String data;
  EditAddress({Key? key, required this.data}) : super(key: key);
  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final _formkey = GlobalKey<FormState>();
  final txtAddress = TextEditingController();
  late bool isLoading = false;
  bool isUpdated = false;
  int? selectedProvinsi;
  int? selectedCity;
  int? selectedKecamatan;
  int? selectedKelurahan;

  @override
  void initState() {
    super.initState();
    txtAddress.text = widget.data;
    setState(() {
      isUpdated = false;
      selectedProvinsi = 0;
      selectedCity = 0;
      selectedKecamatan = 0;
      selectedKelurahan = 0;
    });
  }

  Future<List<Provinsi>> getProvincies() async {
    Dio dio = Dio();
    Response response;
    List<Provinsi> provincies = [];
    response = await dio.get('${Config.apiURL}/indonesia/provinsi');

    for (final element in response.data) {
      provincies.add(Provinsi.fromMap(element));
    }
    provincies.insert(
        0, Provinsi(locationid: 1, prov_id: 0, prov_name: '', status: 0));
    return provincies;
  }

  Future<List<Kota>> getCity({required int id_provinsi}) async {
    Dio dio = Dio();
    Response response;
    List<Kota> cities = [];
    response = await dio
        .get('${Config.apiURL}/indonesia/kota?id_provinsi=$id_provinsi');
    for (final element in response.data) {
      cities.add(Kota.fromMap(element));
    }
    cities.insert(0, Kota(city_id: 0, city_name: ''));
    return cities;
  }

  Future<List<Kecamatan>> getDistricts({required int id_kota}) async {
    Dio dio = Dio();
    Response response;
    List<Kecamatan> districts = [];
    response =
        await dio.get('${Config.apiURL}/indonesia/kecamatan?id_city=$id_kota');
    for (final element in response.data) {
      districts.add(Kecamatan.fromMap(element));
    }
    districts.insert(0, Kecamatan(dis_id: 0, dis_name: ''));
    return districts;
  }

  Future<List<Kelurahan>> getSubDistricts({required int id_kecamatan}) async {
    Dio dio = Dio();
    Response response;
    List<Kelurahan> subdistricts = [];
    response = await dio
        .get('${Config.apiURL}/indonesia/kelurahan?id_kecamatan=$id_kecamatan');
    for (final element in response.data) {
      subdistricts.add(Kelurahan.fromMap(element));
    }
    subdistricts.insert(0, Kelurahan(subdis_id: 0, subdis_name: ''));
    return subdistricts;
  }

  doUpdate() async {
    setState(() {
      isLoading = true;
      isUpdated = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var url = '${Config.apiURL}/users/me/profile';
    final body = jsonEncode({'address': txtAddress.text});
    final response = await http
        .patch(Uri.parse(url),
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
              'Access-Control_Allow_Origin': '*',
              'Authorization': 'Bearer $token'
            },
            body: body,
            encoding: Encoding.getByName('utf-8'))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == HttpStatus.ok) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      showTopSnackBar(
          context, const CustomSnackBar.success(message: 'Update success'));
    } else {
      // ignore: use_build_context_synchronously
      showTopSnackBar(
          context, const CustomSnackBar.error(message: 'Update failed'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!isUpdated) {
              Navigator.of(context).pop();
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const Profile(),
                ),
                (route) => false,
              );
            }
          },
          child: const Icon(Icons.arrow_back),
        ),
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Edit Address'),
        ),
        body: Form(
            key: _formkey,
            child: ListView(children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 20, left: 40),
                      child: Text('Provinsi'),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: FutureBuilder<List<Provinsi>>(
                          future: getProvincies(),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              List<Provinsi> provinsis = snapshot.data!;
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: DropdownButtonFormField<int>(
                                    value: selectedProvinsi,
                                    items: provinsis.map((e) {
                                      return DropdownMenuItem<int>(
                                          value: e.prov_id,
                                          child: Text(
                                            e.prov_name
                                                .toLowerCase()
                                                .toTitleCase(),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ));
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedProvinsi = newValue;
                                        selectedCity = 0;
                                        selectedKecamatan = 0;
                                        selectedKelurahan = 0;
                                      });
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return const Center(
                                child: SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    )),
                              );
                            }
                          })),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20, left: 40),
                      child: Text('Kota/Kabupaten'),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: FutureBuilder<List<Kota>>(
                          future: getCity(id_provinsi: selectedProvinsi!),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    )),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                List<Kota> cities = snapshot.data!;
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    child: DropdownButtonFormField<int>(
                                      value: selectedCity,
                                      items: cities.map((e) {
                                        return DropdownMenuItem<int>(
                                            value: e.city_id,
                                            child: Text(
                                              e.city_name
                                                  .toLowerCase()
                                                  .toTitleCase(),
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ));
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedCity = newValue;
                                          selectedKecamatan = 0;
                                          selectedKelurahan = 0;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return const Center(child: Text('Error'));
                              } else {
                                return const Center(
                                  child: Text('Empty data'),
                                );
                              }
                            } else {
                              return Center(
                                child:
                                    Text('State: ${snapshot.connectionState}'),
                              );
                            }
                          })),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20, left: 40),
                      child: Text('Kecamatan'),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: FutureBuilder<List<Kecamatan>>(
                          future: getDistricts(id_kota: selectedCity!),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    )),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                List<Kecamatan> districts = snapshot.data!;
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    child: DropdownButtonFormField<int>(
                                      value: selectedKecamatan,
                                      items: districts.map((e) {
                                        return DropdownMenuItem<int>(
                                            value: e.dis_id,
                                            child: Text(
                                              e.dis_name
                                                  .toLowerCase()
                                                  .toTitleCase(),
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ));
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedKecamatan = newValue;
                                          selectedKelurahan = 0;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return const Center(child: Text('Error'));
                              } else {
                                return const Center(
                                  child: Text('Empty data'),
                                );
                              }
                            } else {
                              return Center(
                                child:
                                    Text('State: ${snapshot.connectionState}'),
                              );
                            }
                          })),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20, left: 40),
                      child: Text('Kelurahan'),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: FutureBuilder<List<Kelurahan>>(
                          future:
                              getSubDistricts(id_kecamatan: selectedKecamatan!),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    )),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                List<Kelurahan> subdistricts = snapshot.data!;
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    child: DropdownButtonFormField<int>(
                                      value: selectedKelurahan,
                                      items: subdistricts.map((e) {
                                        return DropdownMenuItem<int>(
                                            value: e.subdis_id,
                                            child: Text(
                                              e.subdis_name
                                                  .toLowerCase()
                                                  .toTitleCase(),
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ));
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedKelurahan = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return const Center(child: Text('Error'));
                              } else {
                                return const Center(
                                  child: Text('Empty data'),
                                );
                              }
                            } else {
                              return Center(
                                child:
                                    Text('State: ${snapshot.connectionState}'),
                              );
                            }
                          })),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40, left: 40),
                          child: SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextField(
                              minLines: 2,
                              maxLines: 3,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                  labelText: 'Address',
                                  prefixIcon: Icon(Icons.mail)),
                              controller: txtAddress,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 32,
                            child: ElevatedButton(
                              child: (isLoading)
                                  ? const SizedBox(
                                      width: 16,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ))
                                  : const Text(
                                      'Update',
                                      style: TextStyle(fontSize: 16),
                                    ),
                              onPressed: () {
                                doUpdate();
                              },
                            ),
                          )),
                    )
                  ]),
            ])));
  }
}
