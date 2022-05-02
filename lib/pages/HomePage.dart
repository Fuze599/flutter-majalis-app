import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:majalis_app/datas/NotificationModule.dart';
import '../domain/Client.dart';

class HomePage extends StatefulWidget {
  final String title;
  final Function _disconnectFunction;
  final Function _getUserByNumberFunction;
  final Function _getUsersBySearchFunction;
  final Function _insertCardLineFunction;
  final Function _insertClientFunction;
  final Function _getLastPromotionFunction;

  const HomePage(this.title, this._disconnectFunction, this._getUserByNumberFunction, this._getUsersBySearchFunction, this._insertCardLineFunction, this._insertClientFunction, this._getLastPromotionFunction, {Key? key}) : super(key: key);

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
    TextEditingController firstnameController = TextEditingController();
    TextEditingController lastnameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    String searchText = "";

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
                                                TextField(
                                                  onChanged: (String text) {
                                                    setState(() {
                                                      searchText = text;
                                                    });
                                                  },
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Rechercher un client',
                                                  ),
                                                ),
                                                FutureBuilder<List<Client>>(
                                                  future: widget._getUsersBySearchFunction(searchText),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      return ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: snapshot.data!.length,
                                                        itemBuilder: (context, index) {
                                                          return Container(
                                                            margin: const EdgeInsets.all(10),
                                                            color: Colors.green,
                                                            child: ExpansionPanelList(
                                                              animationDuration: const Duration(milliseconds: 500),
                                                              children: [
                                                                ExpansionPanel(
                                                                  headerBuilder: (context, isExpanded) {
                                                                    String firstname = snapshot.data![index].firstname;
                                                                    String lastname = snapshot.data![index].lastname;
                                                                    String dateCreation = snapshot.data![index].dateCreation;
                                                                    int idClient = snapshot.data![index].idClient;
                                                                    return FutureBuilder<String>(
                                                                        future: widget._getLastPromotionFunction(idClient),
                                                                        builder: (context, snapshot) {
                                                                          if (snapshot.hasData) {
                                                                            return Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: <Widget>[
                                                                                ListTile(
                                                                                  leading: const Icon(
                                                                                    Icons.account_box_rounded,
                                                                                    size: 50,
                                                                                  ),
                                                                                  title: Text(firstname + " " + lastname),
                                                                                  subtitle: Text('Depuis le ' + DateFormat('dd/MM/yyyy').format(DateTime.parse(dateCreation))),
                                                                                  trailing: Text("Dernière remise : " + snapshot.data! + "€"),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          }
                                                                          return Column(children: const [
                                                                            SizedBox(height: 20),
                                                                            CircularProgressIndicator(),
                                                                          ]);
                                                                        });
                                                                  },
                                                                  body: const ListTile(
                                                                    title: Text('En construction', style: TextStyle(color: Colors.black)),
                                                                  ),
                                                                  isExpanded: _isExpanded,
                                                                  canTapOnHeader: true,
                                                                ),
                                                              ],
                                                              dividerColor: Colors.grey,
                                                              expansionCallback: (panelIndex, isExpanded) {
                                                                _isExpanded = !_isExpanded;
                                                                setState(() {});
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    } else if (snapshot.hasError) {
                                                      return Text('${snapshot.error}');
                                                    }
                                                    return Column(children: const [
                                                      SizedBox(height: 20),
                                                      CircularProgressIndicator(),
                                                    ]);
                                                  },
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
                                                  keyboardType: TextInputType.phone,
                                                  controller: phoneNumberController,
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Numéro de téléphone',
                                                  ),
                                                ),
                                                const SizedBox(height: 30),
                                                TextField(
                                                  keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
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
                                                        if (phoneNumberController.value.text.isNotEmpty && amountController.value.text.isNotEmpty) {
                                                          if (pwdWidgets.isNotEmpty) {
                                                            if (lastnameController.value.text.isNotEmpty && firstnameController.value.text.isNotEmpty && emailController.value.text.isNotEmpty) {
                                                              bool isUserInserted = await widget._insertClientFunction(emailController.value.text, lastnameController.value.text, firstnameController.value.text, phoneNumberController.value.text);

                                                              if (!isUserInserted) {
                                                                Navigator.pop(context);
                                                                NotificationModule.getNotification(context, 'L\'utilisateur n\'a pas été inséré');
                                                                return;
                                                              }
                                                            } else {
                                                              Navigator.pop(context);
                                                              NotificationModule.getNotification(context, 'Veuillez remplir tous les champs');
                                                              return;
                                                            }
                                                          }
                                                          try {
                                                            int idClient = await widget._getUserByNumberFunction(phoneNumberController.value.text);
                                                            try {
                                                              String nbLine = await widget._insertCardLineFunction(idClient.toString(), amountController.value.text);
                                                              Navigator.pop(context);
                                                              String text;
                                                              if (nbLine == "12") {
                                                                String lastPromotion = await widget._getLastPromotionFunction(idClient);
                                                                text = "Le client à droit à une notification de " + lastPromotion + "€";
                                                              } else {
                                                                text = nbLine + " lignes sur la carte de fidélité.";
                                                              }
                                                              NotificationModule.getNotification(context, text);
                                                              return;
                                                            } catch (e) {
                                                              Navigator.pop(context);
                                                              NotificationModule.getNotification(context, 'Problème d\'insertion de la ligne');
                                                              return;
                                                            }
                                                          } catch (e) {
                                                            setState(() {
                                                              pwdWidgets = [
                                                                const SizedBox(height: 30),
                                                                Row(
                                                                  children: [
                                                                    Flexible(
                                                                      child: TextField(
                                                                        keyboardType: TextInputType.name,
                                                                        controller: lastnameController,
                                                                        decoration: const InputDecoration(
                                                                          border: OutlineInputBorder(),
                                                                          labelText: 'Nom',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(width: 30),
                                                                    Flexible(
                                                                      child: TextField(
                                                                        keyboardType: TextInputType.name,
                                                                        controller: firstnameController,
                                                                        decoration: const InputDecoration(
                                                                          border: OutlineInputBorder(),
                                                                          labelText: 'Prénom',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 30),
                                                                TextField(
                                                                  keyboardType: TextInputType.emailAddress,
                                                                  controller: emailController,
                                                                  decoration: const InputDecoration(
                                                                    border: OutlineInputBorder(),
                                                                    labelText: 'Adresse email',
                                                                  ),
                                                                ),
                                                              ];
                                                            });
                                                          }
                                                        } else {
                                                          Navigator.pop(context);
                                                          NotificationModule.getNotification(context, 'Veuillez remplir tous les champs');
                                                          return;
                                                        }
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
