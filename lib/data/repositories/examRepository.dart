import 'package:aurora_student/data/models/examsOnline.dart';
import 'package:aurora_student/utils/api.dart';
import 'package:flutter/foundation.dart';

class ExamOnlineRepository {
  Future<Map<String, dynamic>> getExamsOnline({
    int? page,
    required int subjectId,
    required int childId,
    required bool useParentApi,
  }) async {
    try {
      final result = await Api.get(
        url:
            useParentApi ? Api.parentExamOnlineList : Api.studentExamOnlineList,
        useAuthToken: true,
        queryParameters: {
          if (subjectId != 0) 'subject_id': subjectId,
          if (page != 0) 'page': page,
          if (useParentApi) 'child_id': childId
        },
      );
      if (kDebugMode) {
        print(result['data']);
      }

      return {
        "examList": (result['data']['data'] as List)
            .map((e) => ExamsOnline.fromJson(Map.from(e)))
            .toList(),
        "totalPage": result['data']['last_page'] as int,
        "currentPage": result['data']['current_page'] as int,
        //total entries & per_page
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }


  Future<String> setExamOnlineAnswers({
    required int examId,
    required Map<int, List<int>> answerData,
  }) async {
    try {
      final answersData = answerData.keys
          .map((key) => {"question_id": key, "option_id": answerData[key]})
          .toList();

      final body = {"online_exam_id": examId, "answers_data": answersData};
      if (kDebugMode) {
        print(body);
      }
      final result = await Api.post(
        url: Api.studentSubmitOnlineExamAnswers,
        useAuthToken: true,
        body: body,
      );
      if (kDebugMode) {
        print("result of answer's submission $result");
      }
      return result["message"];
    } catch (e) {
      if (kDebugMode) {
        print("exception @Answer submission $e");
      }
      throw ApiException(e.toString());
    }
  }
}
