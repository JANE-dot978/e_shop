import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/my_validators.dart';
import '../../widgets/app_name_text_widget.dart';
import '../../widgets/titles_text_widget.dart';
import '../../widgets/subtitle_text_widget.dart';
import '../../widgets/loadding_managing.dart';
import 'register_screen.dart';
import 'package:e_shop/root_sreen.dart';

class LoginScreen extends StatefulWidget {
  static const routName = "/LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = true;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    // Focus Nodes
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _emailController.dispose();
      _passwordController.dispose();
      // Focus Nodes
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _loginFct(BuildContext context) async {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final errorMessage = await userProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
        return;
      }

      // Navigate based on role
      final user = userProvider.getUser;
      if (user != null) {
        Navigator.pushReplacementNamed(context, RootScreen.routName);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoadngManager(
          isLoading: _isLoading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const AppNameTextWidget(fontSize: 30),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: TitlesTextWidget(label: "Welcome back!"),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Email address",
                            prefixIcon: Icon(Icons.email),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(
                              context,
                            ).requestFocus(_passwordFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.emailValidator(value);
                          },
                        ),
                        const SizedBox(height: 16.0),

                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "*****",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          onFieldSubmitted: (value) async {
                            await _loginFct(context);
                          },
                          validator: (value) {
                            return MyValidators.passwordValidator(value);
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password
                            },
                            child: SubtitleTextWidget(
                              label: "Forgot password?",
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12.0),
                              // backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            icon: const Icon(Icons.login),
                            label: const Text("Login"),
                            onPressed: () async {
                              await _loginFct(context);
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SubtitleTextWidget(
                          label: "Or connect using".toUpperCase(),
                          fontWeight: FontWeight.normal,
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: kBottomNavigationBarHeight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(12.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  child: const Text("Guest?"),
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                      context,
                                      RootScreen.routName,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: SubtitleTextWidget(
                                  label: "Don't have an account?",
                                  fontWeight: FontWeight.normal,
                                ),
                              ),

                              SizedBox(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      RegisterScreen.routName,
                                    );
                                  },
                                  child: SizedBox(
                                    child: SubtitleTextWidget(
                                      label: "Create One?",
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}