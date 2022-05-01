import 'package:flutter/material.dart';

class FormAddPurchase extends StatefulWidget {
  bool isNew = false;
  Widget widgetNew = Container();

  FormAddPurchase({Key? key}) : super(key: key);

  @override
  State<FormAddPurchase> createState() => _FormAddPurchaseState();
}

class _FormAddPurchaseState extends State<FormAddPurchase> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          "Ajouter un achat",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(height: 30),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Numéro de téléphone',
          ),
        ),
        SizedBox(height: 30),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Montant de l\'achat',
          ),
        ),
        widget.widgetNew,
        Container(
            margin: const EdgeInsets.only(top: 20),
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              child: const Text('Confirmer'),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.indigo,
                    content: Text('Objet ajouté'),
                  ),
                );
              },
            )
        ),
      ],
    );
  }
}
