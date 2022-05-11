part of 'file_bloc.dart';

abstract class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object> get props => [];
}

class FileGetImageEvent extends FileEvent {
  final ImageSource source;

  FileGetImageEvent(this.source);
  @override
  List<Object> get props => [source];
}

class FileGetInitialsEvent extends FileEvent {
  final String name;

  FileGetInitialsEvent(this.name);
  @override
  List<Object> get props => [name];
}

class FileUploadImageEvent extends FileEvent {
  final Uint8List image;

  FileUploadImageEvent(this.image);
  @override
  List<Object> get props => [image];
}

class FileCleanEvent extends FileEvent {}
