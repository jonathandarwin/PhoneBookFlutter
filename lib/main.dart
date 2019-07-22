import 'package:flutter/material.dart';
import 'package:phone_book/model.dart';

void main() => runApp(Main());

class Main extends StatelessWidget{

  static List<model> listModel = new List();

  @override
  Widget build(BuildContext context){            
    return MaterialApp(
      title: "Phone Book",
      home: RootLayout(),
    );
  }
}

class RootLayout extends StatelessWidget{

  final ListViewPhone listViewPhone = ListViewPhone();  

  @override
  Widget build(BuildContext context){    
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Phone Book"),        
      ),      
      body: Padding(
       padding: EdgeInsets.all(15.0), 
       child: Column(
        children: <Widget>[
            // INPUT NAME
            Container(              
              padding: EdgeInsets.only(bottom: 15.0),
              child: TextFieldName(),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 15.0),
              child: TextFieldPhone(),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 15.0),
              child: ButtonSave(listViewPhone.state),
            ),
            Container(
              child: listViewPhone,
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldName extends StatefulWidget{
  @override
  TextFieldNameState createState() => TextFieldNameState();
}

class TextFieldNameState extends State<TextFieldName>{
  static final nameController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return TextField(      
      controller: nameController,      
      decoration: InputDecoration(
        labelText: "Name"    
      ),
    );
  }
}

class TextFieldPhone extends StatefulWidget{
  @override
  TextFieldPhoneState createState() => TextFieldPhoneState();
}

class TextFieldPhoneState extends State<TextFieldPhone>{

  static final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return TextField(      
      keyboardType: TextInputType.number,
      controller: phoneController,
      decoration: InputDecoration(     
        labelText: "Phone Number"    
      ),
    );
  }
}

class ButtonSave extends StatelessWidget{    

  final ListViewPhoneState state;

  ButtonSave(this.state);

  @override
  Widget build(BuildContext context){
    return RaisedButton(
      onPressed: () => onButtonSaveClick(context, TextFieldNameState.nameController.text, TextFieldPhoneState.phoneController.text),
      child: Text("Save"),
    );
  }

  void onButtonSaveClick(BuildContext context, String name, String phone){
    if(name == "" || phone == ""){
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Please input all the field"),
          duration: Duration(seconds: 1),
        )
      );
    }
    else{            
      bool isValid = true;
      for (int i=0; i<Main.listModel.length; i++){
        model element = Main.listModel[i];
        if(element.getName() == name && element.getPhone() == phone){
          isValid = false;
          break;
        }
      }

      if(isValid){
        Main.listModel.add(model()
          .setName(name)
          .setPhone(phone));    
        state.updateState();    

        TextFieldNameState.nameController.text = '';
        TextFieldPhoneState.phoneController.text = '';
      }
      else{
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Data already exists!"),
            duration: Duration(seconds: 1),
          )
        );
      }         
    }
  }
}

class ListViewPhone extends StatefulWidget{

  final ListViewPhoneState state = ListViewPhoneState();

  @override
  ListViewPhoneState createState() => state;   
}

class ListViewPhoneState extends State<ListViewPhone>{  

  void updateState(){
    if(mounted){     
      setState(() {
        
      }); 
    }    
  }

  @override
  Widget build(BuildContext context){
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      separatorBuilder: (context, i) => Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Divider(
          color: Colors.grey,
        ),        
      ),
      itemCount: Main.listModel.length,
      itemBuilder: (context, i){        
        return Padding(
          padding: EdgeInsets.only(top: 10.0, bottom:10.0, right: 20.0, left: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(Main.listModel[i].getName()),
              ),
              Expanded(                
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(Main.listModel[i].getPhone()),
                )
              )
            ],
          ),
        );
      },
    );
  }
}