// IT17157124 - This screen provides the facility to add/update the news depending on the
// scenatio that if user has selected to add a news as anew or update an existing one


// import the packages necessary 
import 'dart:io';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:snap_news_ctse_2020/banuka/model/news_model.dart';
import 'package:snap_news_ctse_2020/banuka/api/firestore_service_api.dart';
import 'package:snap_news_ctse_2020/banuka/pages/camera_screen.dart';
import 'package:snap_news_ctse_2020/banuka/pages/first_screen.dart';


// AddNews class to perform add/or update of a News 
class AddNews extends StatefulWidget {
  final String imgPath;
  News news;
  String didRetake;

  AddNews({this.imgPath, this.news, this.didRetake});

  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {

  // global key to initialize the form field 
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  
  // text editing controllers to update the state of values of different form fields 
  TextEditingController _headlineController;
  TextEditingController _descriptionController;
  String _dropDownActivity;
  FocusNode _descriptionNode;
  FocusNode _priorityNode;

  // get current date
  static var now = new DateTime.now();
  static var formatter = new DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);

  // get current timie
  dynamic currentTime = DateFormat.jm().format(DateTime.now());

  @override
  void initState() {
    super.initState();

    // initialize the controller and other global varibales using 
    String headlineTakenFromWidget;
    String descriptiontakenFromWidget;

    if (widget.news != null) {
      headlineTakenFromWidget = widget.news.headline;
      descriptiontakenFromWidget = widget.news.description;
    } else {
      headlineTakenFromWidget = "";
      descriptiontakenFromWidget = "";
    }

    _headlineController = TextEditingController(text: headlineTakenFromWidget);
    _descriptionController =
        TextEditingController(text: descriptiontakenFromWidget);
    _dropDownActivity = "";
    _descriptionNode = FocusNode();
    _priorityNode = FocusNode();
  }

  bool change = false;

  @override
  Widget build(BuildContext context) {
    File _image;
    String image_url = "";


    // get the photo taken by the camera as a FileImage 
    _getImage() {
      var img = (File(widget.imgPath));
      setState(() {
        _image = img;
      });
      return FileImage(_image);
    }


    // show a toast message as a confirmation on some events 
    Future _showToastMsg(String msgType, String msg) {
      if (msgType == "success") {
        return Fluttertoast.showToast(
          msg: msg,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
        );
      } else if (msgType == "error") {
        return Fluttertoast.showToast(
          msg: msg,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
        );
      } else {
        return Fluttertoast.showToast(
          msg: msg,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
        );
      }
    }


    // show the loading screen when an async event takes place (eg: uploading the image)
    showLoadingWhileSaving(BuildContext context) {
      AlertDialog alert = AlertDialog(
        content: new Row(
          children: [
            CircularProgressIndicator(),
            Container(
                margin: EdgeInsets.only(left: 5),
                child: Text((widget.news != null)
                    ? "Updating the news"
                    : "Adding the news")),
          ],
        ),
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }


    // upload the news to the firestore 
    Future _uploadNews(BuildContext context, String operation) async {

      // get the current timestamp 
      String timestamp_ = new DateTime.now().millisecondsSinceEpoch.toString();

      // if an addition operation 
      if (operation == "add") {
        
        String fileName = basename(_image.path);
        StorageReference storageReference =
            FirebaseStorage.instance.ref().child(fileName);

        StorageUploadTask storageUploadTask = storageReference.putFile(_image);

        showLoadingWhileSaving(context);
        StorageTaskSnapshot storageTaskSnapshot =
            await storageUploadTask.onComplete;

        image_url =
            await (await storageUploadTask.onComplete).ref.getDownloadURL();

        Navigator.pop(context);

        // add a new news
        await FireStoreServiceApi().add_news(News(
            headline: _headlineController.text.toUpperCase(),
            description: _descriptionController.text,
            imageUrl: image_url,
            timeNews: currentTime.toString(),
            timeDate: formattedDate.toString(),
            priority: _dropDownActivity.toString(),
            timestamp: timestamp_));
            
      } else if (operation == "update") { // if an updation operation 
        
        // get the value passed by the previous screen 
        if (widget.didRetake != null) {
          if (widget.didRetake.toLowerCase() == "yes") {
            String fileName = basename(_image.path);
            StorageReference storageReference =
                FirebaseStorage.instance.ref().child(fileName);

            StorageUploadTask storageUploadTask =
                storageReference.putFile(_image);

            showLoadingWhileSaving(context);
            StorageTaskSnapshot storageTaskSnapshot =
                await storageUploadTask.onComplete;

            image_url =
                await (await storageUploadTask.onComplete).ref.getDownloadURL();

            Navigator.pop(context);

            await FireStoreServiceApi().update_news(News(
                headline: _headlineController.text.toUpperCase(),
                description: _descriptionController.text,
                imageUrl: image_url,
                timeNews: currentTime.toString(),
                timeDate: formattedDate.toString(),
                priority:
                    (_dropDownActivity == null || _dropDownActivity.length == 0)
                        ? widget.news.priority
                        : _dropDownActivity.toString(),
                id: widget.news.id,
                timestamp: timestamp_));
          } else if (widget.didRetake.toLowerCase() == "no") {
            print("Error in Add news 1");
          } else {
            print("Error in Add news 2");
          }
        } else {

          // if it is a raw update, do this operatiton
          await FireStoreServiceApi().update_news(News(
            headline: _headlineController.text.toUpperCase(),
            description: _descriptionController.text,
            imageUrl: widget.news.imageUrl,
            timeNews: currentTime.toString(),
            timeDate: formattedDate.toString(),
            priority:
                (_dropDownActivity == null || _dropDownActivity.length == 0)
                    ? widget.news.priority
                    : _dropDownActivity.toString(),
            id: widget.news.id,
            timestamp: timestamp_,
          ));
        }
      } else {
        print("Erro Occured");
      }

      setState(() {
        _showToastMsg("success", "News Successfully Saved!");
      });
    }


    // show the headline TextFormatField to enter headline of the news
    Widget _showHeadlineField() {
      return TextFormField(
        textInputAction: TextInputAction.next,
        onEditingComplete: () {
          FocusScope.of(context).requestFocus(_descriptionNode);
        },
        controller: _headlineController,
        validator: (headline_) {
          if (headline_ == null || headline_.isEmpty) {
            return "Headline cannot be empty";
          }
        },
        decoration: InputDecoration(
          labelText: "Headline",
          hintText: "Covid-19 new stats",
          border: OutlineInputBorder(),
          icon: Icon(Icons.add_box),
        ),
      );
    }


    // show the description TextFormatField to enter description of the news
    Widget _showDescriptionField() {
      return TextFormField(
        focusNode: _descriptionNode,
        maxLines: 5,
        textInputAction: TextInputAction.newline,
        controller: _descriptionController,
        validator: (description) {
          if (description == null || description.isEmpty) {
            return "Description cannot be empty";
          }
        },
        decoration: InputDecoration(
          labelText: "Description",
          hintText: "Covid-19 new stats are sky-rock...",
          border: OutlineInputBorder(),
          icon: Icon(Icons.message),
        ),
      );
    }

    // show the dropdown TextFormatField to select the priority of the news
    Widget _showDropDownField() {
      return DropDownFormField(
        titleText: "Priority",
        value: (widget.news != null && change == false)
            ? widget.news.priority
            : _dropDownActivity,
        hintText: 'Select the priority',
        onSaved: (value) {
          setState(() {
            _dropDownActivity = value;
          });
        },
        onChanged: (value) {
          setState(() {
            change = true;
            _dropDownActivity = value;
          });
        },
        validator: (value) {
          if (value == null || value == "") {
            return "Please select a priority";
          }
        },
        dataSource: [
          {
            "display": "High",
            "value": "High",
          },
          {
            "display": "Medium",
            "value": "Medium",
          },
          {
            "display": "Low",
            "value": "Low",
          },
        ],
        textField: 'display',
        valueField: 'value',
      );
    }

    // get the current date and time to store
    Widget _showDateAndTime() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              GFButtonBadge(
                size: GFSize.SMALL,
                color: Colors.green,
                onPressed: () {
                  _showToastMsg("other", "Today is : ${formattedDate}");
                },
                icon: Icon(
                  Icons.calendar_today,
                  size: 16.0,
                  color: Colors.white,
                ),
                text: '',
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                "- ${formattedDate}",
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              GFButtonBadge(
                size: GFSize.SMALL,
                color: Colors.green,
                onPressed: () {
                  _showToastMsg("other", "Time is : ${currentTime}");
                },
                icon: Icon(
                  Icons.alarm,
                  size: 16.0,
                  color: Colors.white,
                ),
                text: '',
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                "- ${currentTime}",
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          SizedBox(
            height: 14.0,
          ),
        ],
      );
    }


    // show the note when clicked on either on date or time badge
    Widget _showTheNote() {
      return Align(
        alignment: Alignment.center,
        child: Text(
          "Date and time will be saved automaticallt on \"Save\"",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      );
    }


    // show the save/or update button
    Widget _showSaveButton() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton.icon(
            icon: Icon(Icons.cancel),
            color: Colors.red,
            textColor: Colors.white,
            label: Text("Cancel"),
            onPressed: () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => FirstScreen()));
            },
          ),
          RaisedButton.icon(
            icon: Icon(
                (widget.news != null) ? Icons.cloud_upload : Icons.add_a_photo),
            color: (widget.news != null) ? Colors.orange : Colors.green,
            textColor: Colors.white,
            label: Text((widget.news != null) ? "Update" : "Snap"),
            onPressed: () async {
              try {
                // first upload the photo
                if (_key.currentState.validate()) {
                  if (widget.news != null) {
                    await _uploadNews(context, "update");
                  } else {
                    await _uploadNews(context, "add");
                  }

                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => FirstScreen()));
                }
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      );
    }


    // show the image thumbnai, the photo user took
    Widget _showImageThumbnail(News news) {
      return Column(
        children: <Widget>[
          Align(
              alignment: Alignment.center,
              child: GFImageOverlay(
                border: Border.all(color: Colors.blueGrey, width: 4.0),
                height: 200,
                width: 200,
                color: Colors.red,
                shape: BoxShape.circle,
                boxFit: BoxFit.fill,
                image: (widget.imgPath != null)
                    ? _getImage()
                    : (widget.news.imageUrl != null)
                        ? NetworkImage(widget.news.imageUrl)
                        : AssetImage("images/default_news_image.png"),
              )),
          SizedBox(
            height: 20.0,
          ),
          RaisedButton.icon(
            icon: Icon(Icons.photo_filter),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.orange)),
            color: Colors.orange,
            textColor: Colors.white,
            label: Text("Retake"),
            onPressed: () async {
              if (widget.news != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CameraScreen(
                              news: widget.news,
                              didRetake: "yes",
                            )));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CameraScreen(
                              news: widget.news,
                              didRetake: "no",
                            )));
              }
            },
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          (widget.news != null)
              ? "Update - " + widget.news.headline
              : "Report a News",
        ),
        backgroundColor: (widget.news != null) ? Colors.orange : Colors.green,
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(26.0),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                // call the function to show the image
                _showImageThumbnail(widget.news),
                SizedBox(
                  height: 30.0,
                ),

                // call the function to show the headline
                _showHeadlineField(),
                SizedBox(
                  height: 16.0,
                ),
                // call the function to show the description
                _showDescriptionField(),
                SizedBox(
                  height: 16.0,
                ),
                // call the function to show the dropdown field
                _showDropDownField(),
                SizedBox(
                  height: 16.0,
                ),
                // call the function to show the date and time
                _showDateAndTime(),

                // call the function to show the toast
                _showTheNote(),
                SizedBox(
                  height: 20.0,
                ),

                // call the function to show the save/update buttons
                _showSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
