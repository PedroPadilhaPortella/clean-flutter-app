import 'package:clean_flutter_app/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter? presenter;

  LoginPage({required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter?.isLoadingStream?.listen((isLoading) {
            if (isLoading) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return SimpleDialog(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text('Aguarde...', textAlign: TextAlign.center),
                          ],
                        )
                      ],
                    );
                  });
            } else {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            }
          });

          presenter?.mainErrorStream?.listen((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error, textAlign: TextAlign.center),
                backgroundColor: Colors.red[900],
              ),
            );
          });

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LoginHeader(),
                HeadLine1(text: 'Login'),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        StreamBuilder<String>(
                            stream: presenter?.emailErrorStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  icon: Icon(
                                    Icons.email,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                  errorText: snapshot.data?.isEmpty == true
                                      ? null
                                      : snapshot.data,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: presenter?.validateEmail,
                              );
                            }),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 32),
                          child: StreamBuilder<String>(
                              stream: presenter?.passwordErrorStream,
                              builder: (context, snapshot) {
                                return TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Senha',
                                    icon: Icon(
                                      Icons.lock,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                    errorText: snapshot.data?.isEmpty == true
                                        ? null
                                        : snapshot.data,
                                  ),
                                  obscureText: true,
                                  onChanged: presenter?.validatePassword,
                                );
                              }),
                        ),
                        StreamBuilder<bool>(
                            stream: presenter?.isFormValidStream,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                onPressed: snapshot.data == true
                                    ? presenter?.auth
                                    : null,
                                child: Text('Entrar'.toUpperCase()),
                              );
                            }),
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
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
