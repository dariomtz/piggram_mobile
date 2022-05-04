part of 'file_bloc.dart';

abstract class FileState extends Equatable {
  const FileState();

  @override
  List<Object> get props => [];
}

class FileInitial extends FileState {}

class FileUploading extends FileState {}

class FileUploaded extends FileState {
  final String url;

  FileUploaded(this.url);
  @override
  List<Object> get props => [url];
}

class FileImageFound extends FileState {
  final Uint8List image;

  FileImageFound(this.image);
  @override
  List<Object> get props => [image];
}

class FileErrorState extends FileState {}
