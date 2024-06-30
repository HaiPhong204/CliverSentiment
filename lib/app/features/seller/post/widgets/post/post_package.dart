import '../../../../../../data/services/services.dart';
import '../../../../../common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../data/models/model.dart';
import '../../../../../core/core.dart';
import '../../../../../routes/routes.dart';
import '../../../../features.dart';

class PostPackage extends StatefulWidget {
  const PostPackage({super.key, this.package, required this.type, this.canBuy});

  @override
  State<PostPackage> createState() => _PostPackageState();

  final Package? package;
  final String type;
  final bool? canBuy;
}

class _PostPackageState extends State<PostPackage> {
  final BottomBarController _bottomController = Get.find();
  final PaymentController _paymentController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        Text(
          widget.package?.name ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(widget.package?.description ?? ''),
        const SizedBox(height: 10),
        Row(
          children: [
            Text("Delivery days".tr),
            const Spacer(),
            Text(
              widget.package?.deliveryDays.toString() ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text("Revisions".tr),
            const Spacer(),
            Text(
              widget.package?.numberOfRevisions.toString() ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _bottomController.isSeller.value
            ? InkWellWrapper(
                onTap: () => Get.toNamed(editPostScreenRoute),
                child: Text("Edit your post".tr),
              )
            : InkWellWrapper(
                color: widget.canBuy != null ? AppColors.primaryColor : Colors.grey,
                paddingChild: EdgeInsets.symmetric(vertical: 8),
                onTap: (widget.canBuy != null)
                    ? () async {
                  // Get.toNamed(
                  //     paymentMethodRoute,
                  //     arguments: [
                  //       _paymentController.post?.packages![_paymentController.selectedPackage],
                  //       false,
                  //       null,
                  //       false,
                  //       null
                  //     ],
                  //   );
                        var res = await PaymentService.ins.orderPackage(
                            createOrder: CreateOrder(packageId: widget.package?.id as int, note: ""));
                        if (res.isOk) {
                          _bottomController.currentIndex.value = 2;
                          Get.offAllNamed(myBottomBarRoute);
                        } else {
                          print(res.error);
                        }
                      }
                    : () {
                        Get.defaultDialog(
                          title: "Warning",
                          content: const Text("You can't buy your service"),
                        );
                      },
                child: Text(
                  "Apply".tr,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
      ],
    );
  }
}
