import 'package:flutter/material.dart';
import 'package:tech_lar/home.dart';

const double minWidth = 350;
const double minHeight = 350;

class addComodo extends StatefulWidget {
  @override
  State<addComodo> createState() => _addComodo();
}

class _addComodo extends State<addComodo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool notification = false;
  void DesativarNotificacao() {
    setState(() {
      notification = !notification;
    });
  }

  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      title: 'Home Page',
                    )));
      }
    });
  }

  List<String> comodos = [
    "Quarto",
    "Sala",
    "Cozinha",
    "Banheiro",
    "Garagem",
    "Corredor"
  ];

  void adicionarComodo(String novoComodo) {
    setState(() {
      comodos.add(novoComodo);
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
              Expanded(
                child: ListView.builder(
                  itemCount: comodos.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(198, 44, 47, 53),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    comodos[index],
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 19, 124, 199), fontSize: 20),
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
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color.fromARGB(198, 44, 47, 53),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home,  color: Color.fromARGB(255, 19, 124, 199)),
                label: 'Menu',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add,  color: Color.fromARGB(255, 19, 124, 199)),
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
