import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/file_requests.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  FileBloc() : super(FileInitial()) {
    on<FileGetImageEvent>(_getImage);
    on<FileUploadImageEvent>(_upload);
  }

  FutureOr<void> _getImage(
      FileGetImageEvent event, Emitter<FileState> emit) async {
    try {
      Uint8List? image = await FileRequests.getImage(event.source);
      if (image != null) {
        emit(FileImageFound(image));
      } else {
        emit(FileInitial());
      }
    } catch (err) {
      emit(FileErrorState());
      emit(FileInitial());
    }
  }

  FutureOr<void> _upload(
      FileUploadImageEvent event, Emitter<FileState> emit) async {
    try {
      String? url = await FileRequests.uploadImage(event.image);
      if (url != null) {
        emit(FileUploaded(url));
      } else {
        emit(FileInitial());
      }
    } catch (err) {
      emit(FileErrorState());
      emit(FileInitial());
    }
  }
}
