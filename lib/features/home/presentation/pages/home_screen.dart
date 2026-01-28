import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/advice_bottom_sheet.dart';
import '../widgets/gps_bottom_sheet.dart';

/// Home screen displaying an interactive floor plan with draggable bottom sheets
/// Contains navigation between Advice and GPS features
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Current selected tab index (0: Advice, 1: GPS)
  int _selectedIndex = 0;

  // Controller for draggable bottom sheet
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  /// Handle bottom navigation tap
  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main content area with zoom and drag capabilities
          Positioned.fill(
            bottom: 0,
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(AppDimensions.viewerBoundaryMargin),
              minScale: AppDimensions.viewerMinScale,
              maxScale: AppDimensions.viewerMaxScale,
              child: Center(
                child: Image.asset(
                  AppStrings.assetPlanImage,
                  height: AppDimensions.planImageHeight,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: AppDimensions.errorImageWidth,
                      height: AppDimensions.errorImageHeight,
                      color: AppColors.surfaceVariant,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: AppDimensions.iconXLarge,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: AppDimensions.paddingLarge),
                            Text(
                              AppStrings.imageNotFound,
                              style: TextStyle(color: AppColors.textTertiary),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Draggable Bottom Sheet - Switch between Advice and GPS
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: AppDimensions.sheetInitialSize,
            minChildSize: AppDimensions.sheetMinSize,
            maxChildSize: AppDimensions.sheetMaxSize,
            snap: true,
            snapSizes: const [
              AppDimensions.sheetMinSize,
              AppDimensions.sheetInitialSize,
              AppDimensions.sheetMaxSize,
            ],
            builder: (BuildContext context, ScrollController scrollController) {
              // Switch between Advice and GPS based on selected index
              return _selectedIndex == 0
                  ? AdviceBottomSheet(
                      scrollController: scrollController,
                      sheetController: _sheetController,
                    )
                  : GPSBottomSheet(
                      scrollController: scrollController,
                      sheetController: _sheetController,
                    );
            },
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: AppDimensions.shadowBlurRadiusSmall,
              offset: const Offset(0, AppDimensions.shadowOffsetY),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onBottomNavTap,
          selectedItemColor: AppColors.iconActive,
          unselectedItemColor: AppColors.iconInactive,
          backgroundColor: AppColors.surface,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 0 ? AppStrings.assetHomeFill : AppStrings.assetHomeLine,
                width: AppDimensions.iconMedium,
                height: AppDimensions.iconMedium,
                colorFilter: ColorFilter.mode(
                  _selectedIndex == 0 ? AppColors.iconActive : AppColors.iconInactive,
                  BlendMode.srcIn,
                ),
              ),
              label: AppStrings.navAdvice,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 1 ? AppStrings.asset3DFill : AppStrings.asset3DLine,
                width: AppDimensions.iconMedium,
                height: AppDimensions.iconMedium,
                colorFilter: ColorFilter.mode(
                  _selectedIndex == 1 ? AppColors.iconActive : AppColors.iconInactive,
                  BlendMode.srcIn,
                ),
              ),
              label: AppStrings.navGPS,
            ),
          ],
        ),
      ),
    );
  }
}
