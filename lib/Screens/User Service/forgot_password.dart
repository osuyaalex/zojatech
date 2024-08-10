
import 'package:flutter/material.dart';
import 'package:zojatech_assignment/Screens/User%20Service/widgets/sign_in_textfields.dart';
import 'package:zojatech_assignment/Services/auth_service.dart';
import 'package:zojatech_assignment/necessary%20widgets/spacing.dart';
import 'package:zojatech_assignment/necessary%20widgets/text_widget.dart';
import 'package:zojatech_assignment/utilities/snackbar.dart';

import '../../necessary widgets/elevated_button.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _email = TextEditingController();
  late FocusNode _emailFocus;
  late Color _emailColor;
  bool _isLoading = false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final AuthService _authService = AuthService();



  _emailFocusNode(){
    _emailFocus = FocusNode();
    _emailColor = Colors.grey.shade200;
    _emailFocus.addListener((){
      setState(() {
        _emailColor = _emailFocus.hasFocus
            ? Color(0xffD397F8).withOpacity(0.3)
            : Colors.grey.shade200;
      });
    });
  }


  @override
  void initState() {
    super.initState();
    _emailFocusNode();

  }

  @override
  void dispose() {
    _emailFocus.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              Space(
                height: MediaQuery.of(context).size.width*0.23,
              ),
              const TextWidget(
                text: 'Forgot Password',
                fontSize: 30,
                fontWeight: FontWeight.w600,

              ),
              const Space(height: 25,),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.5,
                child: const TextWidget(
                  text: 'Enter your Email',
                  textAlign: TextAlign.center,
                  fontSize: 14.5,
                  height: 2,

                ),
              ),
              Space(
                height: MediaQuery.of(context).size.width*0.27,
              ),
              SignInTextFields(
                focusNode:_emailFocus,
                textEditingController: _email,
                obscureText: false,
                fillColor:  _emailColor,
                suffixIconPresent: false,
                hintText: 'Email',
              ),


              const Space(height: 65,),
              Button(
                  buttonColor: const Color(0xffD397F8),
                  text: 'Sign in my Account',
                  onPressed: ()async{
                    if(_key.currentState!.validate()){
                      setState(() {
                        _isLoading = true;
                      });
                      _authService.forgotPassword(email: _email.text).then((v){
                        if(v! == "Password reset sent to your email"){
                          setState(() {
                            _isLoading = false;
                          });
                          snack(context, "Password reset sent to your email");
                        }else{
                          snack(context, v);
                        }
                      });
                    }
                    },
                  textColor: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width*0.14,
                  minSize: false,
                  textOrIndicator: _isLoading
              ),
            ],
          ),
        ),
      ),
    );
  }
}
