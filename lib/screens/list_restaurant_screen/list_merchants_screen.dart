import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_app_engineer/blocs/merchant_bloc.dart';
import 'package:mobile_app_engineer/models/list_merchants_response.dart';
import 'package:mobile_app_engineer/repositories/merchant_repository.dart';
import 'package:mobile_app_engineer/screens/details_restaurant_screen/details_merchant_screen.dart';
import 'package:mobile_app_engineer/screens/list_restaurant_screen/merchant_cell.dart';

class ListMerchantScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListMerchantScreenState();
  }
}

class ListMerchantScreenState extends State<ListMerchantScreen> {
  late MerchantRepository merchantRepository;
  late MerchantBloc _merchantBloc;

  List<Merchant> listMerchants = [];

  @override
  void initState() {
    super.initState();
    merchantRepository = MerchantRepository();
    _merchantBloc = MerchantBloc(merchantRepository);

    _merchantBloc.add(GetMerchantsList(120));
  }

  @override
  void dispose() {
    _merchantBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome", style:  TextStyle(color: Colors.white, fontSize: 24,
            fontWeight: FontWeight.bold)),
        leading: const SizedBox(),
      ),
        body: BlocListener(
          bloc: _merchantBloc,
          listener: (BuildContext c, MerchantState state) async {
            if (state is MerchantInitial) {
              EasyLoading.show(status: 'Please Wait...');
            }

            if (state is GetMerchantsListState) {
              EasyLoading.dismiss();
              listMerchants = state.response;
            }

            if (state is ErrorState) {
              EasyLoading.dismiss();
            }
          },
          child: BlocBuilder(
              bloc: _merchantBloc,
              builder: (c, MerchantState state) {
                return body(c, state);
              }),
        ));
  }

  Widget body(BuildContext context, MerchantState state) {
    // TODO: Implement build
    return ListView.builder(
      itemCount: listMerchants.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return MerchantCell(name: listMerchants[index].name,
            imageUrl: listMerchants[index].images!.isNotEmpty
                ? listMerchants[index].images!.first.url
                : "https://via.placeholder.com/350x150",
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => DetailMerchantScreen(listMerchants[index])));
            });
      },
    );
  }


}