<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->
# Avio
## Avio is working towards making api calls as easy as possible for developers
- [Contents](#aveo)
  - [Features](#feature)
  - [TODO](#todo)
  - [Usage](#usage)
    - [Adding Auth Interceptor](#adding-auth-interceptor)
    - [Internet Connectin status and global loader](#internet-connectin-status-and-global-loader)
    - [Making network calls](#making-network-calls)
  - [Additional information](#additional-information)
    
    
  
  


## Features

### Make API calls and show connectivity status anf handle loading overlay with ease

![API call loader](rest.gif)
![Connectivity banner](connection.gif)

## TODO

✅ &ensp;Handle REST-API calls  
✅ &ensp;Optional Auth Interceptor support  
✅ &ensp;Handle GraphQL calls  
✅ &ensp;Satus widgets  
## Usage

### Initializing plugin and adding Interceptors

To use this package, First you need to initailize this Avio.init() preferably in main(). And if you need to add any Dio interceptors, you can add them like this.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Avio.init();
  AvioInterceptors.interceptors = [
    RetryInterceptor(
      dio: AvioInterceptors.dio!,
      logPrint: print, // specify log function (optional)
      retries: 3, // retry count (optional)
    )
  ];
  runApp(
    Root(),
  );
}
```

#### Adding Auth Interceptor

Best way to use this feature will be to keep these calls in a method and call that method on:
1. when you login and sign-up
2. when you launch app, check if accessToken is available in your secured Storage(or other preferd alternatives) and then call the method

```dart
AvioInterceptors.authTnterceptorMap.addAll({
      Endpoints.baseUrl: AuthInterceptorData(
        accessToken: 'ey......zp'/*Current access token*/,
        accessTokenExpireCode: /*Status code recived on failed auth access*/,
        refreshToken: 'zp......tc'/*Current refresh token*/,
        onSuccess: (success) async {
          //Here you can store updated access token and refresh token to your storage

          //Callback method must return updated [AuthInterceptorData]
          return AvioInterceptors.authTnterceptorMap['https://example.com']!
              .copyWith(
            accessToken: success['access_token'],
          );
        },
        onRefeshTokenExpire: () {},
        //Endpoint must start with '/'
        refreshTokenEndpoint: '/auth/refreshtoken',
        refreshParamName: 'refresh_token',
      )
    });

    //Finally add the [AuthInterceptor] to Interceptors 
    AvioInterceptors.dio?.interceptors.add(AuthInterceptor());
```

### Internet Connectin status and global loader

Package also provides a widget to show a loading overlay from anywhere in your code and it also shows a banner for internet connectivity.  
Here you can style your connectivity message banner and loading overlay

```dart
//recommended use of widget
MaterialApp(
      title: "Application",
      ...
      builder: (context, child) {
        return AvioWrapper(child: child!);
      },
    );
```

```dart
//To check internet status
CLStatus.instance.isConnected.value //returns bool

//To check or enable or disable loading overlay
CLStatus.instance.isLoading.value //returns bool
```

### Making network calls

```dart
//To make REST-API calls
ApiCall.instance.rest(
    params: {},
    serviceUrl: URL,
    showLoader: true,
    methodType: RestMethod.get, 
    //supported Methods [GET,POST,PUT,DLETE,PATCH]
    success: (statusCode,data) {
        print(data);
    },
    error: (statusCode, error){},
    invalidResponse: (statusCode, error) {},
);
```

```dart
//To make GraphQL calls
ApiCall.instance.rest(
    document: r'''<document>''',
    serviceUrl: URL,
    showLoader: true,
    methodType: GQLmethod.query, 
    //supported Methods [guery,mutation,stream]
    success: (statusCode,data) {
        print(data);
    },
    error: (statusCode, error){},
);
```

## Additional information

This package is developed and maintained by [AveoSoft Pvt Ltd](https://aveosoft.com/).
For any issues & improvements you can create an issue in Github Issues.
