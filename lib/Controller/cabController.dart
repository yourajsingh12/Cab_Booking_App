import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Features/cabListPage/model/cabModel.dart';



class CabController extends GetxController {
  var isLoading = true.obs;
  var cabList = <CabModel>[].obs;

  final String apiUrl = "https://rodways.site/app/api/cabs";

  @override
  void onInit() {
    super.onInit();
    fetchCabs();
  }

  Future<void> fetchCabs() async {
    try {
      isLoading(true);

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        List data = jsonData["data"]["data"];

        cabList.value =
            data.map((cab) => CabModel.fromJson(cab)).toList();
      }
    } catch (e) {
      print("Error fetching cabs: $e");
    } finally {
      isLoading(false);
    }
  }
}
