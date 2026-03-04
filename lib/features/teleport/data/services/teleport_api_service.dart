import 'dart:convert';
import 'dart:typed_data';

import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/network/api_client.dart';
import 'package:shellvault/features/teleport/domain/entities/teleport_cluster_entity.dart';
import 'package:shellvault/features/teleport/domain/entities/teleport_node_entity.dart';

class TeleportCertificates {
  final Uint8List sshCert;
  final Uint8List tlsCert;
  final Uint8List privateKey;
  final DateTime expiresAt;

  TeleportCertificates({
    required this.sshCert,
    required this.tlsCert,
    required this.privateKey,
    required this.expiresAt,
  });
}

class TeleportApiService {
  final ApiClient _api;

  TeleportApiService(this._api);

  // --- Cluster CRUD ---

  Future<Result<TeleportClusterEntity>> registerCluster({
    required String name,
    required String proxyAddr,
    required String authMethod,
    Uint8List? identity,
  }) async {
    final result = await _api.post('/v1/teleport/clusters', data: {
      'name': name,
      'proxy_addr': proxyAddr,
      'auth_method': authMethod,
      if (identity != null) 'identity': base64Encode(identity),
    });

    return result.map((data) => _clusterFromJson(data));
  }

  Future<Result<List<TeleportClusterEntity>>> listClusters() async {
    final result = await _api.get('/v1/teleport/clusters');

    return result.map((data) {
      final list = (data['clusters'] as List?) ?? [];
      return list
          .map((c) => _clusterFromJson(c as Map<String, dynamic>))
          .toList();
    });
  }

  Future<Result<void>> deleteCluster(String id) async {
    final result = await _api.delete('/v1/teleport/clusters/$id');
    return result.map((_) {});
  }

  // --- Auth ---

  Future<Result<void>> login({
    required String clusterId,
    String? username,
    String? password,
    String? otpToken,
  }) async {
    final result = await _api.post(
      '/v1/teleport/clusters/$clusterId/login',
      data: {
        'username': ?username,
        'password': ?password,
        'otp_token': ?otpToken,
      },
    );
    return result.map((_) {});
  }

  // --- Nodes ---

  Future<Result<List<TeleportNodeEntity>>> listNodes(String clusterId) async {
    final result = await _api.get('/v1/teleport/clusters/$clusterId/nodes');

    return result.map((data) {
      final list = (data['nodes'] as List?) ?? [];
      return list.map((n) {
        final node = n as Map<String, dynamic>;
        return TeleportNodeEntity(
          id: node['id'] as String,
          clusterId: clusterId,
          clusterName: '',
          hostname: node['hostname'] as String,
          addr: node['addr'] as String,
          labels: (node['labels'] as Map<String, dynamic>?)
                  ?.map((k, v) => MapEntry(k, v.toString())) ??
              {},
          osType: (node['os_type'] as String?) ?? '',
        );
      }).toList();
    });
  }

  // --- Certificates ---

  Future<Result<TeleportCertificates>> generateCerts({
    required String clusterId,
    String? username,
    String? ttl,
  }) async {
    final result = await _api.post(
      '/v1/teleport/clusters/$clusterId/certs',
      data: {
        'username': ?username,
        'ttl': ?ttl,
      },
    );

    return result.map((data) {
      return TeleportCertificates(
        sshCert: base64Decode(data['ssh_cert'] as String),
        tlsCert: base64Decode(data['tls_cert'] as String),
        privateKey: base64Decode(data['private_key'] as String),
        expiresAt: DateTime.parse(data['expires_at'] as String),
      );
    });
  }

  // --- Helpers ---

  TeleportClusterEntity _clusterFromJson(Map<String, dynamic> json) {
    return TeleportClusterEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      proxyAddr: json['proxy_addr'] as String,
      authMethod: _parseAuthMethod(json['auth_method'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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
}
