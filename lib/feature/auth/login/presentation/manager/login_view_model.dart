// import 'dart:developer' as developer;

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:injectable/injectable.dart';
// import 'package:zadana_user_v3/core/network/api_results.dart';
// import '../../domain/entities/login_request_entity.dart';
// import '../../domain/usecase/login_usecase.dart';
// import 'login_event.dart';
// import 'login_state.dart';

// /// Login ViewModel
// /// Handles login logic using intent/event pattern
// @injectable
// class LoginViewModel extends Cubit<LoginState> {
//   final LoginUseCase _loginUseCase;


//   LoginViewModel(
//     this._loginUseCase,
    
//   ) : super(const LoginState());

//   /// Main intent handler
//   /// Dispatches events to appropriate handlers
//   void doIntent(LoginEvent event) {
//     switch (event) {
//       case LoginSubmitEvent():
//         _loginUser(event.requestEntity);
//     }
//   }

//   /// Login user
//   Future<void> _loginUser(
//     LoginRequestEntity requestEntity,
//   ) async {
//     emit(state.copyWith(
//       isLoading: true,
//       errorMessage: null,
//     ));

//     developer.log(
//       'Logging in user: ${requestEntity.identifier}',
//       name: 'LoginViewModel',
//     );

//     final result = await _loginUseCase.call(requestEntity);

//     switch (result) {
//       case ApiSuccessResult():

//         developer.log(
//           'Login successful, access token saved',
//           name: 'LoginViewModel',
//         );

//         emit(state.copyWith(
//           isLoading: false,
//           isSuccess: true,
//           loginResponse: result.data,
//         ));

//       case ApiErrorResult():
//         developer.log(
//           'Login failed: ${result.failure.errorMessage}',
//           name: 'LoginViewModel',
//         );

//         emit(state.copyWith(
//           isLoading: false,
//           errorMessage: result.failure.errorMessage,
//         ));
//     }
//   }
// }