import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

/// GPS bottom sheet widget displaying location information
/// Shows current location status and control buttons
class GPSBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final DraggableScrollableController sheetController;

  const GPSBottomSheet({super.key, required this.scrollController, required this.sheetController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXLarge)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: AppDimensions.shadowBlurRadius,
            spreadRadius: AppDimensions.shadowSpreadRadius,
          ),
        ],
      ),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          // Persistent Header - Draggable handle
          SliverPersistentHeader(
            pinned: true,
            delegate: _BottomSheetHeaderDelegate(
              sheetController: sheetController,
              title: AppStrings.gpsTitle,
            ),
          ),

          // Content area
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXLarge),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppDimensions.paddingSmall),

                // My Location Card
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AppStrings.assetMapPin,
                        width: AppDimensions.iconSmall,
                        height: AppDimensions.iconSmall,
                        colorFilter: ColorFilter.mode(AppColors.textTertiary, BlendMode.srcIn),
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      Text(
                        AppStrings.myLocation,
                        style: TextStyle(
                          fontSize: AppDimensions.fontMedium,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXXLarge),
                      // Status Display
                      Text(
                        AppStrings.standby,
                        style: TextStyle(
                          fontSize: AppDimensions.fontLarge,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLarge),

                // Start Button
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                    color: AppColors.primary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: AppDimensions.iconLarge,
                            height: AppDimensions.iconLarge,
                            child: SvgPicture.asset(
                              AppStrings.assetArrowUp,
                              width: AppDimensions.iconMedium,
                              height: AppDimensions.iconMedium,
                              colorFilter: const ColorFilter.mode(
                                AppColors.textOnPrimary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingXXLarge),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.gpsSystemStopped,
                            style: const TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: AppDimensions.fontSmall,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.paddingXSmall),
                          Text(
                            AppStrings.startGPS,
                            style: const TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: AppDimensions.fontXLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet header delegate with drag handle
class _BottomSheetHeaderDelegate extends SliverPersistentHeaderDelegate {
  final DraggableScrollableController sheetController;
  final String title;

  _BottomSheetHeaderDelegate({required this.sheetController, required this.title});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GestureDetector(
      onTap: () {
        // Toggle between min and max sizes
        if (sheetController.size < AppDimensions.sheetMidSize) {
          sheetController.animateTo(
            AppDimensions.sheetMaxSize,
            duration: const Duration(milliseconds: AppDimensions.animationDuration),
            curve: Curves.easeInOut,
          );
        } else {
          sheetController.animateTo(
            AppDimensions.sheetMinSize,
            duration: const Duration(milliseconds: AppDimensions.animationDuration),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXLarge)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXLarge),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
              width: AppDimensions.handleWidth,
              height: AppDimensions.handleHeight,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppDimensions.handleRadius),
              ),
            ),
            // Header with title and icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontXXLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    AppStrings.assetMapPin,
                    width: AppDimensions.iconMedium,
                    height: AppDimensions.iconMedium,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => AppDimensions.headerHeight;

  @override
  double get minExtent => AppDimensions.headerHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
