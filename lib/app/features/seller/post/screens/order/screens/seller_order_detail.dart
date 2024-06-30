import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../data/models/model.dart';
import '../../../../../../../data/services/services.dart';
import '../../../../../features.dart';

class SellerOrderDetail extends StatefulWidget {
  const SellerOrderDetail({super.key});

  @override
  State<SellerOrderDetail> createState() => _SellerOrderDetailState();
}

class _SellerOrderDetailState extends State<SellerOrderDetail> {
  final orderId = Get.arguments[0];
  final postId = Get.arguments[1];
  final orderController = Get.find<SellerOrderController>();
  final _paymentController = Get.put(PaymentController());

  @override
  void initState() {
    super.initState();
    getPostByID();
  }

  Future<void> getPostByID() async {
    var res = await PostService.ins.getPostById(id: postId);
    if (res.isOk) {
      if (res.body["data"] != null) {
        var post = Post.fromJson(res.body['data']);
        _paymentController.post = post;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.message_sharp),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: FutureBuilder(
        future: orderController.getOrder(orderId: orderId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const Center(child: Text("Server error"));
            }
            _paymentController.order = snapshot.data as Order;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CardOrderDetail(
                      order: snapshot.data as Order,
                      isBuyer: false,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Time line".tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(thickness: 1),
                    SellerOrderTimeline(order: snapshot.data as Order)
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
