import 'package:get/get.dart';

import '../../app/core/core.dart';

class RecommendService extends GetConnect {
  RecommendService._initInstance();

  static final RecommendService ins = RecommendService._initInstance();

  Future<Response> getPostRecommend({required String? skill, required String? experiences}) {
    return post(
      '$api_recommend/recommend',
      {
        "Skill" : skill,
        "Experiences" : experiences
      },
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<Response> getPostAllRecommend({required String? skill, required String? experiences}) {
    return post(
      '$api_recommend/recommend-all',
      {
        "Skill" : skill,
        "Experiences" : experiences
      },
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<Response> postRattingJob({required Map<String, dynamic> data}) {
    return post(
      '$api_recommend/job-evaluation',
      data,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}