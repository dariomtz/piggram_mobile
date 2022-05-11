import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/components/like/bloc/mode_bloc.dart';

class LikeIcon extends StatelessWidget {
  final bool liked;
  const LikeIcon({Key? key, required this.liked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModeBloc, ModeState>(
      builder: (context, state) {
        if (state is ModeLoading) {
          return CircularProgressIndicator();
        }
        if (state is ModeLoaded) {
          return Image.asset(
            "assets/${state.mode}${liked ? "" : "_border"}.png",
            height: 25,
            width: 25,
          );
        }
        return Container();
      },
    );
  }
}
