class model{
  String _name;
  String _phone;

  model setName(String name){
    this._name = name;
    return this;
  }

  String getName(){
    return _name;
  }

  model setPhone(String phone){
    this._phone = phone;
    return this;
  }

  String getPhone(){
    return _phone;
  }
}