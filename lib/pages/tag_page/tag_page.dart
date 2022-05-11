import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/components/picture_miniature_list.dart';
import 'package:piggram_mobile/pages/tag_page/bloc/tag_page_bloc.dart';

class TagPage extends StatelessWidget {
  final String tag;
  const TagPage({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("#$tag"),
      ),
      body: BlocBuilder<TagPageBloc, TagPageState>(builder: (context, state) {
        if (state is TagPageLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is TagPageLoaded) {
          return PictureMiniatureList(posts: state.posts);
        }
        return Center(
          child: Text("Something went wrong, try it again"),
        );
      }),
    );
  }
}
