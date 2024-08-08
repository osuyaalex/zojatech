
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zojatech_assignment/auth%20page/sign_in_page.dart';
import 'package:zojatech_assignment/auth%20page/widgets/sign_in_textfields.dart';
import 'package:zojatech_assignment/class/auth_service.dart';
import 'package:zojatech_assignment/main_pages/home_page.dart';
import 'package:zojatech_assignment/necessary%20widgets/spacing.dart';
import 'package:zojatech_assignment/necessary%20widgets/text_widget.dart';

import '../necessary widgets/elevated_button.dart';
import '../utilities/snackbar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName= TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  late FocusNode _firstNameFocus;
  late FocusNode _lastNameFocus;
  late FocusNode _emailFocus;
  late FocusNode _passwordFocus;
  late Color _firstNameColor;
  late Color _lastNameColor;
  late Color _emailColor;
  late Color _passwordColor;
  bool _isLoading = false;
  bool _obscureText = true;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  _firstNameFocusNode(){
    _firstNameFocus = FocusNode();
    _firstNameColor = Colors.grey.shade200;
    _firstNameFocus.addListener((){
      setState(() {
        _firstNameColor = _firstNameFocus.hasFocus
            ? Color(0xffD397F8).withOpacity(0.3)
            : Colors.grey.shade200;
      });
    });
  }
  _lastNameFocusNode(){
    _lastNameFocus = FocusNode();
    _lastNameColor = Colors.grey.shade200;
    _lastNameFocus.addListener((){
      setState(() {
        _lastNameColor = _lastNameFocus.hasFocus
            ? Color(0xffD397F8).withOpacity(0.3)
            : Colors.grey.shade200;
      });
    });
  }
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
  _passwordFocusNode(){
    _passwordFocus = FocusNode();
    _passwordColor = Colors.grey.shade200;
    _passwordFocus.addListener((){
      setState(() {
        _passwordColor = _passwordFocus.hasFocus
            ? Color(0xffD397F8).withOpacity(0.3)
            : Colors.grey.shade200;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _firstNameFocusNode();
    _lastNameFocusNode();
    _emailFocusNode();
    _passwordFocusNode();

  }

  @override
  void dispose() {
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Space(
                  height: MediaQuery.of(context).size.width*0.23,
                ),
                const TextWidget(
                    text: 'Welcome!',
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
                const Space(height: 30,),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: const TextWidget(
                    text: 'Please provide following'
                      'details for your new account',
                      textAlign: TextAlign.center,
                      fontSize: 14.5,
                    height: 2,

                  ),
                ),
                Space(
                  height: MediaQuery.of(context).size.width*0.17,
                ),
                SignInTextFields(
                    focusNode: _firstNameFocus,
                    textEditingController: _firstName,
                    obscureText: false,
                    fillColor: _firstNameColor,
                    suffixIconPresent: false,
                    hintText: 'First Name'
                ),
                const Space(height: 5,),
                SignInTextFields(
                    focusNode: _lastNameFocus,
                    textEditingController: _lastName,
                    obscureText: false,
                    fillColor: _lastNameColor,
                    suffixIconPresent: false,
                    hintText: 'Last Name'
                ),
                const Space(height: 5,),
                SignInTextFields(
                    focusNode: _emailFocus,
                    textEditingController:_email,
                    obscureText: false,
                    fillColor: _emailColor,
                    suffixIconPresent: false,
                    hintText: 'Email'
                ),
                const Space(height: 5,),
                SignInTextFields(
                    focusNode: _passwordFocus,
                    textEditingController:_password,
                    obscureText: _obscureText,
                    onPressed: (){
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    fillColor: _passwordColor,
                    suffixIconPresent: true,
                    hintText: 'Password'
                ),


                const Space(height: 40,),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Button(
                      buttonColor: Color(0xffD397F8),
                      text: 'Sign up my Account',
                      onPressed: ()async{
                        if(_key.currentState!.validate()){

                            setState(() {
                              _isLoading = true;
                            });
                             _authService.registerUsers(
                                _firstName.text,
                                _lastName.text,
                                _email.text,
                                _password.text,
                              context
                            ).then((v){
                              setState(() {
                                _isLoading = false;
                              });
                              if(v == 'Account created successfully'){
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return const HomePage();
                                })) ;
                              }else{
                                snack(context, v!);
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
                ),

                const Space(height: 15,),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Already have an account? -  ',
                      style: const TextStyle(
                          height: 1.5,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          fontSize: 13
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Sign in',
                            style: const TextStyle(
                              color: Color(0xffD397F8),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return const SignInPage();
                              }));
                              }
                        ),
                      ]
                  ),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
