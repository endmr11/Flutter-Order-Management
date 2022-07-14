import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_order_management/data/sources/api/api_service.dart';
import 'package:flutter_order_management/data/sources/database/local_database_helper.dart';
import 'package:flutter_order_management/views/components/app_bars/classic_app_bar.dart';
import 'package:flutter_order_management/views/components/buttons/classic_button.dart';
import 'package:flutter_order_management/views/components/spacer/spacer.dart';
import 'package:flutter_order_management/views/components/text_form_fields/classic_text_form_field.dart';
import 'package:flutter_order_management/views/pages/page_management/page_management.dart';
import 'package:universal_io/io.dart';

import '../../../core/global/global_blocs/main_bloc/main_bloc.dart';
import '../../widgets/dialog_managers/dialog_manager.dart';
import 'bloc/login_bloc.dart';
import 'login_view_model.dart';

class LoginView extends LoginViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  String? dropdownValue = LocaleDatabaseHelper.i.currentUserLang ?? Platform.localeName.substring(0, 2);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomActionAppBar(
        title: AppLocalizations.of(context)!.appTitle,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              LocaleDatabaseHelper.i.setCurrentUserTheme(LocaleDatabaseHelper.i.isLight != null
                  ? LocaleDatabaseHelper.i.isLight!
                      ? false
                      : true
                  : false);
              context.read<MainBloc>().add(const ThemeChangeEvent());
            },
            icon: const Icon(Icons.brightness_6),
          ),
          langDropdownButton(
            dropdownValue: dropdownValue,
            onChanged: (val) {
              setState(() {
                dropdownValue = val!;
              });
              context.read<MainBloc>().add(LanguageChangeEvent(val));
            },
            items: <String>['en', 'tr'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Flag.fromString(value == "tr" ? 'tr' : 'us', height: 20, width: 20, fit: BoxFit.fill),
              );
            }).toList(),
          ),
        ],
      ),
      body: RepositoryProvider(
        create: (context) => APIService(),
        child: BlocProvider(
          create: (context) => loginBloc ?? LoginBloc(APIService()),
          child: BlocListener<LoginBloc, LoginState>(
            bloc: loginBloc,
            listener: (context, state) {
              if (state is LoginProcessLoading) {
                showLoadingDialog();
              } else if (state is LoginProcessSuccesful) {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => const PageManagement()),
                );
              } else if (state is LoginProcessError) {
                Navigator.pop(context);
                showErrorDialog();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(loginBannerUri),
                    classicHeightSpacer(height: 20),
                    formBuilder(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DropdownButton<String> langDropdownButton({
    required String? dropdownValue,
    required void Function(String?)? onChanged,
    required List<DropdownMenuItem<String>>? items,
  }) {
    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: onChanged,
      items: items,
    );
  }

  Widget formBuilder() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          classicTextFormField(
            prefixIcon: const Icon(Icons.mail),
            controllerText: controllerEmail,
            dataText: AppLocalizations.of(context)!.email,
            context: context,
          ),
          classicHeightSpacer(height: 50),
          classicTextFormField(
            prefixIcon: const Icon(Icons.password),
            controllerText: controllerPassword,
            dataText: AppLocalizations.of(context)!.password,
            context: context,
            obscureText: showPassword ? false : true,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: Icon(
                showPassword ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
              ),
            ),
          ),
          classicHeightSpacer(height: 50),
          classicButton(
            text: AppLocalizations.of(context)!.login,
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

  void showLoadingDialog() {
    DialogManager.i.showLoadingAlertDialog(context: context);
  }

  void showErrorDialog() {
    DialogManager.i.showClassicAlertDialog(
      context: context,
      content: [const Text("Hatalı Bilgi Girdiniz")],
      title: "Hata",
      actions: [
        classicButton(
          text: "Tamam",
          customOnPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
