import 'package:aurora_student/ui/widgets/customAppbar.dart';
import 'package:aurora_student/utils/labelKeys.dart';
import 'package:aurora_student/utils/uiUtils.dart';
import 'package:flutter/material.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
                top: UiUtils.getScrollViewTopPadding(
                    context: context,
                    appBarHeightPercentage:
                        UiUtils.appBarSmallerHeightPercentage,),),
            child: const Column(
              children: [Center(child: Text("About us data"))],
            ),
          ),
          CustomAppBar(title: UiUtils.getTranslatedLabel(context, faqsKey))
        ],
      ),
    );
  }
}
