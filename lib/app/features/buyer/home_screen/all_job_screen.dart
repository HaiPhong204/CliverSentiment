import 'dart:convert';
import 'dart:math';

import 'package:cliver_sentiment/app/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../data/models/model.dart';
import '../../../../data/services/RecommendService.dart';
import '../../../../data/services/services.dart';
import '../../../controller/controller.dart';
import '../../../core/core.dart';
import '../../../routes/routes.dart';
import 'widgets/category_save.dart';

class AllJobScreen extends StatefulWidget {
  const AllJobScreen({super.key});

  @override
  State<AllJobScreen> createState() => _AllJobScreenState();
}

class _AllJobScreenState extends State<AllJobScreen> {
  String? skills;
  String? descriptions;
  bool isChecked = false;
  List<bool> listCheckBool = List.generate(100, (index) => false);
  late final UserController userController;

  late List<Post> postsAllRecommend = [];
  late bool isGetDataAllRecommend;
  bool isSelectAll = false;

  @override
  void initState() {
    skills = Get.arguments[0];
    descriptions = Get.arguments[1];
    userController = Get.find();
    getPostsRecommend();
    super.initState();
  }

  String replaceNaN(String json) {
    return json.replaceAll('NaN', 'null');
  }

  void getPostsRecommend() async {
    setState(() {
      isGetDataAllRecommend = false;
    });
    EasyLoading.show();
    var res =
        await RecommendService.ins.getPostRecommend(skill: skills, experiences: descriptions);
    EasyLoading.dismiss();
    var responseData = json.decode(replaceNaN(res.body));
    if (res.isOk) {
      if (res.body.isNotEmpty) {
        postsAllRecommend = <Post>[];
        responseData.forEach((v) {
          if (v != null) {
            postsAllRecommend.add(Post.fromJson(v));
          }
        });
      }
    }
    setState(() {
      isGetDataAllRecommend = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryWhite,
        title: Text(
          'Jobs recommendation'.tr,
          style: TextStyle(fontSize: getFont(22), fontWeight: FontWeight.w700),
        ),
        actions:[
          Row(
            children: [
              InkWellWrapper(
                onTap: () async {
                  Random random = Random();
                  int randomNumber = random.nextInt(1195) + 1;
                  Map<String, dynamic> data = {
                    'UserId': randomNumber,
                    'Rated': [
                      {'JobId': 10, 'Rate': 1}
                    ]
                  };
                  List<Map<String, dynamic>> ratedList = [];
                  for (int i = 0; i < postsAllRecommend.length; i++) {
                    int jobId = postsAllRecommend[i].id!;
                    int rate = listCheckBool[i] ? 1 : 0;
                    Map<String, dynamic> rated = {'JobId': jobId, 'Rate': rate};
                    ratedList.add(rated);
                  }
                  Map<String, dynamic> postData = {'UserId': randomNumber, 'Rated': ratedList};
                  EasyLoading.show();
                  var res = await RecommendService.ins.postRattingJob(data: postData);
                  if(res.isOk) {
                    Get.showSnackbar(const GetSnackBar(message: "Submit successfully"));
                  }
                  EasyLoading.dismiss();
                },
                paddingChild: EdgeInsets.symmetric(horizontal: getWidth(15)),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: isGetDataAllRecommend
          ? SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: getWidth(30)),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Check All",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Checkbox(
                          activeColor: AppColors.primaryColor,
                          value: isSelectAll,
                          onChanged: (newValue) {
                            setState(() {
                              isSelectAll = !isSelectAll;
                              if (newValue!) {
                                for (int i = 0; i < listCheckBool.length; i++) {
                                  listCheckBool[i] = true;
                                }
                              } else {
                                for (int i = 0; i < listCheckBool.length; i++) {
                                  listCheckBool[i] = false;
                                }
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth(30), vertical: getHeight(10)),
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategorySave(
                            onTap: () => Get.toNamed(postDetailScreenRoute,
                                arguments: postsAllRecommend[index].id),
                            postSave: postsAllRecommend[index],
                            getPostsRecent: getPostsRecommend,
                            onChangedStatus: (value) async {
                              EasyLoading.show();
                              await SaveServiceAPI.ins.changeStatusServicesSaveListById(
                                  listId: value, serviceId: postsAllRecommend[index].id!);
                              EasyLoading.dismiss();
                            },
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: AppColors.primaryColor,
                            value: listCheckBool[index],
                            onChanged: (bool? value) {
                              setState(() {
                                listCheckBool[index] = value!;
                              });
                            },
                          )
                        ],
                      );
                    },
                    itemCount: postsAllRecommend.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                  )
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
