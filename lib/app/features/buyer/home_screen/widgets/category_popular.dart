import 'package:flutter/material.dart';
import '../../../../../data/models/model.dart';
import '../../../../common_widgets/common_widgets.dart';
import '../../../../core/core.dart';

class CategoryPopular extends StatefulWidget {
  const CategoryPopular({super.key, required this.category, this.onTap});

  final Category category;
  final void Function()? onTap;

  @override
  State<CategoryPopular> createState() => _CategoryPopularState();
}

class _CategoryPopularState extends State<CategoryPopular> {
  @override
  Widget build(BuildContext context) {
    return InkWellWrapper(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(8),
      color: AppColors.primaryWhite,
      width: getWidth(160),
      margin: const EdgeInsets.all(5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 3,
          spreadRadius: 1,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 2,
          spreadRadius: 0,
          offset: const Offset(0, 1),
        )
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            child: Image.network(
              widget.category.icon ?? "",
              fit: BoxFit.cover,
              width: getWidth(160),
              height: getHeight(120),
              errorBuilder: (_, __, ___) => LoadingContainer(
                width: getWidth(160),
                height: getHeight(120),
              ),
              loadingBuilder:
                  (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return LoadingContainer(
                  width: getWidth(160),
                  height: getHeight(120),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: getHeight(20), left: getWidth(10), right: getWidth(10)),
            child: Text(
              widget.category.name ?? "",
              style: TextStyle(color: AppColors.primaryBlack, fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }
}
