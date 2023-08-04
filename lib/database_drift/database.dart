import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';


part 'database.g.dart';

class Movies extends Table {
  @JsonKey('local_id')
  IntColumn get id => integer().autoIncrement().nullable()();
  @JsonKey('id')
  IntColumn get serverId => integer().nullable().unique()();
  @JsonKey('adult')
  BoolColumn get adult => boolean().nullable()();
  @JsonKey('backdrop_path')
  TextColumn get backdropPath => text().nullable()();
  @JsonKey('title')
  TextColumn get title => text().nullable()();
  @JsonKey('original_title')
  TextColumn get originalTitle => text().nullable()();
  @JsonKey('overview')
  TextColumn get overview => text().nullable()();
  @JsonKey('poster_path')
  TextColumn get posterPath => text().nullable()();
  @JsonKey('media_type')
  TextColumn get mediaType => text().nullable()();
  @JsonKey('release_date')
  TextColumn get releaseDate => text().nullable()();
  @JsonKey('vote_average')
  RealColumn get voteAverage => real().nullable()();
  @JsonKey('popularity')
  RealColumn get popularity => real().nullable()();
}

class SortPreferences extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get value => text()();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}


@DriftDatabase(tables: [Movies, SortPreferences])
class AppDatabase extends _$AppDatabase {
  // AppDatabase() : super(_openConnection());

    AppDatabase._privateConstructor() : super(_openConnection());

  static final AppDatabase _instance = AppDatabase._privateConstructor();

  factory AppDatabase(){
    return _instance;
  }

  @override
  int get schemaVersion => 1;

    //INSERT INTO DB
    Future<int> insertMovie(MoviesCompanion moviesCompanion) async {
      return await into(movies).insert(moviesCompanion);
    }
  Stream<List<Movie>> watchMoviesInDb() {
    return select(movies).watch();
  }

    Stream<Movie> watchMovieByIdInDb(int serverId) {
      return (select(movies)..where((t) => t.serverId.equals(serverId))).watchSingle();
    }

    Future<int> removeFromFavourite(int serverId) async {
      return (delete(movies)..where((t) => t.serverId.equals(serverId))).go();
    }


    //INSERT INTO DB
    Future<int> insertSortPreference(SortPreferencesCompanion sortPreference) async {
      return await into(sortPreferences).insert(sortPreference);
    }
    //DELETE FROM DATABASE
    Future<int> deleteSortPreferences() async {
      return await delete(sortPreferences).go();
    }
    //INSERT INTO DB
    Future<List<SortPreference>> fetchSortPreference() async {
      return await select(sortPreferences).get();
    }
}