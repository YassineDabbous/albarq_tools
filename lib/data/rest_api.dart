import 'package:albarq_tools/data/model.dart';
import 'package:albarq_tools/data/requests.dart';
import 'package:albarq_tools/data/responses/base_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
part 'rest_api.g.dart';

@RestApi()  
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @POST("/login")
  Future<BasicResponse<Profile>> login(@Body() Login login);
  @POST("/logout")
  Future<BasicResponse> logout();
  @GET("/profile")
  Future<BasicResponse<Profile>> profile({@DioOptions() required Options options});

  @GET("/counting")
  Future<BasicResponse<PaginationResponse<OrderCountingLog>>> counting({@Query('page') int? page});
  @POST("/counting")
  Future<BasicResponse<int>> countingCreate(@Body() OrderCountingRequest request);
  @DELETE("/counting/{id}")
  Future<BasicResponse> countingDelete(@Path('id') int id);
}
