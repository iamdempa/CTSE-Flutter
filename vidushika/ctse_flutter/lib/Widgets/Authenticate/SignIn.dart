import 'package:flutter/material.dart';
import '../../Controller/API.dart';
import '../../Model/user.dart';
import '../Admin/AdminNewsList.dart';
import '../Reporter/ReporterNewsList.dart';
import 'SignUp.dart';

class SignIn extends StatefulWidget {
      SignIn({Key key, this.title}) : super(key: key);
      final String title;
      @override
      _SignInState createState() => _SignInState();
}


class _SignInState extends State<SignIn> {
      TextStyle style = TextStyle(fontFamily: 'Arial', fontSize: 20.0);

      //Controllers are defined to assign the values of TextFormfields
      static TextEditingController emailController = TextEditingController();
      static TextEditingController passwordController = TextEditingController();
      FirestoreService api = FirestoreService();

      

      final email = TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: "Email", hintText: "user@gmail.com"
        ),
        validator: (value){
          if (value.isEmpty){
            return 'Please enter email';
          }
          return null;          
        },
      );

      final password = TextFormField(
        //key: _passKey,
		autofocus: false,
		obscureText: true,
        controller: passwordController,
        decoration: InputDecoration(
          labelText: "Password", hintText: "Enter password"
        ),
        validator: (value){
          if (value.isEmpty){
            return 'Please enter password';
          }
          return null;          
        },
      );

      final guidlinesCard = Card(
        color: Colors.red[100],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.warning, size: 10),
              title: Text('Password should have'),
              subtitle: Text('1 Upper case\n1 Lower Case\n1 Numeric number\n1 special character\nCommon Allow Character(! @ # & * ~)'),
            ),
          ],
        ),
      );

      //_formKey is used to validate the textFormfields
      final _formKey = GlobalKey<FormState>();     

      signIn() async{
        User result = await api.signIn(email.controller.text, password.controller.text);
        if(result == null){
          _showDialog();
        }else if (result.userType == "reporter"){
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReporterNewsList()),
          );
        }else if(result.userType == "admin"){
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminNewsList()),
          );
        }
      }

      void _showDialog() {
        // flutter defined function
        
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Invalid User!"),
              content: new Text("Incorrect username or password")
            );
          },
        );
      }

      signInButton() {
        return SizedBox(
          width: double.infinity,
		  child: OutlineButton(
		      color: Colors.blue,
			  child: RaisedButton(
				padding: EdgeInsets.symmetric(vertical:10.0, horizontal:152.0),
				color: Colors.green,
				child: Text("Sign In"),
				onPressed: (){
				  if (_formKey.currentState.validate()) {
					signIn();
				  }              
				}),
			), 	
          );
      }

      signUpButton() {
        return SizedBox(
          width: double.infinity,
          child: OutlineButton(
            color: Colors.blue,
			child: RaisedButton(
				padding: EdgeInsets.symmetric(vertical:10.0, horizontal:125.0),
				color: Colors.blue,
				child: Text("Create Acoount"),
				onPressed: (){			  
				  
					Navigator.push(
					context,
					MaterialPageRoute(builder: (context) => SignUp()),
					);
				                
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
			
            padding: EdgeInsets.all(10.0),
			decoration: new BoxDecoration(
				//color: Colors.blue,
				image: new DecorationImage(
					image: new AssetImage("assets/imge.jpg"),
					fit: BoxFit.fill,)
			),	
			//margin: EdgeInsets.symmetric(horizontal: 20),
            //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
				
            child: Padding(              
              padding: const EdgeInsets.all(5.0),
              child: Column( 
			    
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                   Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
						
			
                        //child:
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
								/*height: 750,
								width: double.infinity,
								decoration: new BoxDecoration(
								  gradient:LinearGradient(
									  begin: Alignment.topRight,
									  end: Alignment.bottomLeft,
									  colors: [
										Color(0xFF3383CD),
										Color(0xFF11249F),
									  ],	
								  ),
								  image: DecorationImage(
									image: AssetImage("assets/img2.jpeg"),
								  ),
								),*/
							  SizedBox(
                                height: 100,
                              ),
                              email,
                              SizedBox(
                                height: 10,
                              ),
                              password,
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              signInButton(),
                              SizedBox(
                                height: 20								
                              ),
                              signUpButton(),
                              SizedBox(
                                height: 20
                              ),
                            ],
                        ))
                      ],
                    )
                ],
              ),
            ),
          ),
        );
      }
    }