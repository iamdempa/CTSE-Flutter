import 'package:flutter/material.dart';
import '../../Controller/API.dart';
import '../../Model/user.dart';
import 'SignIn.dart';

class SignUp extends StatefulWidget {
      SignUp({Key key, this.title}) : super(key: key);
      final String title;
      @override
      _SignUpState createState() => _SignUpState();
}


class _SignUpState extends State<SignUp> {
      TextStyle style = TextStyle(fontFamily: 'Arial', fontSize: 20.0);

      //Controllers are defined to assign the values of TextFormfields
      static TextEditingController fullNameController = TextEditingController();
      static TextEditingController emailController = TextEditingController();
      static TextEditingController passwordController = TextEditingController();
      static TextEditingController confirmPasswordController = TextEditingController();
      FirestoreService api = FirestoreService();

      final fullName = TextFormField(
        controller: fullNameController,
        decoration: InputDecoration(
          labelText: "Full Name", hintText: "Enter full name"
        ),
        validator: (value){
          if (value.isEmpty){
            return 'Please enter full name';
          }
          return null;
        },
      );

      final email = TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: "Email", hintText: "user@gmail.com"
        ),
        validator: validateEmailAddress,
      );

      static String validateEmailAddress(String value) {
        Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(value))
          return 'Please enter valid email';
        else
          return null;
      }

      final password = TextFormField(
        //key: _passKey,
        autofocus: false,
		obscureText: true,
		controller: passwordController,
        decoration: InputDecoration(
          labelText: "Password", hintText: "Enter password"
        ),
        validator: validatePassword,
      );

      static String validatePassword(String value) {
        Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(value))
          return 'Please follow password guidlines';
        else
          return null;
      }

      final guidlinesCard = Card(
        color: Colors.blue[100],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.warning, size: 10),
              title: Text('Password should have'),
              subtitle: Text('1 Upper case\n1 Lower Case\n1 special character\n1 Numeric number\nCommon Allow Character(! @ # & * ~)'),
            ),
          ],
        ),
      );

      final confirmPassword = TextFormField(
	    autofocus: false,
		obscureText: true,
        controller: confirmPasswordController,
        decoration: InputDecoration(
          labelText: "Confirm Password", hintText: "Confirm password"
        ),
        validator: (value){
          if (value != passwordController.text){
            return 'Passwords does not match';
          }
          return null;          
        },
      );

      //_formKey is used to validate the textFormfields
      final _formKey = GlobalKey<FormState>();     

      signUp() async{
        User newUser = User(fullName: fullName.controller.text, email: email.controller.text, password: password.controller.text, userType:"reporter");
        
        String result = await api.signUp(newUser);
        if (result == "EXISTS"){
          _showDialog();
        }
      }

      void _showDialog() {
        // flutter defined function
        
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Already Exists!"),
              content: new Text("This email already has an Account.\nPlease Re-enter a new email."),
              
            );
          },
        );
      }

      button() {
        return SizedBox(
          width: double.infinity,
          child: OutlineButton(
            color: Colors.green,
			child: RaisedButton(
				padding: EdgeInsets.symmetric(vertical:10.0, horizontal:145.0),
				color: Colors.blue,
				child: Text("Sign Up"),
				onPressed: (){			  
				  if (_formKey.currentState.validate()) {
					Navigator.push(
					context,
					MaterialPageRoute(builder: (context) => SignIn()),
					);
				  }              
				}
			 ),
           ),
          );
      }
	  
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("News Reporter App"),
          ),
          body: Container(
			decoration: new BoxDecoration(
				image: new DecorationImage(
					image: new AssetImage("assets/imge.jpg"),
					fit: BoxFit.fill,)
			),
            padding: EdgeInsets.all(10.0),
            child: Padding(              
              padding: const EdgeInsets.all(5.0),
              child: Column(                
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                   Flexible(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      //children: <Widget>[
                        child:
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              fullName,
                              SizedBox(
                                height: 10,
                              ),
                              email,
                              SizedBox(
                                height: 10,
                              ),
                              password,
                              SizedBox(
                                height: 10,
                              ),
                              guidlinesCard,
                              SizedBox(
                                height: 10,
                              ),
                              confirmPassword,
                              SizedBox(
                                height: 40,
                              ),
                              button(),
                              SizedBox(
                                height: 20
                              ),
                            ],
                          ))
                        //],
                    )
                ],
              ),
            ),
          ),
        );
      }
    }