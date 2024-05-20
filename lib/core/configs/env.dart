import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'HTTP_ENDPOINT', obfuscate: true)
  static final String gTranslateEndpoint = _Env.gTranslateEndpoint;
}
