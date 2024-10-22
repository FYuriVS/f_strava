import 'package:destrava/main.dart';
import 'package:destrava/src/pages/signin_page.dart';
import 'package:destrava/src/states/login_state.dart';
import 'package:destrava/src/stores/login_store.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final LoginStore loginStore = getIt.get<LoginStore>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController profilePictureUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ValueListenableBuilder(
        valueListenable: loginStore,
        builder: (context, value, child) {
          if (value is RegisteredLoginState) {
            loginStore.createProfile(
                value.userId.toString(),
                nameController.text,
                emailController.text,
                'https://img.freepik.com/fotos-gratis/avatar-androgino-de-pessoa-queer-nao-binaria_23-2151100270.jpg?t=st=1729558619~exp=1729562219~hmac=9555fc3025d9c3ff175d957a02160fd89a0e16764d6180bbf9b0694c6371c9cd&w=826',
                DateTime.now().toIso8601String(),
                DateTime.now().toIso8601String());
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );
            });
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Cadastro de Usuário'),
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu nome completo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Por favor, insira um email válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira uma senha';
                        } else if (value.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: dateOfBirthController,
                      decoration: const InputDecoration(
                        labelText: 'Data de Nascimento',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            dateOfBirthController.text =
                                "${pickedDate.toLocal()}".split(' ')[0];
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua data de nascimento';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: profilePictureUrlController,
                      decoration: const InputDecoration(
                        labelText: 'URL da Foto de Perfil (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.url,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Material(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: InkWell(
                onTap: () async {
                  loginStore.signUp(
                      emailController.text, passwordController.text);
                },
                splashColor: Theme.of(context)
                    .colorScheme
                    .onSecondaryContainer
                    .withOpacity(0.5), // Cor da onda
                highlightColor: Theme.of(context)
                    .colorScheme
                    .onSecondaryContainer
                    .withOpacity(0.3), // Cor de destaque ao manter pressionado
                child: SizedBox(
                  height: size.height * .07,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (value is LoadingLoginState)
                        Text(
                          "Carregando...",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                        ),
                      if (value is ErrorLoginState ||
                          value is InitialLoginState)
                        Text(
                          "Cadastrar",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
