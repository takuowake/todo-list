import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageIndexProvider = StateProvider<int>((ref) => 0);
final pageControllerProvider = Provider<PageController>((ref) {
  final pageIndex = ref.watch(pageIndexProvider.notifier).state;
  return PageController(initialPage: pageIndex);
});