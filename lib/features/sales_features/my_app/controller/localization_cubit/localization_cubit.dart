import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '/../core/cache_helper/cache_helper.dart';

part 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit()
    : super(LocalizationState(locale: Locale(CacheHelper.getLanguage())));

  Future<void> changeLanguage(Locale locale) async {
    await CacheHelper.setLanguage(locale.languageCode);
    emit(LocalizationState(locale: locale));
  }
}
