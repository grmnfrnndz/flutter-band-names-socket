import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:band_names_app/src/models/band.dart';


class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 2),
    Band(id: '3', name: 'Coldplay', votes: 1),
    Band(id: '4', name: 'Blur', votes: 4),
    Band(id: '5', name: 'Enigma', votes: 3),
    Band(id: '6', name: 'Pearl Jam', votes: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Center(child: Text('Bands Names', style: TextStyle(color: Colors.black),)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) => _bandTile(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
   );
  }

  Widget _bandTile(Band banda) {
    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        print('$direction');
        print('${banda.id}');

        // TODO: llamar el borrado en el server

      },
      background: Container(
        padding: EdgeInsets.only(left: 10),
        color: Colors.red,
        child: Align(
          child: Text('Eliminar Banda', style: TextStyle(color: Colors.white),), 
          alignment: Alignment.centerLeft,),

      ),

      child: ListTile(
        leading: CircleAvatar(
          child: Text(banda.name.substring(0, 2)),
          backgroundColor: Colors.blue[100]
        ),
        title: Text(banda.name),
        trailing: Text('${banda.votes}', style: TextStyle(fontSize: 20)),
        onTap: (){
          print(banda.name);
        },
      ),
    );
  }


  addNewBand() {

    // el context existe de manera global en un statefullwidget
    print('floatingbutton');

    final textEditingController = TextEditingController();

    if (Platform.isAndroid) {
      // android
      return showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: Text('Nueva Banda: '),
            content: TextField(
              controller: textEditingController,
            ),
            actions: [
              MaterialButton(
                elevation: 5,
                textColor: Colors.blue,
                child: Text('Agregar'),
                onPressed: () => addBandToList(textEditingController.text),
              ),
            ],
          );
        },
      );
    }

    showCupertinoDialog(
      context: context, 
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text('Nueva Banda: '),
          content: CupertinoTextField(
            controller: textEditingController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Agregar'),
              onPressed: () => addBandToList(textEditingController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Salir'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      }
      );
    
    
  }


  void addBandToList(String name) {
    if (name.length > 1) {
      //podemos agregar la banda 
      print('agregar');

      this.bands.add(Band(id: DateTime.now().toString(), name: name));

      setState(() {});
    }

    
    // cerrando el cuadro de dialogo
    Navigator.pop(context);

  }

}