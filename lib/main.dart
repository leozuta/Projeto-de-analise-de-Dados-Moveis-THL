import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void maim() {
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DataUsageMonitor(),
    );
  }
}

class DataUsageMonitor extends StatefulWidget {
  const DataUsageMonitor({super.key});

  @override
  _DataUsageMonitor createState() => _DataUsageMonitor();
}

class _DataUsageMonitor extends State<DataUsageMonitor> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  //define o intervalo de tempo
  void _startTimer() {
  const interval = Duration(hours: 1);
  _timer = Timer.periodic(interval, (timer) {
    _sendDataUsage();
  });
  } 
  
  Future<void> _sendDataUsage() async {
    //coleta de dados em MB
    double dataUsed = 100.0;
    String deviceName = "Meu Celular";

    //conexão com a API
    var url = Uri.parse('http://localhost:5000/api/data-usage');
    var response = await http.post(url, body: {
      'device-name': deviceName,
      'data_used_mb': dataUsed.toString(),
    });

    if (response.statusCode == 200) {
      print('Dados enviados com sucesso!');
    } else {
      print('Erro ao enviar dados.');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor de Dados Móveis'),
      ),
      body: Center(
        child: Text('Monitorando uso de dados...'),
      ),
    );
  }
}