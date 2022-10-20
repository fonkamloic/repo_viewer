import 'dart:io';

import 'package:flutter/material.dart';
import 'package:repo_viewer/auth/infrastructure/github_authenticator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthorizationPage extends StatefulWidget {
  final Uri authorizationUrl;
  final void Function(Uri redirectUrl) onAuthorizationCodeRedirectAttempt;
  AuthorizationPage(
      {Key? key,
      required this.authorizationUrl,
      required this.onAuthorizationCodeRedirectAttempt})
      : super(key: key);

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: widget.authorizationUrl.toString(),
        onWebViewCreated: (controller) {
          controller.clearCache();
          CookieManager().clearCookies();
        },
        navigationDelegate: (navigation) {
          if (navigation.url
              .startsWith(GithubAuthenticator.redirectUrl.toString())) {
            final uri = Uri.parse(navigation.url);
            widget.onAuthorizationCodeRedirectAttempt(uri);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      )),
    );
  }
}
