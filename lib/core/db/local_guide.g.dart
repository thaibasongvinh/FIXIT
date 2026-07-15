// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_guide.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalGuideCollection on Isar {
  IsarCollection<LocalGuide> get localGuides => this.collection();
}

const LocalGuideSchema = CollectionSchema(
  name: r'LocalGuide',
  id: -7135266280912539580,
  properties: {
    r'description': PropertySchema(
      id: 0,
      name: r'description',
      type: IsarType.string,
    ),
    r'guideId': PropertySchema(
      id: 1,
      name: r'guideId',
      type: IsarType.string,
    ),
    r'imageUrl': PropertySchema(
      id: 2,
      name: r'imageUrl',
      type: IsarType.string,
    ),
    r'lastSync': PropertySchema(
      id: 3,
      name: r'lastSync',
      type: IsarType.dateTime,
    ),
    r'stepsJson': PropertySchema(
      id: 4,
      name: r'stepsJson',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 5,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _localGuideEstimateSize,
  serialize: _localGuideSerialize,
  deserialize: _localGuideDeserialize,
  deserializeProp: _localGuideDeserializeProp,
  idName: r'id',
  indexes: {
    r'guideId': IndexSchema(
      id: -5178184134160822963,
      name: r'guideId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'guideId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _localGuideGetId,
  getLinks: _localGuideGetLinks,
  attach: _localGuideAttach,
  version: '3.1.0+1',
);

int _localGuideEstimateSize(
  LocalGuide object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.guideId.length * 3;
  bytesCount += 3 + object.imageUrl.length * 3;
  bytesCount += 3 + object.stepsJson.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _localGuideSerialize(
  LocalGuide object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.description);
  writer.writeString(offsets[1], object.guideId);
  writer.writeString(offsets[2], object.imageUrl);
  writer.writeDateTime(offsets[3], object.lastSync);
  writer.writeString(offsets[4], object.stepsJson);
  writer.writeString(offsets[5], object.title);
}

LocalGuide _localGuideDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalGuide();
  object.description = reader.readString(offsets[0]);
  object.guideId = reader.readString(offsets[1]);
  object.id = id;
  object.imageUrl = reader.readString(offsets[2]);
  object.lastSync = reader.readDateTime(offsets[3]);
  object.stepsJson = reader.readString(offsets[4]);
  object.title = reader.readString(offsets[5]);
  return object;
}

P _localGuideDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localGuideGetId(LocalGuide object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localGuideGetLinks(LocalGuide object) {
  return [];
}

void _localGuideAttach(IsarCollection<dynamic> col, Id id, LocalGuide object) {
  object.id = id;
}

extension LocalGuideByIndex on IsarCollection<LocalGuide> {
  Future<LocalGuide?> getByGuideId(String guideId) {
    return getByIndex(r'guideId', [guideId]);
  }

  LocalGuide? getByGuideIdSync(String guideId) {
    return getByIndexSync(r'guideId', [guideId]);
  }

  Future<bool> deleteByGuideId(String guideId) {
    return deleteByIndex(r'guideId', [guideId]);
  }

  bool deleteByGuideIdSync(String guideId) {
    return deleteByIndexSync(r'guideId', [guideId]);
  }

  Future<List<LocalGuide?>> getAllByGuideId(List<String> guideIdValues) {
    final values = guideIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'guideId', values);
  }

  List<LocalGuide?> getAllByGuideIdSync(List<String> guideIdValues) {
    final values = guideIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'guideId', values);
  }

  Future<int> deleteAllByGuideId(List<String> guideIdValues) {
    final values = guideIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'guideId', values);
  }

  int deleteAllByGuideIdSync(List<String> guideIdValues) {
    final values = guideIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'guideId', values);
  }

  Future<Id> putByGuideId(LocalGuide object) {
    return putByIndex(r'guideId', object);
  }

  Id putByGuideIdSync(LocalGuide object, {bool saveLinks = true}) {
    return putByIndexSync(r'guideId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByGuideId(List<LocalGuide> objects) {
    return putAllByIndex(r'guideId', objects);
  }

  List<Id> putAllByGuideIdSync(List<LocalGuide> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'guideId', objects, saveLinks: saveLinks);
  }
}

extension LocalGuideQueryWhereSort
    on QueryBuilder<LocalGuide, LocalGuide, QWhere> {
  QueryBuilder<LocalGuide, LocalGuide, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalGuideQueryWhere
    on QueryBuilder<LocalGuide, LocalGuide, QWhereClause> {
  QueryBuilder<LocalGuide, LocalGuide, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterWhereClause> guideIdEqualTo(
      String guideId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'guideId',
        value: [guideId],
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterWhereClause> guideIdNotEqualTo(
      String guideId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'guideId',
              lower: [],
              upper: [guideId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'guideId',
              lower: [guideId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'guideId',
              lower: [guideId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'guideId',
              lower: [],
              upper: [guideId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LocalGuideQueryFilter
    on QueryBuilder<LocalGuide, LocalGuide, QFilterCondition> {
  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> guideIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'guideId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      guideIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'guideId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> guideIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'guideId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> guideIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'guideId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> guideIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'guideId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> guideIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'guideId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> guideIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'guideId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> guideIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'guideId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> guideIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'guideId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      guideIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'guideId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> imageUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      imageUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> imageUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> imageUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      imageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> imageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> imageUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> imageUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      imageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      imageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> lastSyncEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSync',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      lastSyncGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSync',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> lastSyncLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSync',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> lastSyncBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSync',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> stepsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stepsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      stepsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stepsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> stepsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stepsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> stepsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stepsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      stepsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stepsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> stepsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stepsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> stepsJsonContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stepsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> stepsJsonMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stepsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      stepsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stepsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      stepsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stepsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension LocalGuideQueryObject
    on QueryBuilder<LocalGuide, LocalGuide, QFilterCondition> {}

extension LocalGuideQueryLinks
    on QueryBuilder<LocalGuide, LocalGuide, QFilterCondition> {}

extension LocalGuideQuerySortBy
    on QueryBuilder<LocalGuide, LocalGuide, QSortBy> {
  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> sortByGuideId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guideId', Sort.asc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> sortByGuideIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guideId', Sort.desc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> sortByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> sortByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> sortByLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSync', Sort.asc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> sortByLastSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSync', Sort.desc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> sortByStepsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsJson', Sort.asc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> sortByStepsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsJson', Sort.desc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension LocalGuideQuerySortThenBy
    on QueryBuilder<LocalGuide, LocalGuide, QSortThenBy> {
  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> thenByGuideId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guideId', Sort.asc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> thenByGuideIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guideId', Sort.desc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> thenByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> thenByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> thenByLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSync', Sort.asc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> thenByLastSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSync', Sort.desc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> thenByStepsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsJson', Sort.asc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> thenByStepsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsJson', Sort.desc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension LocalGuideQueryWhereDistinct
    on QueryBuilder<LocalGuide, LocalGuide, QDistinct> {
  QueryBuilder<LocalGuide, LocalGuide, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QDistinct> distinctByGuideId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'guideId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QDistinct> distinctByImageUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QDistinct> distinctByLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSync');
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QDistinct> distinctByStepsJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stepsJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalGuide, LocalGuide, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension LocalGuideQueryProperty
    on QueryBuilder<LocalGuide, LocalGuide, QQueryProperty> {
  QueryBuilder<LocalGuide, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalGuide, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<LocalGuide, String, QQueryOperations> guideIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'guideId');
    });
  }

  QueryBuilder<LocalGuide, String, QQueryOperations> imageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageUrl');
    });
  }

  QueryBuilder<LocalGuide, DateTime, QQueryOperations> lastSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSync');
    });
  }

  QueryBuilder<LocalGuide, String, QQueryOperations> stepsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stepsJson');
    });
  }

  QueryBuilder<LocalGuide, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
