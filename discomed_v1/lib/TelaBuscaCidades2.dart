import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'CidadesModel.dart';
import 'ConexaoBd.dart';

/*

class Index2 extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index2> {


  List<String> countList = [
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Nine",
    "Ten",
    "Santa Cruz do Herval",
    "Tweleve",
    "Thirteen",
    "Fourteen",
    "Fifteen",
    "Sixteen",
    "Seventeen",
    "Eighteen",
    "Nineteen",
    "Twenty"
  ];
  List<String> selectedCountList = [];

  Cidades _selectedItem;
  Conexao db = new Conexao();
  bool _show = true;
  List<String> items = new List();

  @override
  void initState() {
    super.initState();
    db.getAllCidades().then((notes) {
      setState(() {
        notes.forEach((note) {
          items.add(Cidades.fromMap(note).toString());
        });
      });
    });
  }


  void _openFilterList() async {
    var list = await FilterList.showFilterList(
      context,
      allTextList: countList,
      height: 450,
      borderRadius: 20,
      headlineText: "Select Cidades",
      searchFieldHintText: "Search Here",
      selectedTextList: selectedCountList,
    );

    if (list != null) {
      setState(() {
        selectedCountList = List.from(list);
      });
    }
  }


  //----------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Filter List"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openFilterList,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
        /// check for empty or null value selctedCountList
        body: selectedCountList == null || selectedCountList.length == 0
            ? Center(
          child: Text('No text selected'),
        )
            : ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(selectedCountList[index]),
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: selectedCountList.length));
  }
}
*/
