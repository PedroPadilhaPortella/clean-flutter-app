import 'package:clean_flutter_app/ui/components/error_message.dart';
import 'package:clean_flutter_app/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/components.dart';
import 'components/components.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? presenter;

  LoginPage({required this.presenter});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter?.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          widget.presenter?.mainErrorStream.listen((error) {
            showErrorMessage(context, error);
          });

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LoginHeader(),
                HeadLine1(text: 'Login'),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Provider(
                    create: (_) => widget.presenter,
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          EmailInput(),
                          PasswordInput(),
                          LoginButton(),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: TextButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.person),
                                label: Text('Criar Conta')),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
