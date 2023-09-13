import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

// Events
abstract class PostEvent {}

class CreatePostEvent extends PostEvent {
  final Map<String, dynamic> postData;

  CreatePostEvent(this.postData);
}

// States
abstract class PostState {}

class PostInitialState extends PostState {}

class PostLoadingState extends PostState {}

class PostSuccessState extends PostState {
  final String message;

  PostSuccessState(this.message);
}

class PostErrorState extends PostState {
  final String error;

  PostErrorState(this.error);
}

// BLoC
class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitialState());

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is CreatePostEvent) {
      yield PostLoadingState();

      try {
        final response = await http.post(
          Uri.parse('YOUR_API_ENDPOINT_HERE'),
          body: jsonEncode(event.postData),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 201) {
          yield PostSuccessState('Post created successfully');
        } else {
          yield PostErrorState('Failed to create post');
        }
      } catch (e) {
        yield PostErrorState('Failed to create post: $e');
      }
    }
  }
}
