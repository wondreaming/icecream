import 'package:dio/dio.dart';
import 'package:icecream/setting/model/add_destination_model.dart';
import 'package:icecream/setting/model/all_destination_model.dart';
import 'package:icecream/setting/model/response_destination_model.dart';
import 'package:icecream/setting/model/destination_model.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
part 'destination_repository.g.dart';

@RestApi()
abstract class DestinationRespository {
  factory DestinationRespository(Dio dio) = _DestinationRespository;

  @GET('/destination')
  Future<AllDestination<DestinationModel>> getDestinaion({
    @Query('user_id') required int user_id,
  });

  @DELETE('/destination')
  Future<ResponseDestination> deleteDestination({
    @Query('destination_id') required int destination_id,
  });

  @POST('/destination')
  Future<ResponseDestination> addDestination({
    @Body() required AddDestinationModel destination
    });

}
