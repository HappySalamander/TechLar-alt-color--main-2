import 'package:flutter/material.dart';
import '_mqtt.dart';

const double minWidth = 320;
const double minHeight = 320;

class Porta extends StatefulWidget {
  @override
  State<Porta> createState() => _PortaState();
}

class _PortaState extends State<Porta> {
  bool notification = false;
  void DesativarNotificacao() {
    setState(() {
      notification = !notification;
    });
  }

  bool _on = false;
  List<bool> switchesState = [false, false, false];
  List<String> comodos = [
    "Garagem",
    "Sala",
    "Cozinha",
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

  void adicionarComodo(String nomeComodo) {
    setState(() {
      comodos.add(nomeComodo);
      switchesState.add(false);
    });
  }

  void _sendMqttMessageToAll(bool value) {
    for (int i = 0; i < comodos.length; i++) {
      _sendMqttMessage(i, value);
    }
  }

  void _sendMqttMessage(int index, bool switchState) {
    String topic = '${comodos[index]}Portao';
    if(comodos[index] == 'Garagem' || comodos[index] == 'Cozinha'){
      if(comodos[index] == 'Garagem' ){
        topic = 'GaragemPortao';
      }else if(comodos[index] == 'Cozinha'){
        topic = 'CozinhaPortaFundo';
      }
    }else{
      topic = '${comodos[index]}Porta';
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
                      "Portas",
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
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(198, 44, 47, 53),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Todas as Portas",
                          style: TextStyle(color: Color.fromARGB(255, 19, 124, 199), fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 33),
                        child: Switch(
                          activeColor: Colors.blue,
                          value: _on,
                          onChanged: (bool value) {
                            setState(() {
                              _on = value;
                              switchesState = List<bool>.filled(comodos.length, value);
                            });
                            _sendMqttMessageToAll(value);
                          },
                        ),
                      ),
                    ],
                  ),
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
                        height: 85,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(198, 44, 47, 53),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                          child: ListTile(
                            title: Text(
                              comodos[index],
                              style:
                                  TextStyle(color: Color.fromARGB(255, 19, 124, 199), fontSize: 20),
                            ),
                            trailing: Switch(
                              activeColor: Colors.blue,
                              value: switchesState[index],
                              onChanged: (bool value) {
                                setState(() {
                                  switchesState[index] = value;
                                });
                                _sendMqttMessage(index, value);
                              },
                            ),
                          ),
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
                    backgroundColor: MaterialStatePropertyAll(
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
