import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  ApiClient({required this.baseUrl, this.onUnauthorized});

  final String baseUrl;
  final VoidCallback? onUnauthorized;
  String? accessToken;

  Uri _uri(String path, [Map<String, String>? query]) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return Uri.parse(baseUrl).replace(path: normalized, queryParameters: query);
  }

  Map<String, String> _headers({bool json = true}) {
    final headers = <String, String>{};
    if (json) headers['Content-Type'] = 'application/json';
    final token = accessToken;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  void _checkStatusCode(int statusCode, dynamic data) {
    if (statusCode == 401) {
      // If token is invalid/expired, trigger logout
      onUnauthorized?.call();
    }
    if (statusCode < 200 || statusCode >= 300) {
      throw ApiException(statusCode, data);
    }
  }

  Future<Map<String, dynamic>> putJson(String path, Map<String, dynamic> body,
      {Map<String, String>? query}) async {
    final resp = await http.put(
      _uri(path, query),
      headers: _headers(),
      body: jsonEncode(body),
    );
    final data = resp.body.isEmpty ? {} : jsonDecode(resp.body);
    _checkStatusCode(resp.statusCode, data);
    return (data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> patchJson(String path, Map<String, dynamic> body,
      {Map<String, String>? query}) async {
    final resp = await http.patch(
      _uri(path, query),
      headers: _headers(),
      body: jsonEncode(body),
    );
    final data = resp.body.isEmpty ? {} : jsonDecode(resp.body);
    _checkStatusCode(resp.statusCode, data);
    return (data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> postJson(String path, Map<String, dynamic> body,
      {Map<String, String>? query}) async {
    final resp = await http.post(
      _uri(path, query),
      headers: _headers(),
      body: jsonEncode(body),
    );
    final data = resp.body.isEmpty ? {} : jsonDecode(resp.body);
    _checkStatusCode(resp.statusCode, data);
    return (data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required Map<String, String> fields,
    File? file,
    String fileField = 'image',
    String? contentType,
    Map<String, String>? query,
  }) async {
    final request = http.MultipartRequest('POST', _uri(path, query));
    request.headers.addAll(_headers(json: false));
    request.fields.addAll(fields);

    if (file != null) {
      final stream = http.ByteStream(file.openRead());
      final length = await file.length();
      final filename = file.path.split(Platform.pathSeparator).last;

      MediaType? mediaType;
      if (contentType != null && contentType.contains('/')) {
        final parts = contentType.split('/');
        mediaType = MediaType(parts[0], parts[1]);
      }

      request.files.add(
        http.MultipartFile(
          fileField,
          stream,
          length,
          filename: filename,
          contentType: mediaType,
        ),
      );
    }

    final streamed = await request.send();
    final resp = await http.Response.fromStream(streamed);
    final data = resp.body.isEmpty ? {} : jsonDecode(resp.body);
    _checkStatusCode(resp.statusCode, data);
    return (data as Map).cast<String, dynamic>();
  }

  Future<dynamic> getJson(String path, {Map<String, String>? query}) async {
    try {
      final uri = _uri(path, query);
      final headers = _headers();

      if (kDebugMode) {
        print('🌐 GET $uri');
        print('📋 Headers: ${headers.keys.join(", ")}');
        if (headers.containsKey('Authorization')) {
          print('🔑 Auth: ${headers['Authorization']?.substring(0, 20)}...');
        } else {
          print('⚠️ No Authorization header!');
        }
      }

      final resp = await http.get(uri, headers: headers);

      if (kDebugMode) {
        print('📥 Response: ${resp.statusCode}');
      }

      final data = resp.body.isEmpty ? null : jsonDecode(resp.body);
      _checkStatusCode(resp.statusCode, data);
      return data;
    } catch (e) {
      if (kDebugMode) {
        print('❌ API Error: $e');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteJson(String path,
      {Map<String, String>? query}) async {
    final resp = await http.delete(_uri(path, query), headers: _headers());
    final data = resp.body.isEmpty ? {} : jsonDecode(resp.body);
    _checkStatusCode(resp.statusCode, data);
    return (data as Map).cast<String, dynamic>();
  }
}

class ApiException implements Exception {
  ApiException(this.statusCode, this.body);

  final int statusCode;
  final dynamic body;

  @override
  String toString() => 'ApiException($statusCode): $body';
}
