import 'package:dio/dio.dart';
import 'package:icecream/setting/model/all_destination_model.dart';
import 'package:icecream/setting/model/delete_destination_model.dart';
import 'package:icecream/setting/model/destination_model.dart';
import 'package:retrofit/http.dart';
part 'destination_repository.g.dart';

@RestApi()
abstract class DestinationRespository {
  factory DestinationRespository(Dio dio, {String baseUrl})
  = _DestinationRespository;
  
  @GET('/destination?user_id={user_id}')
  Future<AllDestination<DestinationModel>> getDestinaion({
    @Path() required int user_id,
});
  @DELETE('/destination?destination_id={destination_id}')
  Future<DeleteDestination> deleteDestination({
    @Path() required int destination_id,
});
}