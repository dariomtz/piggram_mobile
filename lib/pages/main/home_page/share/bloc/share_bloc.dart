import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:piggram_mobile/data/post.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  ShareBloc() : super(ShareInitial()) {
    on<ShareSendEvent>(_onSend);
  }

  FutureOr<void> _onSend(ShareSendEvent event, Emitter<ShareState> emit) async {
    //get image
    final image = await event.controller.capture();
    if (image == null) {
      return;
    }
    //save image
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await File('${directory.path}/image.png').create();
    await imagePath.writeAsBytes(image);

    //share image
    Share.shareFiles([imagePath.path],
        text:
            'See want is happening in piggram:\n${event.post.user!.username}: ${event.post.description}');
  }
}
