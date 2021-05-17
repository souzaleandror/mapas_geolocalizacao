import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polylines = {};
  LatLng latlng;
  CameraPosition posicaoCamera = CameraPosition(
    target: LatLng(-23.562436, -46.655055),
    zoom: 16,
  );

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(-23.562436, -46.655055),
          zoom: 19,
          tilt: 0,
          bearing: 150,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _carregarMarcadores();
    // _carregarPolygon();
    // _carregarPolylines();
    _recuperarLocalizacaoAtual();
    _adicionarListenerLocalizacao();
    //_recuperarLocalParaEndereco();
    //_recuperarLocalParaEnderecoLatLong();
  }

  _recuperarLocalParaEnderecoLatLong() async {
    List<Location> listaEnderecos =
        await locationFromAddress("Av. Paulista, 1372");

    print("Total: " + listaEnderecos.length.toString());

    if (listaEnderecos != null && listaEnderecos.length > 0) {
      Location endereco = listaEnderecos[0];

      List<Placemark> placemarks =
          await placemarkFromCoordinates(endereco.latitude, endereco.longitude);

      Placemark localizacao = placemarks[0];

      String resultado;

      resultado = "\n administrativeArea " + localizacao.administrativeArea;
      resultado +=
          "\n subAdministrativeArea " + localizacao.subAdministrativeArea;
      resultado += "\n locality " + localizacao.locality;
      resultado += "\n sublocality " + localizacao.subLocality;
      resultado += "\n thoroughfare " + localizacao.thoroughfare;
      resultado += "\n subThoroughfare " + localizacao.subThoroughfare;
      resultado += "\n postalCode " + localizacao.postalCode;
      resultado += "\n country " + localizacao.country;
      resultado += "\n isoCountryCode " + localizacao.isoCountryCode;
      resultado += "\n name " + localizacao.name;
      resultado += "\n Latlng " +
          endereco.latitude.toString() +
          " " +
          endereco.longitude.toString();

      print("resultado 1: " + resultado);
    }
  }

  _recuperarLocalParaEndereco() async {
    List<Location> listaEnderecos =
        await locationFromAddress("Av. Paulista, 1372");

    print("Total: " + listaEnderecos.length.toString());

    if (listaEnderecos != null && listaEnderecos.length > 0) {
      Location endereco = listaEnderecos[0];

      List<Placemark> placemarks =
          await placemarkFromCoordinates(endereco.latitude, endereco.longitude);

      Placemark localizacao = placemarks[0];

      String resultado;

      resultado = "\n administrativeArea " + localizacao.administrativeArea;
      resultado +=
          "\n subAdministrativeArea " + localizacao.subAdministrativeArea;
      resultado += "\n locality " + localizacao.locality;
      resultado += "\n sublocality " + localizacao.subLocality;
      resultado += "\n thoroughfare " + localizacao.thoroughfare;
      resultado += "\n subThoroughfare " + localizacao.subThoroughfare;
      resultado += "\n postalCode " + localizacao.postalCode;
      resultado += "\n country " + localizacao.country;
      resultado += "\n isoCountryCode " + localizacao.isoCountryCode;
      resultado += "\n name " + localizacao.name;
      resultado += "\n Latlng " +
          endereco.latitude.toString() +
          " " +
          endereco.longitude.toString();

      print("resultado 1: " + resultado);
    }
  }

  _movimentarCameraParaUsuario() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(posicaoCamera),
    );
  }

  _recuperarLocalizacaoAtual() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    Set<Marker> marcadoresLocal = {};
    LatLng temp = LatLng(position.latitude, position.longitude);

    Marker outroMarcador = Marker(
      markerId: MarkerId('Usuario'),
      position: temp,
      infoWindow: InfoWindow(
        title: 'Usuario',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      ),
      onTap: () {
        print('cartorio clicado');
      },
    );

    marcadoresLocal.add(outroMarcador);

    setState(() {
      //latlng = temp;
      _marcadores = marcadoresLocal;
      posicaoCamera = CameraPosition(target: temp, zoom: 16);
      _movimentarCameraParaUsuario();
    });
  }

  _adicionarListenerLocalizacao() {
    Geolocator geolocator = Geolocator();
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    Geolocator.getPositionStream(
      distanceFilter: 10,
      desiredAccuracy: LocationAccuracy.high,
    ).listen(
      (Position position) {
        print(position);

        setState(
          () {
            posicaoCamera = CameraPosition(
              target: LatLng(
                position.latitude,
                position.longitude,
              ),
              zoom: 16,
            );
            _movimentarCameraParaUsuario();
          },
        );
      },
    );
  }

  void _carregarPolylines() async {
    Set<Polyline> listaPolygon = {};
    Polyline polygon = Polyline(
      polylineId: PolylineId('Polyline1'),
      color: Colors.blue,
      width: 40,
      startCap: Cap.roundCap,
      endCap: Cap.buttCap,
      jointType: JointType.round,
      consumeTapEvents: true,
      onTap: () {
        print('_carregarPolylines');
      },
      points: [
        LatLng(-23.563645, -46.653642),
        LatLng(-23.565064, -46.650778),
        LatLng(-23.563232, -46.648020),
      ],
    );

    listaPolygon.add(polygon);

    setState(() {
      _polylines = listaPolygon;
    });
  }

  void _carregarPolygon() async {
    Set<Polygon> listaPolygon = {};
    Polygon polygon = Polygon(
      polygonId: PolygonId('Polygon1'),
      fillColor: Colors.green,
      strokeColor: Colors.red,
      strokeWidth: 10,
      consumeTapEvents: true,
      onTap: () {
        print('_carregarPolygon');
      },
      points: [
        LatLng(-23.561816, -46.652044),
        LatLng(-23.563625, -46.653642),
        LatLng(-23.564786, -46.652226),
        LatLng(-23.563085, -46.650531),
      ],
      zIndex: 0,
    );

    Polygon polygon2 = Polygon(
        polygonId: PolygonId('Polygon1'),
        fillColor: Colors.deepOrange,
        strokeColor: Colors.orange,
        strokeWidth: 10,
        consumeTapEvents: true,
        onTap: () {
          print('_carregarPolygon2');
        },
        points: [
          LatLng(-23.561629, -46.653031),
          LatLng(-23.565189, -46.651872),
          LatLng(-23.562032, -46.650831),
        ],
        zIndex: 1);

    listaPolygon.add(polygon);
    listaPolygon.add(polygon2);

    setState(() {
      _polygons = listaPolygon;
    });
  }

  void _carregarMarcadores() async {
    Set<Marker> marcadoresLocal = {};
    Marker marcadorShopping = Marker(
      markerId: MarkerId('Marcador-Shopping'),
      position: LatLng(
        -23.563370,
        -46.655055,
      ),
      infoWindow: InfoWindow(
        title: 'Shopping Cidade Sao Paulo',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      ),
      rotation: 45,
      onTap: () {
        print('Shopping clicado');
      },
    );
    Marker outroMarcador = Marker(
      markerId: MarkerId('Marcador-Cartorio'),
      position: LatLng(-23.562868, -46.655055),
      infoWindow: InfoWindow(
        title: 'Shopping Cidade Sao Paulo',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueViolet,
      ),
      rotation: 90,
      onTap: () {
        print('cartorio clicado');
      },
    );
    marcadoresLocal.add(marcadorShopping);
    marcadoresLocal.add(outroMarcador);

    setState(() {
      _marcadores = marcadoresLocal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapas e geolocalizacao'),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: posicaoCamera,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        markers: _marcadores,
        polygons: _polygons,
        polylines: _polylines,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: _movimentarCamera,
      ),
    );
  }
}
