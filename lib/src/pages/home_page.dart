import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:provider/provider.dart';

import 'package:band_names_app/src/services/socket_service.dart';
import 'package:band_names_app/src/models/band.dart';



class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    // Band(id: '1', name: 'Metallica', votes: 5),
    // Band(id: '2', name: 'Queen', votes: 2),
    // Band(id: '3', name: 'Coldplay', votes: 1),
    // Band(id: '4', name: 'Blur', votes: 4),
    // Band(id: '5', name: 'Enigma', votes: 3),
    // Band(id: '6', name: 'Pearl Jam', votes: 2),
  ];

  @override
  void initState() {
    // TODO: implement initState

    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    print(payload);
      this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();
      setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose

    // limpiando la escucha del evento
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Center(child: Text('Bands Names', style: TextStyle(color: Colors.black),)),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online ) ?
            Icon(Icons.check_circle, color: Colors.blue[300]): 
            Icon(Icons.offline_bolt, color: Colors.red[300]),
          )
        ]
      ),
      body: Column(
        children: [

          _showGraph(),

          Expanded(
            child: ListView.builder(
                  itemCount: bands.length,
                  itemBuilder: (BuildContext context, int index) => _bandTile(bands[index], index),
                ),
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
   );
  }


  Widget _showGraph() {

    Map<String, double> dataMap = new Map();
    // dataMap.putIfAbsent('Flutter', () => 2);

    bands.forEach((banda) {
      dataMap.putIfAbsent(banda.name, () => banda.votes.toDouble());
    });


    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(dataMap: dataMap, chartType: ChartType.ring,),
    );

  }


  Widget _bandTile(Band banda, int index) {

    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.socket.emit('delete-band', {'id': banda.id}),
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
        onTap: () => socketService.socket.emit('vote-band', {'id': banda.id}),
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
        builder: (context) => AlertDialog(
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
        )
      );
    }

    showCupertinoDialog(
      context: context, 
      builder: (_) => CupertinoAlertDialog(
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
      ),
    );
    
    
  }


  void addBandToList(String name) {
    if (name.length > 1) {
      //podemos agregar la banda 
      // print('agregar');
      final socketService = Provider.of<SocketService>(context, listen: false);

      // this.bands.add(Band(id: DateTime.now().toString(), name: name));
      socketService.socket.emit('add-band', {'nombre': name});
    }
    // cerrando el cuadro de dialogo
    Navigator.pop(context);
  }

}