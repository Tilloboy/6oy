import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oltinchi_oy_imtihon_oddiygina/kirish/registratsiya/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  final String familiya;
  final String ism;

  const Homepage({Key? key, required this.familiya, required this.ism})
      : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool a = false; // Variable to toggle between SUM and currency

  void funk() {
    setState(() {
      a = !a; // Toggles between SUM and the selected currency
    });
  }

  late Future<List<dynamic>> _currencyData;
  late Stream<String> _timeStream;

  @override
  void initState() {
    super.initState();
    _currencyData = fetchCurrencyData(); // Fetch currency data
    _timeStream = _getTimeStream(); // Fetch real-time clock data
  }

  /// Fetches currency data from the API
  Future<List<dynamic>> fetchCurrencyData() async {
    final response = await http.get(
      Uri.parse('https://cbu.uz/uz/arkhiv-kursov-valyut/json/'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load currency data');
    }
  }

  /// Streams real-time device clock updates every second
  Stream<String> _getTimeStream() async* {
    while (true) {
      final now = DateTime.now();
      yield "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Text(
          "${widget.ism} ${widget.familiya}",
          style: TextStyle(fontSize: 23),
          overflow: TextOverflow.ellipsis, // This will add "..." if the text is too long
          maxLines: 1, // Ensures the text is displayed in one line
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                StreamBuilder<String>(
                  stream: _timeStream, // Real-time clock stream
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? "--:--:--",
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              // SharedPreferences instansiyasini olish
              final prefs = await SharedPreferences.getInstance();

              // Barcha ma'lumotlarni o'chirish
              await prefs.clear();

              // Registratsiya sahifasiga yo'naltirish
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => RegistratsiyaPage()),
                (route) => false, // Barcha sahifalarni tozalash
              );

              // Foydalanuvchiga xabar ko'rsatish
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Akkaunt muvaffaqiyatli o'chirildi!"),
                ),
              );
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _currencyData, // Fetching currency data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: snapshot.data!.map<Widget>((currency) {
                final difference = double.tryParse(currency['Diff']) ?? 0.0;
                final isPositive = difference > 0;

                return GestureDetector(
                  onTap: () {
                    TextEditingController amountController =
                        TextEditingController();
                    String result = ""; // Hisoblangan natijani saqlash uchun
                    showDialog(
                      context: context,
                      builder: (context) => StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: Text("${currency['Ccy']} ma'lumotlari"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Qiymati: ${currency['Rate']}"),
                                Text("Valyuta: ${currency['Ccy']}"),
                                Text("Nomi: ${currency['CcyNm_UZ']}"),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: amountController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Miqdor kiriting',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    // Hisoblash amali
                                    double rate =
                                        double.tryParse(currency['Rate']) ?? 0.0;
                                    double amount = double.tryParse(
                                            amountController.text) ?? 0.0;

                                    setState(() {
                                      if (a) {
                                        // SUM dan valyutaga hisoblash
                                        result =
                                            "${(amount / rate).toStringAsFixed(2)} ${currency['Ccy']}";
                                      } else {
                                        // Valyutadan SUM ga hisoblash
                                        result =
                                            "${(amount * rate).toStringAsFixed(2)} SUM";
                                      }
                                    });
                                  },
                                  child: const Text("Hisoblash"),
                                ),
                                const SizedBox(height: 20),
                                if (result.isNotEmpty) // Natijani chiqarish
                                  Text(
                                    "$result",
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                              ],
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        a = !a; // Toggles between SUM and currency
                                      });
                                    },
                                    child: Text(a ? "SUM" : currency['Ccy']),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Qaytish'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yangi kun: ${currency['Date']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '1 ${currency['Ccy']}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        currency['CcyNm_UZ'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.deepPurple),
                                      ),
                                      Text(
                                        " (${currency["Code"]})",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.deepPurple),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    currency['Rate'],
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                isPositive
                                    ? '+${difference.toStringAsFixed(2)}'
                                    : '${difference.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isPositive
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
