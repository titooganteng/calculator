import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Kalkulator IPhone",
      theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
          textTheme: const TextTheme(
              bodyMedium: TextStyle(
            color: Colors.white,
          ))),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  //class calculator adalah widget stateful karena memiliki nilai yang selalu berubah ketika tombolnya ditekan

  @override
  // ignore: library_private_types_in_public_api
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State {
  String output =
      "0"; //output merupakan variable yang menampung nilaiyang akan ditampilkan di kalkulator

  void buttonPressed(String buttonText) {
    //fungsi buttonpressed yang akan dipanggil ketika tombol ditekan
    setState(() {
      if (buttonText == "C") {
        //jika tombol C ditekan, output diubah menjadi 0
        output = "0";
      } else if (buttonText == "=") {
        //jika tombol = ditekan, output diubah menjadi hasil dari expression
        try {
          output = evaluateExpression(
              output.replaceAll("×", "*").replaceAll("÷", "/"),
              ); //evaluate expression adalah fungsi yang digunakan untuk menghitung hasil dari expression
        } catch (e) {
          //catch digunakan untuk menangani kesalahan yang terjadi ketika menghitung expression (contohnya jika user memasukkan fungsi yang tidak valid seperti 1++2 atau hanya +)
          output =
              "Error"; //jika terjadi kesalahan, output yang muncul di kalkulator diubah menjadi Error
        }
      } else {
        if (output == "0") {
          output = buttonText;
        } else {
          output += buttonText;
        }
      }
    });
  }

  String evaluateExpression(String expression) {
    //fungsi ini digunakan untuk mengonversi expression menjadi hasil perhitungan. fungsi ini diambil dari expression.dart
    final parsedExpression = Expression.parse(
        expression); //digunakan untuk mengonversi string menjadi expression yang dapat dipahami oleh komputer
    final evaluator = ExpressionEvaluator();
    final result = evaluator.eval(parsedExpression,
        {}); //digunakan untuk mengevaluasi expression dan mengambil nilai sebagai String
    return result.toString(); //mengembalikan nilai kepada String
  }

  Widget buildButton(String buttonText, Color color,
      {double widthFactor = 1.0}) {
    //fungsi ini digunakan untuk membuat widget tombol dengan text, warna dan ukuran yang sudah ditentukan
    return Expanded(
      //membuat tombol dapat mengisi ruang horizontal yang tersedia dalam 1 baris atau 1 row
      flex: widthFactor
          .toInt(), //widthFactor digunakan untuk menentukan lebar tombol menjadi 1, flex digunakan untuk menentukan proporsi lebar tombol dalam baris
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          //digunakan untuk membuat tombol dengan gaya tertentu
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
                vertical:
                    22), //digunakan untuk mengatur jarak dalam tombol secara vertical menjadi 22 sehingga tombol terlihat tinggi
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  40.0), //digunakan untuk membuat sudut tombol melengkung dengan radius 40
            ),
            elevation: 0, //mengatur bayangan tombol menjadi 0 dan tampak datar
          ),
          onPressed: () => buttonPressed(
              buttonText), //ketika ditekan, fungsi buttonPressed dipanggil dengan parameter buttonText
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //fungsi build digunakan untuk membuat tampilan utama
    return Scaffold( //digunakan untuk membuat struktur dasar untuk halaman
      body: Column(
        crossAxisAlignment: CrossAxisAlignment
            .stretch, //tanpa CrossAxisAlignmentnstretch, tombol-tombol tersebut akan memiliki lebar sesuai dengan ukuran teksnya masing masing atau pengaturan default widget tombol
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(right: 24, bottom: 24),
            alignment: Alignment.bottomRight,
            child: Text(
              output,
              style: const TextStyle(
                fontSize: 80,
                color: Colors.white,
              ),
            ),
          )),
          Column(
            children: [
              Row(children: [
                buildButton("C", Colors.grey.shade600),
                buildButton("+/-", Colors.grey.shade600),
                buildButton("%", Colors.grey.shade600),
                buildButton("÷", Colors.orange),
              ]),
              Row(children: [
                buildButton("7", Colors.grey.shade600),
                buildButton("8", Colors.grey.shade600),
                buildButton("9", Colors.grey.shade600),
                buildButton("×", Colors.orange),
              ]),
              Row(children: [
                buildButton("4", Colors.grey.shade600),
                buildButton("5", Colors.grey.shade600),
                buildButton("6", Colors.grey.shade600),
                buildButton("+", Colors.orange),
              ]),
              Row(children: [
                buildButton("1", Colors.grey.shade600),
                buildButton("2", Colors.grey.shade600),
                buildButton("3", Colors.grey.shade600),
                buildButton("-", Colors.orange),
              ]),
              Row(
                children: [
                  buildButton("0", Colors.grey.shade800, widthFactor: 2), //widthfactor digunakan untuk mengatur lebar tombol menjadi 2
                  buildButton(".", Colors.grey.shade800),
                  buildButton("=", Colors.orange),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
