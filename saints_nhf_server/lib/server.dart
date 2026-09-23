import 'dart:io';

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

import 'src/cache_busting.dart';
import 'src/email/verification_emails.dart';
import 'src/generated/serverpod.dart';
import 'src/books/seed_books.dart';
import 'src/questions/seed_questions.dart';
import 'src/saints/seed_saints.dart';
import 'src/web/routes/app_config_route.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod. The generated Serverpod class is already connected
  // with your project's generated code.
  final pod = Serverpod(args);

  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.
  // Google sign-in is enabled when `googleClientSecret` is present in
  // config/passwords.yaml (see ROADMAP.md, "Ingreso con Google").
  final googleEnabled = pod.getPassword('googleClientSecret') != null;

  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server.
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      if (googleEnabled) GoogleIdpConfigFromPasswords(),
      // Email/password sign-in. The verification codes go out through an SMTP
      // relay configured with the `smtp*` passwords; without them the codes are
      // logged instead, which is how development works. See
      // `src/email/verification_emails.dart`.
      appEmailIdpConfig(appDisplayName: 'Santos NHF'),
    ],
  );

  // Serve all files in the web/static relative directory under /web.
  // These are used by the default web page.
  pod.webServer.addRoute(
    StaticRoute.withCacheBusting(cacheBustingConfig),
    cacheBustingConfig.mountPrefix,
  );

  // OAuth callback used by Google sign-in on the web.
  pod.webServer.addRoute(FlutterWebAuth2CallbackRoute(), '/auth/callback');

  // Setup the app config route.
  // We build this configuration based on the servers api url and serve it to
  // the flutter app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/assets/assets/config.json',
  );

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    // Serve the flutter web app under /.
    pod.webServer.addRoute(
      FlutterRoute(
        appDir,
        // If building the Flutter app with WASM, set the below parameter to
        // true and add the --wasm flag to the flutter build command.
        enableWasmHeaders: false,
      ),
      '/',
    );
  } else {
    // If the flutter web app has not been built, serve the build app page.
    final defaultRoute = StaticRoute.file(
      File(
        Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
      ),
    );

    pod.webServer.addMiddleware(
      FallbackMiddleware(
        fallback: defaultRoute,
        on: (response) => response.statusCode == 404,
      ).call,
      '/',
    );

    pod.webServer.addRoute(
      defaultRoute,
      '/**',
    );
  }

  // Configure cloud storage.
  // This setup works with Serverpod Cloud without extra configuration.
  // If you want to use a custom provider for cloud storage, replace these
  // with your preferred provider.
  pod.addCloudStorage(
    await ServerpodCloudProvider.private(
      fallback: () => DatabaseCloudStorage('private'),
    ),
  );
  pod.addCloudStorage(
    await ServerpodCloudProvider.public(
      fallback: () => DatabaseCloudStorage('public'),
    ),
  );

  // Start the server.
  await pod.start();

  // In development, fill the catalog with example saints so the app can be
  // tried without loading real data first.
  if (pod.runMode == ServerpodRunMode.development) {
    final session = await pod.createSession();
    try {
      await seedSaintsIfEmpty(session);
      await backfillExampleYears(session);
      await seedQuestionsIfEmpty(session);
      await seedBooksIfEmpty(session);
    } finally {
      await session.close();
    }
  }
}
