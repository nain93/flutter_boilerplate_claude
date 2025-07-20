import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/content.dart';

part 'content_state.freezed.dart';

@freezed
class ContentState with _$ContentState {
  const factory ContentState.initial() = ContentInitial;
  const factory ContentState.loading() = ContentLoading;
  const factory ContentState.loaded(List<Content> contents) = ContentLoaded;
  const factory ContentState.error(String message) = ContentError;
}