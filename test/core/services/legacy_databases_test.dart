// import 'package:fixit/core/services/legacy_databases.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// void main() {
//   group('LegacyDatabases payload normalization', () {
//     test('moves top-level legacy document fields into data', () {
//       final normalized = normalizeLegacyDocumentPayload({
//         r'$id': 'pop_plumber',
//         r'$sequence': '1',
//         r'$collectionId': 'popular_services',
//         r'$databaseId': 'database-default',
//         r'$createdAt': '2026-06-18T04:47:54.874+00:00',
//         r'$updatedAt': '2026-06-18T04:47:54.874+00:00',
//         r'$permissions': const ['read("any")'],
//         'title': 'Plumber',
//         'imagePath': 'assets/images/Plumber.png',
//         'isActive': true,
//       });
//
//       expect(normalized['data'], {
//         'title': 'Plumber',
//         'imagePath': 'assets/images/Plumber.png',
//         'isActive': true,
//       });
//       expect(normalized['data'], isNot(contains(r'$id')));
//     });
//
//     test('keeps SDK-shaped data when it is already present', () {
//       final normalized = normalizeLegacyDocumentPayload({
//         r'$id': 'pop_plumber',
//         'title': 'Top-level title',
//         'data': {'title': 'Nested title'},
//       });
//
//       expect(normalized['data'], {'title': 'Nested title'});
//     });
//
//     test('normalizes every document in a list payload', () {
//       final normalized = normalizeLegacyDocumentListPayload({
//         'total': 2,
//         'documents': [
//           {
//             r'$id': 'pop_plumber',
//             'title': 'Plumber',
//           },
//           {
//             r'$id': 'svc_pipe_wrench',
//             'title': 'Pipe Wrench',
//             'parentId': 'pop_plumber',
//           },
//         ],
//       });
//
//       expect(normalized['total'], 2);
//       expect(normalized['documents'], hasLength(2));
//       expect(normalized['documents'][0]['data'], {'title': 'Plumber'});
//       expect(normalized['documents'][1]['data'], {
//         'title': 'Pipe Wrench',
//         'parentId': 'pop_plumber',
//       });
//     });
//   });
// }
