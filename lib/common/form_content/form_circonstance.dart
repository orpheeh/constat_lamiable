import 'package:constat_lamiable/common/form_repository.dart';
import 'package:flutter/material.dart';

class FormCirconstance extends StatefulWidget {

  final FormRepository formRepository;

  const FormCirconstance({Key key, @required this.formRepository}) : super(key: key);

  @override
  _FormCirconstanceState createState() => _FormCirconstanceState();
}

class _FormCirconstanceState extends State<FormCirconstance> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 64.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Cochez toute les cases qui correspondent à la situation dans laquelle l'accident a eu lieu",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold
                ),),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: List.generate(widget.formRepository.circonstances.length+1, (index){
                  if(index == widget.formRepository.circonstances.length){
                    return RaisedButton(
                      onPressed: (){},
                      child: Text("J'ai fini"),
                    );
                  }
                  return ListTile(title: Text(widget.formRepository.circonstances[index].description),
                  leading: Checkbox( 
                    value: widget.formRepository.circonstances[index].isSelected,
                    onChanged: (value){
                    setState(() {
                     widget.formRepository.circonstances[index].isSelected = value; 
                    });
                  },),);
                })
              ),
            ),
          )
        ],
      ),
    );
  }
}
