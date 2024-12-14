import 'package:aurora_student/ui/widgets/customShowCaseWidget.dart';
import 'package:aurora_student/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavItem {
  final String title;
  final String activeImageUrl;
  final String disableImageUrl;

  BottomNavItem({
    required this.activeImageUrl,
    required this.disableImageUrl,
    required this.title,
  });
}

class BottomNavItemContainer extends StatefulWidget {
  final BoxConstraints boxConstraints;
  final int index;
  final int currentIndex;
  final AnimationController animationController;
  final BottomNavItem bottomNavItem;
  final Function onTap;
  final GlobalKey showCaseKey;
  final String showCaseDescription;
  const BottomNavItemContainer({
    Key? key,
    required this.boxConstraints,
    required this.currentIndex,
    required this.showCaseDescription,
    required this.showCaseKey,
    required this.bottomNavItem,
    required this.animationController,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  @override
  State<BottomNavItemContainer> createState() => _BottomNavItemContainerState();
}

class _BottomNavItemContainerState extends State<BottomNavItemContainer> {
  @override
  Widget build(BuildContext context) {
    return CustomShowCaseWidget(
      globalKey: widget.showCaseKey,
      description: widget.showCaseDescription,
      child: InkWell(
        onTap: () async {
          widget.onTap(widget.index);
        },
        child: SizedBox(
          width: widget.boxConstraints.maxWidth * (0.25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.index == widget.currentIndex?
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: SvgPicture.asset(
                    widget.index == widget.currentIndex
                        ? widget.bottomNavItem.activeImageUrl
                        : widget.bottomNavItem.disableImageUrl,
                  ),
              ):SvgPicture.asset(
                widget.index == widget.currentIndex
                    ? widget.bottomNavItem.activeImageUrl
                    : widget.bottomNavItem.disableImageUrl,
              ),
              SizedBox(
                height: widget.boxConstraints.maxHeight * (0.051),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
