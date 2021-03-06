import 'package:flutter/material.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';

import '../../../components/custom_suffix_icon.dart';
import '../../../components/default_button.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  const SignForm({Key? key}) : super(key: key);

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  List<String> errors = [];
  final _formKey = GlobalKey<FormState>();
    String? email;
   String? password;
  bool? remember = true;

  void addError(String err) {
    if (!errors.contains(err)) {
      setState(() {
        errors.add(err);
      });
    }
  }

  void removeError(String err) {
    if (errors.contains(err)) {
      setState(() {
        errors.remove(err);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(
            height: getProportionateScreenHeight(30),
          ),
          buildPasswordFormField(),
          SizedBox(
            height: getProportionateScreenHeight(30),
          ),
          Row(
            children: [
              Checkbox(value: remember, onChanged: (value){
                setState(() {
                  remember = value;
                });
              },
              activeColor: kPrimaryColor,),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.popAndPushNamed(context, ForgotPasswordScreen.routeName);
                },
                child: Text("Forgot Password",style: TextStyle(decoration: TextDecoration.underline),)),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(20),),
          FormError(
            errors: errors,
          ),
          SizedBox(height: getProportionateScreenHeight(20),),
          
          DefaultButton(
              press: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  //if correct credential, go to login success screen
                  Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                }
              },
              text: "Continue"),
          
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
          label: Text("Password"),
          hintText: "Enter your password",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: customSuffixIcon(
            svgIcon: "assets/icons/Lock.svg",
          )),
      validator: (value) {
        if (value!.isEmpty) {
          addError(kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(kShortPassError);
          return "";
        }
        return null;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(kPassNullError);
        } else if (value.length >= 8) {
          removeError(kShortPassError);
        }
        return null;
      },
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          label: Text("Email"),
          hintText: "Enter your email",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: customSuffixIcon(
            svgIcon: "assets/icons/Mail.svg",
          )),
      validator: (value) {
        if (value!.isEmpty) {
          addError(kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(kInvalidEmailError);
          return "";
        }
        return null;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(kEmailNullError);
          return null;

         
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(kInvalidEmailError);
          return null;
        }
        return null;
      },
      onSaved: (newValue) => email = newValue,
    );
  }
 
}
