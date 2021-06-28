import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

import '../../usecases/usecase.dart';

import 'login_validation_factory.dart';

LoginPresenter makeGetXLoginPresenter() {
  return GetXLoginPresenter(
    authenticationUseCase: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
    saveCurrentAccountUseCase: makeLocalSaveCurrentAccount(),
  );
}
