import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/post_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BLoC Post Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => PostBloc(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final postBloc = BlocProvider.of<PostBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('BLoC Post Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Post Data',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final postData = {'data': _controller.text};
                postBloc.add(CreatePostEvent(postData));
              },
              child: Text('Create Post'),
            ),
            BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is PostLoadingState) {
                  return CircularProgressIndicator();
                } else if (state is PostSuccessState) {
                  return Text(state.message);
                } else if (state is PostErrorState) {
                  return Text(state.error);
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
