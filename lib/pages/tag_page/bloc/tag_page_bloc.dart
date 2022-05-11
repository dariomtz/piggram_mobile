import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:piggram_mobile/data/post.dart';
import 'package:piggram_mobile/utils/post_requests.dart';

part 'tag_page_event.dart';
part 'tag_page_state.dart';

class TagPageBloc extends Bloc<TagPageEvent, TagPageState> {
  TagPageBloc() : super(TagPageInitial()) {
    on<TagPageLoadEvent>(_load);
  }

  Future<void> _load(TagPageLoadEvent event, emit) async {
    emit(TagPageLoading());
    try {
      List<PostData> posts = await PostRequests.getPostByTag(event.tag);
      emit(TagPageLoaded(posts: posts));
    } catch (e) {
      print(e);
      emit(TagPageError());
    }
  }
}
