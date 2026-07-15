import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

void main() async {
  final String endpoint = 'https://sgp.cloud.appwrite.io/v1';
  final String projectId = '6a145b8d001aa82f4dd5';
  final String apiKey = 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
  
  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Storage storage = Storage(client);

  final List<String> expectedFiles = [
    'Interior.png', 'Exterior.png', 'Wall.png', 'Dish wash.png', 'Shelving.png',
    'Loading.png', 'Cutting.png', 'Plumber.png', 'Pliers.png', 'Multimeter.png',
    'Electricity Meter.png', 'Mopping.png', 'Solar.png', 'Solar Energy.png',
    'Car Wash.png', 'Car Waxing.png', 'Laundry.png', 'Mop.png', 'Spin Mop.png',
    'Painter Roller.png', 'Painter Ladder.png', 'Cctv (1).png', 'Oil change.png',
    'Car battery.png', 'Pipe Wrench.png', 'CCTV.png', 'Door.png', 'Furniture.png',
    'Water Tap.png', 'Plumbing Pipe.png', 'Air Conditioner.png', 'Drilling.png'
  ];

  try {
    print('--- STORAGE VERIFICATION (Checking for 32 specific files) ---');
    
    var filesResult = await storage.listFiles(bucketId: 'fixit_assets', queries: [Query.limit(200)]);
    Set<String> actualFiles = filesResult.files.map((f) => f.name).toSet();

    int foundCount = 0;
    List<String> missing = [];

    for (var name in expectedFiles) {
      if (actualFiles.contains(name)) {
        foundCount++;
        print('[FOUND] $name');
      } else {
        missing.add(name);
        print('[NOT FOUND] $name');
      }
    }

    print('\n--- FINAL VERIFICATION RESULT ---');
    print('Expected: ${expectedFiles.length} files');
    print('Actual Found: $foundCount files');
    
    if (missing.isEmpty) {
      print('STATUS: SUCCESS - All 32 files exist in Storage with the correct names.');
    } else {
      print('STATUS: FAIL - Missing ${missing.length} files.');
      print('Missing files: ${missing.join(", ")}');
    }

  } catch (e) {
    print('Error: $e');
  }
}
