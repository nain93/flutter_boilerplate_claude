import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_content_by_id.dart';
import '../../domain/usecases/get_contents.dart';
import 'content_event.dart';
import 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final GetContents getContents;
  final GetContentById getContentById;

  ContentBloc({
    required this.getContents,
    required this.getContentById,
  }) : super(const ContentState.initial()) {
    on<GetContentsEvent>(_onGetContents);
    on<GetContentByIdEvent>(_onGetContentById);
    on<RefreshContentsEvent>(_onRefreshContents);
  }

  Future<void> _onGetContents(
    GetContentsEvent event,
    Emitter<ContentState> emit,
  ) async {
    emit(const ContentState.loading());
    
    final result = await getContents(NoParams());
    
    result.fold(
      (failure) => emit(ContentState.error(failure.toString())),
      (contents) => emit(ContentState.loaded(contents)),
    );
  }

  Future<void> _onGetContentById(
    GetContentByIdEvent event,
    Emitter<ContentState> emit,
  ) async {
    emit(const ContentState.loading());
    
    final result = await getContentById(event.id);
    
    result.fold(
      (failure) => emit(ContentState.error(failure.toString())),
      (content) => emit(ContentState.loaded([content])),
    );
  }

  Future<void> _onRefreshContents(
    RefreshContentsEvent event,
    Emitter<ContentState> emit,
  ) async {
    final result = await getContents(NoParams());
    
    result.fold(
      (failure) => emit(ContentState.error(failure.toString())),
      (contents) => emit(ContentState.loaded(contents)),
    );
  }
}