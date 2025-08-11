import 'package:YLift/core/constants/index.dart';
import 'package:YLift/core/services/bearer.dart';
import 'package:dio/dio.dart';
import 'package:galaxy_models/galaxy_models.dart';
// TODO : RICHIE IS THIS NEEDED?

class AddressRepository {
  const AddressRepository();

  Future<List<AddressSimple>?> getAddressses({required String profileId}) async {
    final url = Uri.parse('$API_WEB_LINK/cart/profile/address?profileId=$profileId');

    final dio = Dio();
    dio.interceptors.add(BearerTokenInterceptor());
    final response = await dio.getUri(url);
    if (response.statusCode == 200) {
      final addresses = AddressSimple.fromList(response.data['addresses']);
      return addresses;
    } else {
      return null;
    }
  }
}
