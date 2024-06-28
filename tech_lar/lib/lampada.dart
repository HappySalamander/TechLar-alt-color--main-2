import 'package:flutter/material.dart';
//import 'dart:async';
import '_mqtt.dart';

const double minWidth = 320;
const double minHeight = 320;

class Lampada extends StatefulWidget {
  @override
  State<Lampada> createState() => _LampadaState();
}

class _LampadaState extends State<Lampada> {
  bool notification = false;
  void DesativarNotificacao() {
    setState(() {
      notification = !notification;
    });
  }

  List<bool> switchesState = [false, false, false, false, false, false, false];
  List<double> luminosidade = [50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0];
  List<String> comodos = [
    "Quarto",
    "Banheiro",
    "Sala",
    "Cozinha",
    "Dispensa",
    "Garagem",
    "Closet"
  ];

  final MqttService _mqttService = MqttService();

  @override
  void initState() {
    super.initState();
    _mqttService.initializeMqttClient();
    _mqttService.connect();
  }

  @override
  void dispose() {
    _mqttService.disconnect();
    super.dispose();
  }

  void adicionarComodo(String novoComodo) {
    setState(() {
      comodos.add(novoComodo);
      switchesState.add(false);
      luminosidade.add(50.0);
    });
  }

  void _sendMqttBrightnessMessage(int index, double brightness) {
    String topic = '${comodos[index]}Luz';
    //String message = switchState ? 'on' : 'off';
    String message = "";
    if (brightness != -1) {
      message = '$brightness';
    }
    _mqttService.publishMessage(topic, message);
  }

  void _sendMqttMessage(int index, bool switchState) {
    String topic = '${comodos[index]}Luz';
    if(comodos[index] == 'Dispensa' || comodos[index] == 'Closet'){
      if(comodos[index] == 'Dispensa'){
        topic = 'CozinhaLuzDispensa';
      }else{
        topic = 'QuartoClosed';
      }
    }else{
      topic = '${comodos[index]}Luz';
    }
    String message = switchState ? '1' : '0';
    _mqttService.publishMessage(topic, message);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < minWidth ||
          constraints.maxHeight < minHeight) {
        return Center(
          child: Text(
            'Tela muito pequena para exibir o conteúdo',
            style: TextStyle(fontSize: 20),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: Color.fromARGB(255, 31, 31, 31),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                height: 65,
                color: Color.fromARGB(198, 44, 47, 53),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Color.fromARGB(255, 19, 124, 199),
                        )),
                    Text(
                      "Lampadas",
                      style: TextStyle(color: Color.fromARGB(255, 19, 124, 199), fontSize: 25),
                    ),
                    IconButton(
                      onPressed: DesativarNotificacao,
                      icon: notification
                          ? Icon(Icons.notifications_off,
                              size: 30, color: Color.fromARGB(255, 19, 124, 199))
                          : Icon(Icons.notifications,
                              size: 30, color: Color.fromARGB(255, 19, 124, 199)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: comodos.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        width: double.infinity,
                        height: 128,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(198, 44, 47, 53),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    comodos[index],
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 19, 124, 199), fontSize: 20),
                                  ),
                                  Switch(
                                    activeColor: Colors.blue,
                                    value: switchesState[index],
                                    onChanged: (bool value) {
                                      setState(() {
                                        switchesState[index] = value;
                                      });
                                      _sendMqttMessage(index, value);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Brilho",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 19, 124, 199), fontSize: 20),
                                  ),
                                  Slider(
                                    activeColor: Color.fromARGB(255, 19, 124, 199),
                                    value: luminosidade[index],
                                    onChanged: (double value) {
                                      setState(() {
                                        luminosidade[index] = value;
                                      });
                                      _sendMqttBrightnessMessage(index, value);
                                    },
                                    min: 0,
                                    max: 255,
                                    divisions: 255,
                                    label: luminosidade[index].round().toString(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String novoComodo = "";
                        return AlertDialog(
                          title: Text("Novo Cômodo"),
                          content: TextField(
                            onChanged: (value) {
                              novoComodo = value;
                            },
                            decoration: InputDecoration(
                              hintText: "Nome do cômodo",
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () {
                                adicionarComodo(novoComodo);
                                Navigator.of(context).pop();
                              },
                              child: Text("Adicionar"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text("Novo Cômodo",
                      style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 19, 124, 199),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
