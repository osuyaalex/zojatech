
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zojatech_assignment/User%20Service/signup_page.dart';
import 'package:zojatech_assignment/User%20Service/widgets/sign_in_textfields.dart';
import 'package:zojatech_assignment/class/auth_service.dart';
import 'package:zojatech_assignment/necessary%20widgets/spacing.dart';

import '../Product Service/home_page.dart';
import '../necessary widgets/elevated_button.dart';
import '../necessary widgets/text_widget.dart';
import 'forgot_password.dart';
import '../utilities/snackbar.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController? _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  late FocusNode _emailFocus;
  late FocusNode _passwordFocus;
  late Color _emailColor;
  late Color _passwordColor;
  bool _isLoading = false;
  bool _obscureText = true;
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
    _emailFocusNode();
    _passwordFocusNode();
  }

  @override
  void dispose() {
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
                SizedBox(
                  height: MediaQuery.of(context).size.width*0.23,
                ),
                const TextWidget(
                  text: 'Welcome Back!',
                  fontSize: 30,
                  fontWeight:  FontWeight.w600,
                ),
                const Space(height: 25),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: const TextWidget(
                    text: 'Sign in to continue',
                    textAlign: TextAlign.center,
                    fontSize: 14.5,
                    height: 2,
                  ),
                ),
                Space(height: MediaQuery.of(context).size.width*0.17),
                SignInTextFields(
                    focusNode:_emailFocus,
                    textEditingController: _email!,
                    obscureText: false,
                    fillColor:  _emailColor,
                    suffixIconPresent: false,
                  hintText: 'Email',
                ),
                const Space(height: 5,),
                SignInTextFields(
                    focusNode:_passwordFocus,
                    textEditingController: _password,
                    obscureText: _obscureText,
                    onPressed: (){
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    fillColor:  _passwordColor,
                    suffixIconPresent: true,
                  hintText: 'Password',
                ),
                const Space(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return const ForgotPassword();
                          }));
                        },
                        child: const TextWidget(text: 'Forgot Password')
                    )
                  ],
                ),
                const Space(height: 40,),
                Button(
                    buttonColor: const Color(0xffD397F8),
                    text: 'Sign in my Account',
                    onPressed: ()async{
                      if(_key.currentState!.validate()){
                          setState(() {
                            _isLoading = true;
                          });
                          _authService.loginUsers(
                              _email!.text, _password.text
                          ).then((v){
                            if(v! == 'login Successful'){
                              setState(() {
                                _isLoading = false;
                              });
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                return const HomePage();
                              }));
                            }else{
                              setState(() {
                                _isLoading = false;
                              });
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
                const Space(height: 15,),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Don\'t have an account?? -  ',
                      style: const TextStyle(
                          height: 1.5,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          fontSize: 13
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Sign Up',
                            style: const TextStyle(
                              color: Color(0xffD397F8),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = (){
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return const SignupPage();
                                }));
                              }
                        ),
                      ]
                  ),

                ),
                const Space(height: 45,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
