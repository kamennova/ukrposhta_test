import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_cubit.dart';

class MockTrafficLightRepository extends Mock implements TrafficLightRepository {

}

void main() {
  group(TrafficLightCubit, (){
    late TrafficLightCubit trafficLightCubit;
    late TrafficLightRepository repository;

    setUpAll((){
      trafficLightCubit = TrafficLightCubit();
    });

    test("init state is red", (){
      expect(trafficLightCubit.state.currentColor, equals(LightColor.red));
    });

    test("colors change", (){

    });

  });
}