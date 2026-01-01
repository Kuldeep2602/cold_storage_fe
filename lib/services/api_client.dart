import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiClient {
  ApiClient({required this.baseUrl});

  final String baseUrl;
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

  Future<Map<String, dynamic>> putJson(String path, Map<String, dynamic> body,
      {Map<String, String>? query}) async {
    final resp = await http.put(
      _uri(path, query),
      headers: _headers(),
      body: jsonEncode(body),
    );
    final data = resp.body.isEmpty ? {} : jsonDecode(resp.body);
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw ApiException(resp.statusCode, data);
    }
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
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw ApiException(resp.statusCode, data);
    }
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
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw ApiException(resp.statusCode, data);
    }
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
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw ApiException(resp.statusCode, data);
    }
    return (data as Map).cast<String, dynamic>();
  }

  Future<dynamic> getJson(String path, {Map<String, String>? query}) async {
    final resp = await http.get(_uri(path, query), headers: _headers());
    final data = resp.body.isEmpty ? null : jsonDecode(resp.body);
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw ApiException(resp.statusCode, data);
    }
    return data;
  }
}

class ApiException implements Exception {
  ApiException(this.statusCode, this.body);

  final int statusCode;
  final dynamic body;

  @override
  String toString() => 'ApiException($statusCode): $body';
}
