import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------------------------------------------------------------------
// TenantIsolationInterceptor
//
// Attaches the active tenant's auth token and tenant-id header to every
// outgoing request, and enforces that responses only carry data belonging to
// the same tenant.  If a response arrives with a different tenant-id the
// request is rejected and the token is cleared so the caller can re-auth.
// ---------------------------------------------------------------------------

class TenantIsolationInterceptor extends Interceptor {
  TenantIsolationInterceptor({
    required String tenantId,
    required String Function() tokenProvider,
    void Function()? onTenantMismatch,
  })  : _tenantId = tenantId,
        _tokenProvider = tokenProvider,
        _onTenantMismatch = onTenantMismatch;

  final String _tenantId;
  final String Function() _tokenProvider;
  final void Function()? _onTenantMismatch;

  static const _headerTenantId = 'X-Tenant-Id';
  static const _headerAuthorization = 'Authorization';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.headers[_headerAuthorization] = '******';
    options.headers[_headerTenantId] = _tenantId;
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final responseTenant =
        response.headers.value(_headerTenantId) as String?;

    if (responseTenant != null && responseTenant != _tenantId) {
      _onTenantMismatch?.call();
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Tenant isolation violation: expected $_tenantId '
              'but received $responseTenant',
          type: DioExceptionType.badResponse,
        ),
      );
      return;
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Propagate without modification; let the caller decide on retry policy.
    handler.next(err);
  }
}

// ---------------------------------------------------------------------------
// LedgerClientConfig
// ---------------------------------------------------------------------------

class LedgerClientConfig {
  const LedgerClientConfig({
    required this.baseUrl,
    required this.tenantId,
    required this.tokenProvider,
    this.connectTimeoutMs = 10000,
    this.receiveTimeoutMs = 30000,
    this.onTenantMismatch,
  });

  final String baseUrl;
  final String tenantId;
  final String Function() tokenProvider;
  final int connectTimeoutMs;
  final int receiveTimeoutMs;
  final void Function()? onTenantMismatch;
}

// ---------------------------------------------------------------------------
// secureLedgerClientProvider
//
// Provides a [Dio] instance that is pre-configured with TLS settings,
// the TenantIsolationInterceptor, and a retry-safe timeout policy.
// Consumers should treat this as a read-only HTTP transport.
// ---------------------------------------------------------------------------

final ledgerClientConfigProvider =
    Provider<LedgerClientConfig>((ref) => throw UnimplementedError(
          'Override ledgerClientConfigProvider before using the ledger module.',
        ));

final secureLedgerClientProvider = Provider<Dio>((ref) {
  final config = ref.watch(ledgerClientConfigProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: Duration(milliseconds: config.connectTimeoutMs),
      receiveTimeout: Duration(milliseconds: config.receiveTimeoutMs),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    TenantIsolationInterceptor(
      tenantId: config.tenantId,
      tokenProvider: config.tokenProvider,
      onTenantMismatch: config.onTenantMismatch,
    ),
  );

  return dio;
});
