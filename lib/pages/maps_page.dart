import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/nearby_places.dart';
import 'package:movie_app/widgets/maps_page/custom_modal_bottom_sheet.dart';
import 'package:movie_app/widgets/text/desc_text.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final double _radius = 30000;
  final double _zoom = 12.5;
  Set<Marker> _markers = <Marker>{};
  LatLng _currentLocation = const LatLng(0.0, 0.0);
  LocationPermission _permission = LocationPermission.denied;
  bool _serviceEnabled = false;

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  getCurrentLocation() async {
    await _determinePosition().then((value) {
      _currentLocation = LatLng(
        value.latitude,
        value.longitude,
      );
      setState(() {});
    }).onError((error, stackTrace) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Geolocator.getServiceStatusStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            ServiceStatus serviceStatus = snapshot.data as ServiceStatus;
            if (serviceStatus == ServiceStatus.enabled) {
              return locationServicesOn();
            } else {
              return locationServicesOff();
            }
          } else {
            return _serviceEnabled
                ? locationServicesOn()
                : locationServicesOff();
          }
        },
      ),
    );
  }

  locationOnGoogleMaps() {
    return FutureBuilder(
      future: ApiClient().getNearbyPlaces(
          _currentLocation.latitude, _currentLocation.longitude, _radius),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          NearbyPlaces _nearbyPlacesList = snapshot.data as NearbyPlaces;

          if (_nearbyPlacesList.results != null) {
            for (var element in _nearbyPlacesList.results!) {
              _markers.add(
                Marker(
                  onTap: () {
                    String _photoreference = "";
                    try {
                      _photoreference =
                          element.photos?.first.photoReference ?? "";
                    } catch (e) {}
                    showModalBottomSheet(
                      barrierColor: Colors.transparent,
                      enableDrag: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => CustomModalBottomSheet(
                        placeName: element.name ?? "",
                        vicinity: element.vicinity ?? "",
                        rating: element.rating ?? 0,
                        photoReference: _photoreference,
                        placeId: element.placeId ?? "",
                        lat: element.geometry!.location!.lat ?? 0,
                        lng: element.geometry!.location!.lng ?? 0,
                      ),
                    );
                  },
                  // infoWindow: InfoWindow(title: "asdaddasd"),
                  markerId: MarkerId(element.placeId ?? ""),
                  position: LatLng(
                    element.geometry!.location!.lat ?? 0,
                    element.geometry!.location!.lng ?? 0,
                  ),
                ),
              );
            }

            return GoogleMap(
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                  () => new EagerGestureRecognizer(),
                ),
              ].toSet(),
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: _zoom,
              ),
              markers: _markers,
              circles: {
                Circle(
                  circleId: const CircleId("1"),
                  center: _currentLocation,
                  radius: _radius,
                  strokeWidth: 1,
                  fillColor: Colors.cyan.withOpacity(0.1),
                  strokeColor: Colors.black,
                ),
              },
            );
          } else {
            return GoogleMap(
              padding: EdgeInsets.all(12),
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: _zoom,
              ),
              circles: {
                Circle(
                  circleId: const CircleId("1"),
                  center: _currentLocation,
                  radius: _radius,
                  strokeWidth: 1,
                  fillColor: Colors.cyan.withOpacity(0.1),
                  strokeColor: Colors.black,
                ),
              },
            );
          }
        } else {
          return Center(
            child: DescText(description: "Konumlar Aranıyor..."),
          );
        }
      },
    );
  }

  locationServicesOff() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Devam Etmek İçin Konum Servislerini Aktifleştirmeniz Gerekmektedir.",
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: () async {
              await Geolocator.openLocationSettings().then((value) async {
                _serviceEnabled = await Geolocator.isLocationServiceEnabled();
              });
              setState(() {});
            },
            child: Text("Konum Servisini Etkinleştir"),
          ),
        ],
      ),
    );
  }

  locationServicesOn() {
    return _permission == LocationPermission.always ||
            _permission == LocationPermission.whileInUse
        ? locationOnGoogleMaps()
        : locationOff();
  }

  locationOff() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Lütfen Konum İzinlerini Veriniz"),
          ElevatedButton(
            onPressed: () async {
              await _determinePosition().then((value) {
                _currentLocation = LatLng(
                  value.latitude,
                  value.longitude,
                );
                setState(() {});
              }).onError((error, stackTrace) async {
                if (error ==
                    LocationErrors.locationPermissionsArepermanentlyDenied) {
                  await Geolocator.openAppSettings().then((value) async {
                    _permission = await Geolocator.checkPermission();
                  });
                }
              });
            },
            child: Text("Konum İzni Ver"),
          ),
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      return Future.error(LocationErrors.locationServicesAreDisabled);
    }

    _permission = await Geolocator.checkPermission();

    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        return Future.error(LocationErrors.locationPermissionsAreDenied);
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      return Future.error(
          LocationErrors.locationPermissionsArepermanentlyDenied);
    }

    return await Geolocator.getCurrentPosition();
  }
}
