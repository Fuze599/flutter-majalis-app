import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String title;
  final Function _disconnectFunction;
  final Function _getUserByNumberFunction;
  final Function _getUsersBySearchFunction;
  final Function _insertCardLineFunction;

  const HomePage(this.title, this._disconnectFunction, this._getUserByNumberFunction, this._getUsersBySearchFunction, this._insertCardLineFunction, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var pwdWidgets = <Widget>[];
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.system_update_alt,
              color: Colors.white,
            ),
            onPressed: () {
              widget._disconnectFunction();
              Navigator.pushNamed(context, '/');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Outils',
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 30),
              ),
            ),
            Center(
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.badge),
                      title: Text('Système de carte de fidélité'),
                      subtitle: Text('By François Bardijn'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('LISTE DES CLIENTS'),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return StatefulBuilder(builder: (context, setState) {
                                  return AlertDialog(
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                    content: Builder(
                                      builder: (context) {
                                        return SizedBox(
                                          height: MediaQuery.of(context).size.height - 200,
                                          width: MediaQuery.of(context).size.width - 200,
                                          child: Column(
                                            children: [
                                              const Text(
                                                "Liste des clients",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              const SizedBox(height: 30),
                                              const TextField(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Rechercher un client',
                                                ),
                                              ),
                                              ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.all(10),
                                                    color: Colors.green,
                                                    child: ExpansionPanelList(
                                                      animationDuration: const Duration(milliseconds: 2000),
                                                      children: [
                                                        ExpansionPanel(
                                                          headerBuilder: (context, isExpanded) {
                                                            return Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: const <Widget>[
                                                                ListTile(
                                                                  leading: Icon(
                                                                      Icons.account_box_rounded,
                                                                    size: 50,
                                                                  ),
                                                                  title: Text('François Bardijn'),
                                                                  subtitle: Text('Depuis le 21/05/2021'),
                                                                  trailing: Text("Dernière remise : 20€ le 21/08/2022"),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                          body:const ListTile(
                                                            title: Text('Description text',style: TextStyle(color: Colors.black)),
                                                          ),
                                                          isExpanded: _isExpanded,
                                                          canTapOnHeader: true,
                                                        ),
                                                      ],
                                                      dividerColor: Colors.grey,
                                                      expansionCallback: (panelIndex, isExpanded) {
                                                        _isExpanded = !_isExpanded;
                                                        setState(() {

                                                        });
                                                      },

                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                  });
                                });
                          },
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('AJOUTER UN ACHAT'),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return StatefulBuilder(builder: (context, setState) {
                                    return AlertDialog(
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      content: Builder(
                                        builder: (context) {
                                          return SizedBox(
                                            height: MediaQuery.of(context).size.height - 300,
                                            width: MediaQuery.of(context).size.width - 200,
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 20),
                                                const Text(
                                                  "Ajouter un achat",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                const SizedBox(height: 30),
                                                TextField(
                                                  controller: phoneNumberController,
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Numéro de téléphone',
                                                  ),
                                                ),
                                                const SizedBox(height: 30),
                                                TextField(
                                                  controller: amountController,
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Montant de l\'achat',
                                                  ),
                                                ),
                                                ...pwdWidgets,
                                                Container(
                                                    margin: const EdgeInsets.only(top: 20),
                                                    height: 50,
                                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                    child: ElevatedButton(
                                                      child: const Text('Confirmer'),
                                                      onPressed: () async {
                                                        if (phoneNumberController.value.text.isNotEmpty
                                                          && amountController.value.text.isNotEmpty) {
                                                          try {
                                                            int idClient = await widget._getUserByNumberFunction(phoneNumberController.value.text);
                                                            try {
                                                              await widget._insertCardLineFunction(idClient.toString(), amountController.value.text);
                                                              Navigator.pop(context);
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                const SnackBar(
                                                                  backgroundColor: Colors.indigo,
                                                                  content: Text('Ligne ajoutée'),
                                                                ),
                                                              );
                                                            } catch (e) {
                                                              Navigator.pop(context);
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                const SnackBar(
                                                                  backgroundColor: Colors.indigo,
                                                                  content: Text('Pb d\'insertion'),
                                                                ),
                                                              );
                                                            }
                                                          } catch (e) {
                                                            setState(() {
                                                              pwdWidgets = [
                                                                const SizedBox(height: 30),
                                                                Row(
                                                                  children: const [
                                                                    Flexible(
                                                                      child: TextField(
                                                                        decoration: InputDecoration(
                                                                          border: OutlineInputBorder(),
                                                                          labelText: 'Nom',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 30),
                                                                    Flexible(
                                                                      child: TextField(
                                                                        decoration: InputDecoration(
                                                                          border: OutlineInputBorder(),
                                                                          labelText: 'Prénom',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 30),
                                                                const TextField(
                                                                  decoration: InputDecoration(
                                                                    border: OutlineInputBorder(),
                                                                    labelText: 'Adresse email',
                                                                  ),
                                                                ),
                                                              ];
                                                            });
                                                          }
                                                        } else {
                                                          Navigator.pop(context);
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            const SnackBar(
                                                              backgroundColor: Colors.indigo,
                                                              content: Text('Veuillez remplir tous les champs'),
                                                            ),
                                                          );
                                                        }
                                                        //await widget._getUserByNumberFunction("0477316510");
                                                        // print(phoneNumberController.value.text);
                                                        // print(amountController.value.text);
                                                        // print(await widget._getUserByNumberFunction("0477316510"));
                                                      },
                                                    )),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  });
                                }).then((val) {
                              setState(() {
                                pwdWidgets = [];
                              });
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
