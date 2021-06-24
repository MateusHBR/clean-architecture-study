import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

import '../../usecases/usecase.dart';

import 'login_validation_factory.dart';

LoginPresenter makeLoginPresenter() {
  return StreamLoginPresenter(
    authenticationUseCase: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
  );
}
