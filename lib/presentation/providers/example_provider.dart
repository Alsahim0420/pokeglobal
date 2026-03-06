import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pokeglobal/data/repositories/example_repository_impl.dart';
import 'package:pokeglobal/domain/usecases/get_example_use_case.dart';

part 'example_provider.g.dart';

@riverpod
GetExampleUseCase getExampleUseCase(Ref ref) {
  final repository = ref.watch(exampleRepositoryProvider);
  return GetExampleUseCase(repository);
}
