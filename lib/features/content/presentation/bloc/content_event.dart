import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_event.freezed.dart';

@freezed
class ContentEvent with _$ContentEvent {
  const factory ContentEvent.getContents() = GetContentsEvent;
  const factory ContentEvent.getContentById(String id) = GetContentByIdEvent;
  const factory ContentEvent.refreshContents() = RefreshContentsEvent;
}