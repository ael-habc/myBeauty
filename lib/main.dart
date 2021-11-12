import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlook/smartlook.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mybeautyadvisor/app_localizations.dart';

import 'package:mybeautyadvisor/providers/language.dart';
import 'package:mybeautyadvisor/providers/theme.dart';
import 'package:mybeautyadvisor/providers/auth.dart';
import 'package:mybeautyadvisor/providers/user.dart';

import 'package:mybeautyadvisor/screens/splash/splashScreen.dart';
import 'package:mybeautyadvisor/screens/home/HomeScreen.dart';

import 'package:mybeautyadvisor/tools/sharedPreference.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';

import 'package:mybeautyadvisor/requests/refreshToken.dart';

import 'constants/consts.dart';
import 'tools/sharedPreference.dart';
import 'routes.dart';







void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: MyApp(),
    )
  );
}



class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    SetupOptions    options = (
      SetupOptionsBuilder(keySmartlookAPI)
    ).build();
    Smartlook.setupAndStartRecording(options);
  }



  @override
  Widget build(BuildContext context) {
    final         theme = Provider.of<ThemeProvider>(context);
    final         language = Provider.of<LanguageProvider>(context);

    // Get Data from shared references
    Future<Map<String, dynamic>>    getUserData() async {
      //= Sleep
      await Future.delayed(Duration(seconds: kSplashSleep));
  
      SharedPreferences         space = await SharedPreferences.getInstance();
      Map<String, dynamic>      data = {};
    
      data['user'] =          await UserPreferences().getUser();
      data['theme'] =         space.getString('theme');
      data['language_code'] = space.getString('language_code');

      //* Refresh token
      if (data['user'] != null && data['user'].token != null)
        refreshToken(data['user']).then(
          (newToken) async {
            if (newToken != null) {
              //// Set new token in the cache
              await UserPreferences().setToken(newToken);
              //// Set the newe token in data
              data['user'].token = newToken;
            }
            else {
              //// Remove the user in the cache
              //await UserPreferences().removeUser();
              //// Delete the data
              data['user'] = {};
            }
          }
        );

      return data;
    }


    // List all of the app's supported locales here
    List<Locale>
    _supportedLocales = [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
    ];

    // These delegates make sure the localization data for the proper language
    List<LocalizationsDelegate<dynamic>>
    _localizationsDelegates = [
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate
    ];

    // Returns a locale which will be used in the app
    Locale
    _localeResolution(Locale locale, Iterable<Locale> supportedLocales) {
      for (var supportedLocale in supportedLocales)
      {
        if (supportedLocale.languageCode == locale.languageCode)
          return supportedLocale;
      }
      return supportedLocales.first;
    }


    return MaterialApp(
          title: 'My beauty Advisor',
          debugShowCheckedModeBanner: false,
          locale: language.appLocale,
          supportedLocales: _supportedLocales,
          localizationsDelegates: _localizationsDelegates,
          localeResolutionCallback: _localeResolution,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: theme.mode,
          home: FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
          
              // Init Size Screen
              SizeConfig().init(context);

              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                   return SplashScreen();
                default:
                  if (snapshot.hasError)
                    return Center(
                      child: Text("Error: $snapshot.error"),
                    );

                  if (snapshot.hasData && snapshot.data != null) {
                    // Set user local auth
                    if (
                        snapshot.data['user'] != null &&
                        snapshot.data['user'].email != null
                      ) {
                      //* Print user informations
                      print('id      : ${snapshot.data['user'].id}');
                      print('name    : ${snapshot.data['user'].name}');
                      print('email   : ${snapshot.data['user'].email}');
                      print('token   : ${snapshot.data['user'].token}');
                      //* Set  the new user
                      Provider.of<UserProvider>(context).initUser(snapshot.data['user']);
                      //* Set login status
                      Provider.of<AuthProvider>(context).setLoggedIn();
                    }
                  }

                  return HomeScreen();
                  
              }
            },
          ),
          initialRoute: '/',
          routes: routes,
        );
  }
}