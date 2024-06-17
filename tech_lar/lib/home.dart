import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tech_lar/janela.dart';
import 'package:tech_lar/lampada.dart';
import 'package:tech_lar/porta.dart';
import 'package:tech_lar/addComodo.dart';

const double minWidth = 320;
const double minHeight = 320;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool notification = false;
  void DesativarNotificacao() {
    setState(() {
      notification = !notification;
    });
  }

  bool _janela = false;
  bool _lampada = false;
  bool _porta = false;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => addComodo()),
        );
      }
    });
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
          key: _scaffoldKey,
          drawer: Drawer(
            backgroundColor: Color.fromARGB(255, 31, 31, 31),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  width: double.infinity,
                  height: 100,
                  color: Color.fromARGB(198, 44, 47, 53),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Olá, Fulano!',
                          style: TextStyle(
                            color: Color.fromARGB(255, 19, 124, 199),
                            fontSize: 25,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Color.fromARGB(255, 19, 124, 199),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Perfil',
                    style: TextStyle(color: Color.fromARGB(255, 19, 124, 199)),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    'Configurações',
                    style: TextStyle(color: Color.fromARGB(255, 19, 124, 199)),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    'Ajuda',
                    style: TextStyle(color: Color.fromARGB(255, 19, 124, 199)),
                  ),
                  onTap: () {},
                )
              ],
            ),
          ),
          body: Center(
            child: ListView(children: [
              Container(
                width: double.infinity,
                height: 65,
                color: Color.fromARGB(198, 44, 47, 53),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        icon: Icon(
                          Icons.menu,
                          size: 30,
                          color: Color.fromARGB(255, 19, 124, 199),
                        )),
                    Text(
                      "TechLar",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color.fromARGB(255, 19, 124, 199)),
                    ),
                    IconButton(
                      onPressed: DesativarNotificacao,
                      icon: notification
                          ? Icon(Icons.notifications_off,
                              size: 30,
                              color: Color.fromARGB(255, 19, 124, 199))
                          : Icon(Icons.notifications,
                              size: 30,
                              color: Color.fromARGB(255, 19, 124, 199)),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(45, 100, 45, 0),
                    child: ExpansionTile(
                      collapsedShape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      collapsedBackgroundColor: Color.fromARGB(198, 44, 47, 53),
                      backgroundColor: Color.fromARGB(199, 16, 17, 19),
                      collapsedIconColor: Color.fromARGB(255, 19, 124, 199),
                      iconColor: Color.fromARGB(255, 19, 124, 199),
                      title: Text("Controle Geral",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color.fromARGB(255, 19, 124, 199),
                              fontSize: 20)),
                      children: [
                        //Janelas
                        SwitchListTile(
                          title: Text("Janelas",
                              style: TextStyle(
                                color: Color.fromARGB(255, 19, 124, 199),
                              )),
                          activeColor: Colors.blue,
                          value: _janela,
                          onChanged: (bool value) {
                            setState(() {
                              _janela = value;
                            });
                          },
                        ),
                        Divider(
                          thickness: 1,
                          color: Color.fromARGB(255, 19, 124, 199),
                        ),
                        //Lampadas
                        SwitchListTile(
                          title: Text("Luzes",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 19, 124, 199))),
                          activeColor: Colors.blue,
                          value: _lampada,
                          onChanged: (bool value) {
                            setState(() {
                              _lampada = value;
                            });
                          },
                        ),
                        Divider(
                          thickness: 1,
                          color: Color.fromARGB(255, 19, 124, 199),
                        ),
                        //Portas
                        SwitchListTile(
                          title: Text("Portas",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 19, 124, 199))),
                          activeColor: Colors.blue,
                          value: _porta,
                          onChanged: (bool value) {
                            setState(() {
                              _porta = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 85),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              color: Color.fromARGB(198, 44, 47, 53),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Janela()),
                                );
                              },
                              icon: Icon(
                                Icons.window_outlined,
                                size: 45,
                                color: Color.fromARGB(255, 19, 124, 199),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70),
                                color: Color.fromARGB(198, 44, 47, 53),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Lampada()),
                                  );
                                },
                                icon: Icon(
                                    size: 45,
                                    color: Color.fromARGB(255, 19, 124, 199),
                                    Icons.lightbulb_outline),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70),
                                color: Color.fromARGB(198, 44, 47, 53),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Porta()),
                                  );
                                },
                                icon: Icon(
                                    size: 45,
                                    color: Color.fromARGB(255, 19, 124, 199),
                                    Icons.door_back_door_outlined),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color.fromARGB(198, 44, 47, 53),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon:
                    Icon(Icons.home, color: Color.fromARGB(255, 19, 124, 199)),
                label: 'Menu',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add, color: Color.fromARGB(255, 19, 124, 199)),
                label: 'Adicionar Cômodo',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color.fromARGB(255, 19, 124, 199),
            onTap: _onItemTapped,
          ),
        );
      }
    });
  }
}
