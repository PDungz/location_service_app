import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/advice/advice_cubit.dart';
import '../cubit/advice/advice_state.dart';

/// Advice bottom sheet widget
/// Displays fetched advice and provides controls to fetch more
class AdviceBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final DraggableScrollableController sheetController;

  const AdviceBottomSheet({
    super.key,
    required this.scrollController,
    required this.sheetController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdviceCubit>(),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXLarge),
          ),
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
                title: AppStrings.adviceTitle,
              ),
            ),

            // Content area
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXLarge),
              sliver: BlocBuilder<AdviceCubit, AdviceState>(
                builder: (context, state) {
                  return SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: AppDimensions.paddingSmall),

                      // Display list of fetched advices
                      _buildAdviceList(state),

                      const SizedBox(height: AppDimensions.paddingLarge),

                      // Action Button - Get New Advice
                      _buildActionButton(context, state),

                      const SizedBox(height: AppDimensions.paddingLarge),
                    ]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build advice list widget
  /// Shows empty state or list of fetched advices
  Widget _buildAdviceList(AdviceState state) {
    List<dynamic> advices = [];

    // Extract advices from different states
    if (state is AdviceLoading) {
      advices = state.advices;
    } else if (state is AdviceLoaded) {
      advices = state.advices;
    } else if (state is AdviceError) {
      advices = state.advices;
    }

    // Show empty state when no advices available
    if (advices.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  AppStrings.assetInfoCircle,
                  width: AppDimensions.iconSmall,
                  height: AppDimensions.iconSmall,
                  colorFilter: ColorFilter.mode(AppColors.textTertiary, BlendMode.srcIn),
                ),
                const SizedBox(width: AppDimensions.paddingSmall),
                Text(
                  AppStrings.todaysAdvice,
                  style: TextStyle(
                    fontSize: AppDimensions.fontMedium,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(
              AppStrings.emptyAdvice,
              style: TextStyle(fontSize: AppDimensions.fontSmall, color: AppColors.textTertiary),
            ),
            const SizedBox(height: AppDimensions.paddingXXLarge),
            Text(
              '${AppStrings.adviceIdPrefix}0',
              style: TextStyle(
                fontSize: AppDimensions.fontLarge,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // Display list of advices
    return Column(
      children: [
        ...advices.asMap().entries.map((entry) {
          final index = entry.key;
          final advice = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < advices.length - 1 ? AppDimensions.paddingMedium : 0,
            ),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(color: AppColors.surfaceVariant, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppStrings.assetInfoCircle,
                        width: AppDimensions.iconSmall,
                        height: AppDimensions.iconSmall,
                        colorFilter: ColorFilter.mode(AppColors.textTertiary, BlendMode.srcIn),
                      ),
                      const SizedBox(width: AppDimensions.paddingSmall),
                      Text(
                        "Advice ${index + 1}",
                        style: TextStyle(
                          fontSize: AppDimensions.fontMedium,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  Text(
                    advice.advice,
                    style: TextStyle(
                      fontSize: AppDimensions.fontSmall,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  Text(
                    '${AppStrings.adviceIdPrefix}${advice.id}',
                    style: TextStyle(
                      fontSize: AppDimensions.fontLarge,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        // Display error message if any
        if (state is AdviceError)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.paddingMedium),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                border: Border.all(color: AppColors.errorBorder, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: AppDimensions.iconSmall),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  Expanded(
                    child: Text(
                      state.message,
                      style: TextStyle(fontSize: AppDimensions.fontSmall, color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Build action button widget
  /// Changes color and text based on loading state
  Widget _buildActionButton(BuildContext context, AdviceState state) {
    final isLoading = state is AdviceLoading;

    // Determine button color - green when idle, blue when running
    final buttonColor = isLoading ? AppColors.running : AppColors.success;

    // Determine button text
    final String topText;
    final String bottomText;

    if (isLoading) {
      final loadingState = state;
      topText = '${AppStrings.runningAdvice}${loadingState.currentCall}/${loadingState.totalCalls}';
      bottomText = AppStrings.stopAdvice;
    } else {
      topText = AppStrings.getNewAdvice;
      bottomText = AppStrings.clickToStart;
    }

    return GestureDetector(
      onTap:
          isLoading
              ? () {}
              : () {
                if (!isLoading) {
          // Start fetching when idle
          context.read<AdviceCubit>().fetchMultipleAdvices();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppDimensions.animationDuration),
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          color: buttonColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: AppDimensions.iconLarge,
                  height: AppDimensions.iconLarge,
                  child:
                      isLoading
                          ? const CircularProgressIndicator(
                            color: AppColors.textOnPrimary,
                            strokeWidth: 3,
                          )
                          : SvgPicture.asset(
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
                  topText,
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: AppDimensions.fontSmall,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXSmall),
                Text(
                  bottomText,
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
    );
  }
}

/// Bottom sheet header delegate with drag handle
class _BottomSheetHeaderDelegate extends SliverPersistentHeaderDelegate {
  final DraggableScrollableController sheetController;
  final String title;

  _BottomSheetHeaderDelegate({
    required this.sheetController,
    required this.title,
  });

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
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXLarge),
          ),
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
                    AppStrings.assetInfoCircle,
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
