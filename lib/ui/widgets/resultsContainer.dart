import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aurora_student/app/routes.dart';
import 'package:aurora_student/cubits/authCubit.dart';
import 'package:aurora_student/cubits/resultTabSelectionCubit.dart';
import 'package:aurora_student/cubits/resultsCubit.dart';
import 'package:aurora_student/cubits/resultsOnlineCubit.dart';
import 'package:aurora_student/cubits/studentSubjectAndSlidersCubit.dart';

import 'package:aurora_student/data/models/result.dart';
import 'package:aurora_student/data/models/resultOnline.dart';
import 'package:aurora_student/data/models/subject.dart';

import 'package:aurora_student/ui/widgets/assignmentsSubjectsContainer.dart';
import 'package:aurora_student/ui/widgets/customBackButton.dart';
import 'package:aurora_student/ui/widgets/customRefreshIndicator.dart';
import 'package:aurora_student/ui/widgets/customShimmerContainer.dart';
import 'package:aurora_student/ui/widgets/customTabBarContainer.dart';
import 'package:aurora_student/ui/widgets/errorContainer.dart';
import 'package:aurora_student/ui/widgets/listItemForExamAndResult.dart';
import 'package:aurora_student/ui/widgets/noDataContainer.dart';
import 'package:aurora_student/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:aurora_student/ui/widgets/shimmerLoadingContainer.dart';
import 'package:aurora_student/ui/widgets/tabBarBackgroundContainer.dart';

import 'package:aurora_student/utils/labelKeys.dart';
import 'package:aurora_student/utils/uiUtils.dart';

class ResultsContainer extends StatefulWidget {
  final int? childId;
  final List<Subject>? subjects;

  const ResultsContainer({Key? key, this.childId, this.subjects})
      : super(key: key);

  @override
  State<ResultsContainer> createState() => _ResultsContainerState();
}

class _ResultsContainerState extends State<ResultsContainer> {
  late final ScrollController _scrollController = ScrollController()
    ..addListener(_resultsScrollListener);
  //same for both Online and Offline Result

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      fetchResults();
      fetchOnlineResults();
    });
    super.initState();
  }

  void fetchResults() {
    context.read<ResultsCubit>().fetchResults(
          useParentApi: context.read<AuthCubit>().isParent(),
          childId: widget.childId,
        );
  }

  void _resultsScrollListener() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      if (context.read<ResultTabSelectionCubit>().isResultOnline()) {
        if (context.read<ResultsOnlineCubit>().hasMore()) {
          context.read<ResultsOnlineCubit>().fetchMoreResultsOnline(
                useParentApi: context.read<AuthCubit>().isParent(),
                childId: widget.childId ?? 0,
                subjectId: context
                    .read<ResultTabSelectionCubit>()
                    .state
                    .resultFilterBySubjectId,
              );
          //to scroll to last in order for users to see the progress
          Future.delayed(const Duration(milliseconds: 10), () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          });
        }
      } else {
        if (context.read<ResultsCubit>().hasMore()) {
          context.read<ResultsCubit>().fetchMoreResults(
                useParentApi: context.read<AuthCubit>().isParent(),
                childId: widget.childId,
              );
          //to scroll to last in order for users to see the progress
          Future.delayed(const Duration(milliseconds: 10), () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_resultsScrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildAppBar(ResultTabSelectionState currentState) {
    return ScreenTopBackgroundContainer(
      heightPercentage: 0.12,
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Stack(
            children: [
              context.read<AuthCubit>().isParent()
                  ? const CustomBackButton()
                  : const SizedBox.shrink(),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  UiUtils.getTranslatedLabel(context, resultsKey),
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: UiUtils.screenTitleFontSize,
                  ),
                ),
              ),

            ],
          );
        },
      ),
    );
  }

  Widget _buildResultDetailsShimmerLoadingContainer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.5),
      width: MediaQuery.of(context).size.width * (0.85),
      height: 80.0,
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLoadingContainer(
                child: CustomShimmerContainer(
                  width: boxConstraints.maxWidth * (0.7),
                ),
              ),
              SizedBox(
                height: boxConstraints.maxHeight * (0.25),
              ),
              ShimmerLoadingContainer(
                child: CustomShimmerContainer(
                  width: boxConstraints.maxWidth * (0.5),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResultDetailsContainer({
    required Result result,
    required int index,
    required int totalResults,
    required bool hasMoreResults,
    required bool hasMoreResultsInProgress,
    required bool fetchMoreResultsFailure,
  }) {
    return Column(
      children: [
        ListItemForExamAndResult(
          index: index,
          examStartingDate: result.examDate,
          examName: result.examName,
          resultGrade: result.grade,
          resultPercentage: result.percentage,
          onItemTap: () {
            Navigator.of(context).pushNamed(
              Routes.result,
              arguments: {"childId": widget.childId, "result": result},
            );
          },
        ),
        if (index == (totalResults - 1) &&
            hasMoreResults &&
            hasMoreResultsInProgress)
          _buildResultDetailsShimmerLoadingContainer(),
        if (index == (totalResults - 1) &&
            hasMoreResults &&
            fetchMoreResultsFailure)
          Center(
            child: CupertinoButton(
              child: Text(UiUtils.getTranslatedLabel(context, retryKey)),
              onPressed: () {
                context.read<ResultsCubit>().fetchMoreResults(
                      useParentApi: context.read<AuthCubit>().isParent(),
                      childId: widget.childId,
                    );
              },
            ),
          ),
      ],
    );
  }

  Widget buildOfflineResults() {
    return Align(
      alignment: Alignment.topCenter,
      child: CustomRefreshIndicator(
        onRefreshCallback: () {
          if (context.read<ResultsCubit>().state is ResultsFetchSuccess) {
            fetchResults();
          }
        },
        displacment: UiUtils.getScrollViewTopPadding(
          context: context,
          appBarHeightPercentage: UiUtils.appBarBiggerHeightPercentage,
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: UiUtils.getScrollViewBottomPadding(context),
            top: UiUtils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: 0.15,
            ),
          ),
          child: BlocBuilder<ResultsCubit, ResultsState>(
            builder: (context, state) {
              if (state is ResultsFetchSuccess) {
                return state.results.isNotEmpty
                    ? Column(
                        children: List.generate(
                          state.results.length,
                          (index) => index,
                        ).map((index) {
                          return _buildResultDetailsContainer(
                            result: state.results[index],
                            index: index,
                            totalResults: state.results.length,
                            hasMoreResults:
                                context.read<ResultsCubit>().hasMore(),
                            hasMoreResultsInProgress:
                                state.fetchMoreResultsInProgress,
                            fetchMoreResultsFailure:
                                state.moreResultsFetchError,
                          );
                        }).toList(),
                      )
                    : const Center(
                        child: NoDataContainer(titleKey: noResultPublishedKey),
                      );
              }
              if (state is ResultsFetchFailure) {
                return ErrorContainer(
                  errorMessageCode: state.errorMessage,
                  onTapRetry: () {
                    fetchResults();
                  },
                );
              }
              return Column(
                children: List.generate(
                  UiUtils.defaultShimmerLoadingContentCount,
                  (index) => _buildResultDetailsShimmerLoadingContainer(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  //Online Result
  Widget buildMySubjectsListContainer() {
    return BlocBuilder<StudentSubjectsAndSlidersCubit,
        StudentSubjectsAndSlidersState>(
      builder: (context, state) {
        return BlocBuilder<ResultTabSelectionCubit, ResultTabSelectionState>(
          bloc: context.read<ResultTabSelectionCubit>(),
          builder: (context, state) {
            return AssignmentsSubjectContainer(
              cubitAndState: "onlineResult",
              onTapSubject: (subjectId) {
                //fetch student online Result according to respected subjectId
                context
                    .read<ResultTabSelectionCubit>()
                    .changeResultFilterBySubjectId(
                      subjectId,
                    );
                fetchOnlineResults();
              },
              selectedSubjectId: state.resultFilterBySubjectId,
              subjects: (widget.subjects != null)
                  ? widget.subjects! //from parent
                  : context
                      .read<StudentSubjectsAndSlidersCubit>()
                      .getSubjectsForAssignmentContainer(),
            );
          },
        );
      },
    );
  }

  void fetchOnlineResults() {
    context.read<ResultsOnlineCubit>().fetchResultsOnline(
          useParentApi: context.read<AuthCubit>().isParent(),
          childId: widget.childId ?? 0,
          subjectId: context
              .read<ResultTabSelectionCubit>()
              .state
              .resultFilterBySubjectId,
        );
  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResultTabSelectionCubit, ResultTabSelectionState>(
      builder: (context, state) {
        return Stack(
          children: [
            (context.read<ResultTabSelectionCubit>().isResultOnline())
                ? Container()
                : buildOfflineResults(),
            Align(
              alignment: Alignment.topCenter,
              child: _buildAppBar(state),
            ),
          ],
        );
      },
    );
  }
}
