import Flutter
import UIKit
import CoreLocation

@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
    private let channelName = "com.example.location_service_app/gps"
    
    private var locationManager: CLLocationManager?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        guard let controller = window?.rootViewController as? FlutterViewController else {
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        // Initialize location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        // Setup MethodChannel
        let methodChannel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: controller.binaryMessenger
        )
        
        methodChannel.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "isGpsEnabled":
                result(CLLocationManager.locationServicesEnabled())
            case "hasPermission":
                let status = CLLocationManager.authorizationStatus()
                result(status == .authorizedWhenInUse || status == .authorizedAlways)
            case "requestPermission":
                self?.locationManager?.requestWhenInUseAuthorization()
                result(true)
            case "startGps":
                self?.locationManager?.startUpdatingLocation()
                result(true)
            case "stopGps":
                self?.locationManager?.stopUpdatingLocation()
                result(true)
            case "getLocation":
                if let location = self?.locationManager?.location {
                    let locationData: [String: Any] = [
                        "latitude": location.coordinate.latitude,
                        "longitude": location.coordinate.longitude,
                        "timestamp": Int(location.timestamp.timeIntervalSince1970 * 1000),
                        "accuracy": location.horizontalAccuracy
                    ]
                    result(locationData)
                } else {
                    result(nil)
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
