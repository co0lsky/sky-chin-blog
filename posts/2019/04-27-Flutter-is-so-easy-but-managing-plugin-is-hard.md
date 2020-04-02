==title==
Flutter is so easy, but managing plugin is hard

==author==
Sky Chin

==description==

==featureimage==
feature_post_flutter_is_easy.png

==tags==

==body==
Flutter is so easy to learn. 

Flutter is the new mobile UI framework by Google for creating high-quality native experiences on iOS and Android. Yes, it's cross-platform.

You can learn more about Flutter from [here](https://medium.com/flutter-community/in-plain-english-so-what-the-heck-is-flutter-and-why-is-it-a-big-deal-7a6dc926b34a).

There is a significant difference between Flutter and React Native, which is you are writing UI code in an object-oriented way. IMO, Flutter is easy for native mobile developer or Backend developer. React Native is easy for a Frontend developer.

Writing a Hello World app is as simple as writing classes.

~~~ dart
class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Welcome to Flutter',
            theme: ThemeData(
                primaryColor: Colors.white,
                ),
            home: Scaffold(
                appBar: AppBar(
                    title: Text('Hello World App'),
                    ),
                body: HelloWorld()
                )
            );
    }
}

class HelloWorld extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Hello World')
    );
  }
}
~~~

In Flutter, everything is a widget, which is similar to the component in React Native.

`HelloWorld` class is a `StatelessWidget` that builds a `Text` widget on the centre of the screen.

`MyApp` class renders `HelloWorld` widget on the body with Material theme.

![](/assets/images/1_T0IkXNvQETuDRz04psxVmw.png)

How about making a `ListView`?

~~~ dart
class HelloWorldList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext _context, int i) {
        return ListTile(
          title: Text('Hello World ' + i.toString()),
          trailing: Icon(Icons.android),
        );
      }
    );
  }
}
~~~

![](/assets/images/1_OuE4iae3oluZyjN3-k6qzg.png)

Simple, huh?

Flutter saves you tons of time from figuring out the right padding size and making sure the android icon sticks on the right of the list item.

So, Flutter is the best? It's too soon to say that.

I spent 6 hours making a simple countdown app that can speak. Among the 6 hours, I spent 2 on learning the Flutter and writing the code. The other 4 were spending on updating XCode and solving the plugin compatibility issue.

First of all, I don’t think updating Xcode is a major issue. Unless you are the person like me who seldom write an iOS app and have a MacBook with 128GB HDD only (always running out of space).

The second problem is the plugin compatibility. I was installing this plugin, [flutter_tts](https://pub.dartlang.org/packages/flutter_tts) to implement the text to speech feature. I faced an error during the installation.

> Unable to determine Swift version for the following pods

I’m not alone having the same problem.

![](/assets/images/1_TEjiYeWZD24Lr08Bb36-rA.png)

The problem is solved by adding a few lines in the Podfile. I hope this solution helps you too.

~~~ powershell
target 'Runner' do
  use_frameworks! # <--- add this
  system('rm -rf .symlinks')
  system('mkdir -p .symlinks/plugins')

  ...
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['SWIFT_VERSION'] = '5.0' # <--- specify SWIFT_VERSION
      if target.name == 'flutter_tts' # <--- specify SWIFT_VERSION for plugin
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
    end
  end
end
~~~

If you are a plugin user, choosing and managing plugin is hard, especially when you are excited to upgrade your app to the newest version of Swift or Android. 

If you are a plugin developer, maintaining plugin compatibility is hard, especially it is supporting Android and Swift at the same time, the effort is double. Sincerely appreciate for the plugin developers who diligently producing updates.

But, that shouldn't stop us from creating great things. Let's create a great ecosystem around Flutter. 
