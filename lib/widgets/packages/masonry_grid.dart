import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// ignore: must_be_immutable
class MasonryGrid extends StatelessWidget {
  MasonryGrid({
    super.key,
    required this.length,
    this.crossAxisCount = 2,
    required this.itemBuilder,
    this.padding= EdgeInsets.zero,
  });
  final int? length;
  int crossAxisCount;
  final Widget Function(BuildContext, int) itemBuilder;
  EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      
      padding: padding,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: length ?? 0,
      crossAxisCount: crossAxisCount,
      itemBuilder: itemBuilder,
    );
  }
}
