import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:latlong2/latlong.dart';

class PolygonPage extends StatefulWidget {
  const PolygonPage({super.key});

  @override
  State<PolygonPage> createState() => _PolygonPageState();
}

class _PolygonPageState extends State<PolygonPage> {
  late PolyEditor polyEditor;

  final polygons = <Polygon>[];
  final testPolygon = Polygon(
    color: Colors.deepOrange,
    isFilled: true,
    points: [],
  );

  @override
  void initState() {
    super.initState();

    polyEditor = PolyEditor(
      addClosePathMarker: true,
      points: testPolygon.points,
      pointIcon: const Icon(Icons.crop_square, size: 23),
      intermediateIcon: const Icon(Icons.lens, size: 15, color: Colors.grey),
      callbackRefresh: (LatLng? _) => {setState(() {})},
    );

    polygons.add(testPolygon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Polygon example')),
      body: FlutterMap(
        options: MapOptions(
          onTap: (_, ll) {
            polyEditor.add(testPolygon.points, ll);
          },
          // For backwards compatibility with pre v5 don't use const
          // ignore: prefer_const_constructors
          initialCenter: LatLng(45.5231, -122.6765),
          initialZoom: 10,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          PolygonLayer(polygons: polygons),
          DragMarkers(markers: polyEditor.edit()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.replay),
        onPressed: () {
          setState(() {
            testPolygon.points.clear();
          });
        },
      ),
    );
  }
}
