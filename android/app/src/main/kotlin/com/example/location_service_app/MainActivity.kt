package com.example.location_service_app

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.location.LocationManager
import android.os.Looper
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.location_service_app/gps"
    private val PERMISSION_REQUEST_CODE = 1001

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private var locationCallback: LocationCallback? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        // MethodChannel for GPS control commands
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isGpsEnabled" -> {
                    result.success(isGpsEnabled())
                }
                "hasPermission" -> {
                    result.success(checkLocationPermission())
                }
                "requestPermission" -> {
                    if (checkLocationPermission()) {
                        result.success(true)
                    } else {
                        requestLocationPermission()
                        result.success(false)
                    }
                }
                "startGps" -> {
                    if (checkLocationPermission()) {
                        startLocationUpdates()
                        result.success(true)
                    } else {
                        requestLocationPermission()
                        result.success(false)
                    }
                }
                "stopGps" -> {
                    stopLocationUpdates()
                    result.success(true)
                }
                "getLocation" -> {
                    if (checkLocationPermission()) {
                        fusedLocationClient.lastLocation.addOnSuccessListener { location ->
                            if (location != null) {
                                val locationData = mapOf(
                                    "latitude" to location.latitude,
                                    "longitude" to location.longitude,
                                    "timestamp" to System.currentTimeMillis(),
                                    "accuracy" to location.accuracy.toDouble()
                                )
                                result.success(locationData)
                            } else {
                                // If lastLocation is null, try to return current location (or success with null)
                                result.success(null)
                            }
                        }.addOnFailureListener { e ->
                            result.error("LOCATION_ERROR", e.message, null)
                        }
                    } else {
                        result.error("PERMISSION_DENIED", "Location permission not granted", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun isGpsEnabled(): Boolean {
        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
    }

    private fun checkLocationPermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestLocationPermission() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ),
            PERMISSION_REQUEST_CODE
        )
    }

    private fun startLocationUpdates() {
        if (!checkLocationPermission()) return

        val locationRequest = LocationRequest.Builder(Priority.PRIORITY_HIGH_ACCURACY, 2000)
            .setMinUpdateIntervalMillis(2000)
            .build()

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                // We just keep the updates running so lastLocation is accurate
            }
        }

        try {
            fusedLocationClient.requestLocationUpdates(
                locationRequest,
                locationCallback!!,
                Looper.getMainLooper()
            )
        } catch (e: SecurityException) {
            // Handle error silently
        }
    }

    private fun stopLocationUpdates() {
        locationCallback?.let {
            fusedLocationClient.removeLocationUpdates(it)
            locationCallback = null
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                startLocationUpdates()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        stopLocationUpdates()
    }
}
