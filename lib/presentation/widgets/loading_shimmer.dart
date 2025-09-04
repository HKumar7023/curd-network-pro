import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_constants.dart';

class LoadingShimmer extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;

  const LoadingShimmer({
    Key? key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250, // Dynamically adjusts column count
        mainAxisSpacing: AppConstants.smallPadding,
        crossAxisSpacing: AppConstants.smallPadding,
        // Removed childAspectRatio to allow automatic height
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ProductCardShimmer(),
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 260, // Increased height to prevent overflow
          ),
          padding: const EdgeInsets.all(AppConstants.smallPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Wrap content height
            children: [
              // Image placeholder
              Container(
                height: 160, // Bigger image to look balanced
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
              ),

              const SizedBox(height: 12),

              // Title placeholder
              Container(height: 14, width: double.infinity, color: Colors.grey[300]),
              const SizedBox(height: 8),

              // Subtitle placeholder
              Container(height: 12, width: 100, color: Colors.grey[300]),
              const SizedBox(height: 8),

              // Price placeholder
              Container(height: 12, width: 70, color: Colors.grey[300]),
              const SizedBox(height: 10),

              // Button placeholder
              Container(
                height: 36, // Increased button size
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListItemShimmer extends StatelessWidget {
  const ListItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            children: [
              // Image placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
              ),

              const SizedBox(width: AppConstants.defaultPadding),

              // Content placeholder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 16, width: double.infinity, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Container(height: 14, width: 120, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Container(height: 14, width: 80, color: Colors.grey[300]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
