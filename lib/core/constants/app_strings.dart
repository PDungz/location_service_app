/// App string constants
/// Centralized text definitions for easy localization and maintenance
class AppStrings {
  AppStrings._();

  // App Info
  static const String appName = 'Location Service App';

  // Navigation
  static const String navAdvice = 'Advice';
  static const String navGPS = 'GPS';

  // Advice Feature
  static const String adviceTitle = 'Advice';
  static const String todaysAdvice = "Today's Advice";
  static const String emptyAdvice = 'Empty';
  static const String adviceIdPrefix = 'ID : ';
  static const String getNewAdvice = 'Get New Advice';
  static const String clickToStart = 'Click';
  static const String stopAdvice = 'Stop';
  static const String runningAdvice = 'Running ... ';

  // GPS Feature
  static const String gpsTitle = 'GPS';
  static const String myLocation = 'MY LOCATION';
  static const String standby = 'Standby';
  static const String gpsSystemStopped = 'GPS System is Stopped';
  static const String startGPS = 'Start';
  static const String stopGPS = 'Stop';
  static const String gpsTracking = 'GPS Tracking Active';
  static const String gpsRunning = 'GPS System is Running ...';
  static const String gpsDisabled = 'GPS is Disabled';
  static const String gpsDisabledMessage = 'Please enable GPS in device settings';
  static const String gpsPermissionRequired = 'Location Permission Required';
  static const String gpsError = 'GPS Error';
  static const String latitude = 'Lat';
  static const String longitude = 'Lon';
  static const String lastUpdated = 'Last Updated';

  // Error Messages
  static const String imageNotFound = 'Floor plan image not found';

  // Asset Paths
  static const String assetPlanImage = 'assets/image/plan.png';
  static const String assetHomeFill = 'assets/svg/home-fill.svg';
  static const String assetHomeLine = 'assets/svg/home-line.svg';
  static const String asset3DFill = 'assets/svg/3d-fill.svg';
  static const String asset3DLine = 'assets/svg/3d-line.svg';
  static const String assetMapPin = 'assets/svg/map-pin-line.svg';
  static const String assetInfoCircle = 'assets/svg/info-circle-line.svg';
  static const String assetArrowUp = 'assets/svg/btn-arrow-up.svg';
}
