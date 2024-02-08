import 'package:blq_chat/app_utils/helper/helper.dart';
import 'package:blq_chat/app_utils/styles/colors.dart';
import 'package:blq_chat/app_utils/widgets/card_button.dart';
import 'package:blq_chat/app_utils/widgets/spacing.dart';
import 'package:blq_chat/ui/chat/view_model/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final _nameController = TextEditingController();
  final _profileUrlController = TextEditingController();
  final _idController = TextEditingController();
  final _userIDFocusNode = FocusNode();
  final _urlFocusNode = FocusNode();

  void _onSubmit(NavigatorState navigator, ChatViewModel model) async {
    //error checking
    if (_idController.text.isEmpty ||
        (_profileUrlController.text.isEmpty ||
            !_profileUrlController.text.startsWith('https')) ||
        _nameController.text.isEmpty) {
      toastMessage('Check the details being entered', long: true);
      return;
    } else {
      //creating user profile account in order to engage with open channel
      await SendbirdChat.connect(_idController.text);
      toastMessage('user profile created', long: false);
      //updating account
      model.updateUserRequest({
        'profile_url': _profileUrlController.text,
        'nickname': _nameController.text,
        'user_id': _idController.text
      });
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.only(
            top: 15,
            right: 15,
            left: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              sText('Create a User profile', size: 18, weight: FontWeight.bold),
              Spacing.meduimHeight(),
              TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus()),
              Spacing.smallHeight(),
              TextField(
                decoration: InputDecoration(labelText: 'Unique User ID'),
                controller: _idController,
                keyboardType: TextInputType.text,
                focusNode: _userIDFocusNode,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
              ),
              Spacing.smallHeight(),
              TextField(
                  controller: _profileUrlController,
                  decoration: InputDecoration(labelText: 'Profile Url'),
                  keyboardType: TextInputType.url,
                  focusNode: _urlFocusNode,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _onSubmit(Navigator.of(context),
                      Provider.of<ChatViewModel>(context, listen: false))),
              Spacing.largeHeight(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CardButton(
                      onPressed: () => _onSubmit(Navigator.of(context),
                          Provider.of<ChatViewModel>(context, listen: false)),
                      minWidth: 320,
                      textColor: blqWhite,
                      buttonText: 'Proceed',
                      buttonColor: blqSuccess),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
