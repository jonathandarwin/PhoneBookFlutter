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
            // INPUT PHONE
            Container(
              padding: EdgeInsets.only(bottom: 15.0),
              child: TextFieldPhone(),
            ),
            // BUTTON SAVE
            Container(
              padding: EdgeInsets.only(bottom: 15.0),
              child: ButtonSave(listViewPhone.state),
            ),
            // TITLE PHONE BOOK            
            Container(
              padding: EdgeInsets.only(bottom: 15.0),              
              child: Align(
                alignment: Alignment.centerLeft,
                child: TitlePhoneBook(),
              ),              
            ),
            // LIST PHONE BOOK
            Expanded(
              child: Container(
                child: listViewPhone,
              ),
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
  static FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context){
    return TextField(      
      focusNode: focusNode,
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

        TextFieldNameState.nameController.clear();
        TextFieldPhoneState.phoneController.clear();

        FocusScope.of(context).requestFocus(TextFieldNameState.focusNode);
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

class TitlePhoneBook extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Text(
      "Phone Book",
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20.0
      ),
    );
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
      print('Mounted');
      setState(() {
        
      }); 
    }    
    else{
      print('Not Mounted');
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
        return ListTile(
          title: Padding(          
            padding: EdgeInsets.only(top: 10.0, bottom:10.0, right: 20.0, left: 20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(Main.listModel[i].getName()),
                ),
                Expanded(                
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(Main.listModel[i].getPhone()),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => deleteDialog(context, i),
                      child: Icon(Icons.delete, color: Colors.red,),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void deleteDialog(BuildContext context, int i){
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Delete"),
        content: Text("Are you sure want to delete '" + Main.listModel[i].getName() + "'?" ),
        actions: <Widget>[
          FlatButton(
            child: Text("Yes"),
            onPressed: (){  
              Navigator.pop(context);            
              deleteData(i);
              updateState();              
              Scaffold.of(context)
                .showSnackBar(
                  SnackBar(
                    content: Text("Delete Success"),
                  )
                );
            },
          ),
          FlatButton(
            child: Text("No"),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void deleteData(int i){
    Main.listModel.removeAt(i);
  }
}