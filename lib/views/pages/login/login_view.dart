import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: MyAppBar(title: title),
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocListener<LoginBloc, LoginState>(
          bloc: loginBloc,
          listener: (context, state) {
            if (state is LoginProcessLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('LoginProcessLoading')),
              );
            } else if (state is LoginProcessSuccesful) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('LoginProcessSuccesful')),
              );
            } else if (state is LoginProcessError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('LoginProcessError')),
              );
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
          MyTextFormField(controllerText: controllerEmail, dataText: emailText),
          const MySpacer(height: 50),
          MyTextFormField(controllerText: controllerPassword, dataText: passwordText),
          const MySpacer(height: 50),
          myFormButton(),
        ],
      ),
    );
  }

  Widget myFormButton() {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          fetchUser(controllerEmail.text, controllerPassword.text);
          controllerEmail.clear();
          controllerPassword.clear();
        }
      },
      child: Text(buttonText),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(50);
  const MyAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          icon: const Icon(Icons.brightness_6),
        ),
      ],
    );
  }
}

class MySpacer extends StatelessWidget {
  const MySpacer({
    required this.height,
    Key? key,
  }) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    Key? key,
    required this.controllerText,
    required this.dataText,
  }) : super(key: key);

  final TextEditingController controllerText;
  final String dataText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      controller: controllerText,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: dataText,
      ),
    );
  }
}
