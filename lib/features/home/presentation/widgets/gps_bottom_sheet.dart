import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location_service_app/features/home/presentation/cubit/gps/gps_cubit.dart';
import 'package:location_service_app/features/home/presentation/cubit/gps/gps_state.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';

/// GPS bottom sheet widget displaying location information
/// Shows current location status and control buttons
/// Uses BlocBuilder to react to GPS state changes
class GPSBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final DraggableScrollableController sheetController;

  const GPSBottomSheet({super.key, required this.scrollController, required this.sheetController});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GpsCubit>()..checkGpsStatus(),
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
                title: AppStrings.gpsTitle,
              ),
            ),

            // Content area with BlocBuilder
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXLarge),
              sliver: BlocBuilder<GpsCubit, GpsState>(
                builder: (context, state) {
                  return SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: AppDimensions.paddingSmall),

                      // My Location Card
                      _buildLocationCard(state),
                      const SizedBox(height: AppDimensions.paddingLarge),

                      // Action Button
                      _buildActionButton(context, state),
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

  /// Build the location display card
  Widget _buildLocationCard(GpsState state) {
    final bool isTracking = state is GpsTracking;
    final bool hasStopped = state is GpsStopped && state.lastLocation != null;

    // Get location data if available
    String? latText;
    String? lonText;
    if (isTracking) {
      latText = 'Lat : ${(state).location.formattedLatitude}';
      lonText = 'Lon : ${state.location.formattedLongitude}';
    } else if (hasStopped) {
      latText = 'Lat : ${(state).lastLocation?.formattedLatitude}';
      lonText = 'Lon : ${state.lastLocation?.formattedLongitude}';
    }

    // Determine status for non-tracking states
    String? statusText;
    Color statusColor = AppColors.primary;
    if (state is GpsDisabled) {
      statusText = AppStrings.gpsDisabled;
      statusColor = AppColors.gpsDisabled;
    } else if (state is GpsPermissionRequired) {
      statusText = AppStrings.gpsPermissionRequired;
      statusColor = AppColors.gpsDisabled;
    } else if (state is GpsError) {
      statusText = state.message;
      statusColor = AppColors.error;
    } else if (state is GpsInitial) {
      statusText = AppStrings.standby;
      statusColor = AppColors.primary;
    } else if (state is GpsStopped && state.lastLocation == null) {
      statusText = AppStrings.standby;
      statusColor = AppColors.primary;
    }

    return Container(
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
          // Status Display - either coordinates or status text
          if (latText != null && lonText != null)
            Row(
              children: [
                Text(
                  latText,
                  style: TextStyle(
                    fontSize: AppDimensions.fontLarge,
                    fontWeight: FontWeight.w500,
                    color: isTracking ? AppColors.running : AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingXLarge),
                Text(
                  lonText,
                  style: TextStyle(
                    fontSize: AppDimensions.fontLarge,
                    fontWeight: FontWeight.w500,
                    color: isTracking ? AppColors.running : AppColors.primary,
                  ),
                ),
              ],
            )
          else
            Text(
              statusText ?? AppStrings.standby,
              style: TextStyle(
                fontSize: AppDimensions.fontLarge,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
        ],
      ),
    );
  }

  /// Build the action button (Start/Stop GPS)
  Widget _buildActionButton(BuildContext context, GpsState state) {
    final bool isTracking = state is GpsTracking;
    final bool isDisabled = state is GpsDisabled;

    // Determine button properties based on state
    Color buttonColor;
    String statusText;
    String actionText;
    VoidCallback? onTap;

    if (isTracking) {
      // Blue button when tracking - matches design
      buttonColor = AppColors.gpsActive;
      statusText = AppStrings.gpsRunning;
      actionText = AppStrings.stopGPS;
      onTap = () => context.read<GpsCubit>().stopTracking();
    } else if (isDisabled) {
      buttonColor = AppColors.gpsDisabled;
      statusText = AppStrings.gpsDisabledMessage;
      actionText = AppStrings.startGPS;
      onTap = null; // Disabled
    } else {
      // Green button when stopped - matches design
      buttonColor = AppColors.gpsStopped;
      statusText = AppStrings.gpsSystemStopped;
      actionText = AppStrings.startGPS;
      onTap = () => context.read<GpsCubit>().startTracking();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                  child: SvgPicture.asset(
                    AppStrings.assetArrowUp,
                    width: AppDimensions.iconMedium,
                    height: AppDimensions.iconMedium,
                    colorFilter: ColorFilter.mode(
                      isDisabled
                          ? AppColors.textOnPrimary.withValues(alpha: 0.5)
                          : AppColors.textOnPrimary,
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
                  statusText,
                  style: TextStyle(
                    color:
                        isDisabled
                            ? AppColors.textOnPrimary.withValues(alpha: 0.5)
                            : AppColors.textOnPrimary,
                    fontSize: AppDimensions.fontSmall,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXSmall),
                Text(
                  actionText,
                  style: TextStyle(
                    color:
                        isDisabled
                            ? AppColors.textOnPrimary.withValues(alpha: 0.5)
                            : AppColors.textOnPrimary,
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
