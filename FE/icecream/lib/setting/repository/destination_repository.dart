import 'package:dio/dio.dart';
import 'package:icecream/setting/model/add_destination_model.dart';
import 'package:icecream/setting/model/all_destination_model.dart';
import 'package:icecream/setting/model/delete_destination_model.dart';
import 'package:icecream/setting/model/destination_model.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
part 'destination_repository.g.dart';

@RestApi()
abstract class DestinationRespository {
  factory DestinationRespository(Dio dio, {String baseUrl})
  = _DestinationRespository;
  
  @GET('/destination/2?user_id={user_id}')
  Future<AllDestination<DestinationModel>> getDestinaion({
    @Path() required int user_id,
});
  @DELETE('/destination/2?destination_id={destination_id}')
  Future<DeleteDestination> deleteDestination({
    @Path() required int destination_id,
});
  
  @POST('/destination/2')
  Future<DeleteDestination> addDestination(@Body() AddDestinationModel destination);
}