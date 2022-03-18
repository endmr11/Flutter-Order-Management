import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_order_management/core/utils/widget/dialog_managers/dialog_manager.dart';
import 'package:flutter_order_management/views/components/app_bars/classic_app_bar.dart';
import 'package:flutter_order_management/views/components/buttons/classic_button.dart';
import 'package:flutter_order_management/views/components/spacer/spacer.dart';
import 'package:flutter_order_management/views/components/text_form_fields/classic_text_form_field.dart';
import 'package:flutter_order_management/views/themes/cubit/theme_cubit.dart';

import 'bloc/login_bloc.dart';
import 'login_view_model.dart';

class LoginView extends LoginViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomActionAppBar(
        title: title,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            icon: const Icon(Icons.brightness_6),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocListener<LoginBloc, LoginState>(
          bloc: loginBloc,
          listener: (context, state) {
            if (state is LoginProcessLoading) {
              DialogManager.i.showSnacBar(context: context, text: 'LoginProcessLoading');
            } else if (state is LoginProcessSuccesful) {
              DialogManager.i.showSnacBar(context: context, text: 'LoginProcessSuccesful');
            } else if (state is LoginProcessError) {
              DialogManager.i.showSnacBar(context: context, text: 'LoginProcessError');
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: formBuilder(),
            ),
          ),
        ),
      ),
    );
  }

  Widget formBuilder() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          classicTextFormField(controllerText: controllerEmail, dataText: emailText),
          classicSpacer(height: 50),
          classicTextFormField(controllerText: controllerPassword, dataText: passwordText),
          classicSpacer(height: 50),
          classicButton(
            text: buttonText,
            customOnPressed: () {
              if (formKey.currentState!.validate()) {
                login(controllerEmail.text, controllerPassword.text);
                controllerEmail.clear();
                controllerPassword.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
