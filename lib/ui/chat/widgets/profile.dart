import 'package:blq_chat/app_utils/helper/helper.dart';
import 'package:blq_chat/app_utils/styles/colors.dart';
import 'package:blq_chat/app_utils/widgets/card_button.dart';
import 'package:blq_chat/app_utils/widgets/spacing.dart';
import 'package:blq_chat/ui/chat/view_model/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  void _onSubmit() {
    if (_idController.text.isEmpty ||
        _profileUrlController.text.isEmpty ||
        _nameController.text.isEmpty) {
      return;
    } else {
      Provider.of<ChatViewModel>(context, listen: false).createUserRequest({
        'user_id': _idController.text,
        'profile_url': _profileUrlController.text,
        'nickname': _nameController.text
      });
      Navigator.of(context).pop();
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
                  onSubmitted: (_) => _onSubmit),
              Spacing.largeHeight(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CardButton(
                      onPressed: _onSubmit,
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
