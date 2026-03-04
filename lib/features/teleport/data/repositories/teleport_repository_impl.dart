import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/teleport/data/datasources/teleport_cluster_dao.dart';
import 'package:shellvault/features/teleport/data/services/teleport_api_service.dart';
import 'package:shellvault/features/teleport/domain/entities/teleport_cluster_entity.dart';
import 'package:shellvault/features/teleport/domain/entities/teleport_node_entity.dart';
import 'package:shellvault/features/teleport/domain/repositories/teleport_repository.dart';

class TeleportRepositoryImpl implements TeleportRepository {
  final TeleportClusterDao _dao;
  final TeleportApiService _api;

  TeleportRepositoryImpl({
    required TeleportClusterDao dao,
    required TeleportApiService api,
  })  : _dao = dao,
        _api = api;

  // --- Local ---

  @override
  Future<List<TeleportClusterEntity>> getLocalClusters() async {
    final rows = await _dao.getAllClusters();
    return rows.map(_entityFromRow).toList();
  }

  @override
  Stream<List<TeleportClusterEntity>> watchLocalClusters() {
    return _dao.watchAllClusters().map(
      (rows) => rows.map(_entityFromRow).toList(),
    );
  }

  @override
  Future<void> saveClusterLocally(TeleportClusterEntity cluster) async {
    final companion = TeleportClustersCompanion(
      id: Value(cluster.id),
      name: Value(cluster.name),
      proxyAddr: Value(cluster.proxyAddr),
      authMethod: Value(_authMethodToString(cluster.authMethod)),
      username: Value(cluster.username),
      metadata: Value(jsonEncode(cluster.metadata)),
      certExpiresAt: Value(cluster.certExpiresAt),
      createdAt: Value(cluster.createdAt),
      updatedAt: Value(cluster.updatedAt),
    );

    final existing = await _dao.getClusterById(cluster.id);
    if (existing != null) {
      await _dao.updateCluster(companion);
    } else {
      await _dao.insertCluster(companion);
    }
  }

  @override
  Future<void> deleteClusterLocally(String id) async {
    await _dao.deleteClusterById(id);
  }

  @override
  Future<void> updateCertExpiry(String id, DateTime? expiresAt) async {
    await _dao.updateCertExpiry(id, expiresAt);
  }

  // --- Remote ---

  @override
  Future<Result<TeleportClusterEntity>> registerCluster({
    required String name,
    required String proxyAddr,
    required String authMethod,
    Uint8List? identity,
  }) async {
    return _api.registerCluster(
      name: name,
      proxyAddr: proxyAddr,
      authMethod: authMethod,
      identity: identity,
    );
  }

  @override
  Future<Result<List<TeleportClusterEntity>>> fetchClusters() async {
    return _api.listClusters();
  }

  @override
  Future<Result<void>> deleteCluster(String id) async {
    return _api.deleteCluster(id);
  }

  @override
  Future<Result<void>> login({
    required String clusterId,
    String? username,
    String? password,
    String? otpToken,
  }) async {
    return _api.login(
      clusterId: clusterId,
      username: username,
      password: password,
      otpToken: otpToken,
    );
  }

  @override
  Future<Result<List<TeleportNodeEntity>>> fetchNodes(String clusterId) async {
    return _api.listNodes(clusterId);
  }

  @override
  Future<Result<TeleportCertificates>> generateCerts({
    required String clusterId,
    String? username,
    String? ttl,
  }) async {
    return _api.generateCerts(
      clusterId: clusterId,
      username: username,
      ttl: ttl,
    );
  }

  // --- Mappers ---

  TeleportClusterEntity _entityFromRow(TeleportCluster row) {
    Map<String, dynamic> metadata = {};
    try {
      metadata = jsonDecode(row.metadata) as Map<String, dynamic>;
    } catch (_) {}

    return TeleportClusterEntity(
      id: row.id,
      name: row.name,
      proxyAddr: row.proxyAddr,
      authMethod: _parseAuthMethod(row.authMethod),
      username: row.username,
      metadata: metadata,
      certExpiresAt: row.certExpiresAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static TeleportAuthMethod _parseAuthMethod(String method) {
    return switch (method) {
      'sso_oidc' => TeleportAuthMethod.ssoOidc,
      'sso_saml' => TeleportAuthMethod.ssoSaml,
      'identity_file' => TeleportAuthMethod.identityFile,
      _ => TeleportAuthMethod.local,
    };
  }

  static String _authMethodToString(TeleportAuthMethod method) {
    return switch (method) {
      TeleportAuthMethod.local => 'local',
      TeleportAuthMethod.ssoOidc => 'sso_oidc',
      TeleportAuthMethod.ssoSaml => 'sso_saml',
      TeleportAuthMethod.identityFile => 'identity_file',
    };
  }
}
