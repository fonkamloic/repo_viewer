import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:repo_viewer/auth/shared/providers.dart';
import 'package:repo_viewer/core/presentation/routes/app_router.gr.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.github,
                    size: 150,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Welcome to\nRepo Viewer',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(authNotifierProvider.notifier).signIn(
                        (authorizationUrl) {
                          final completer = Completer<Uri>();
                          context.router.push(AuthorizationRoute(
                              authorizationUrl: authorizationUrl,
                              onAuthorizationCodeRedirectAttempt:
                                  (redirectedUrl) {
                                completer.complete(redirectedUrl);
                              }));
                          return completer.future;
                        },
                      );
                    },
                    child: Text('Sign In'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
