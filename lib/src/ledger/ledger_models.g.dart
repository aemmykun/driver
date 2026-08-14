// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocalEntryImpl _$$LocalEntryImplFromJson(Map<String, dynamic> json) =>
    _$LocalEntryImpl(
      localEntryId: json['localEntryId'] as String,
      tenantId: json['tenantId'] as String,
      receiptId: json['receiptId'] as String,
      platform: json['platform'] as String,
      grossAmount: (json['grossAmount'] as num).toDouble(),
      currency: json['currency'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: $enumDecodeNullable(_$LedgerEntryStatusEnumMap, json['status']) ??
          LedgerEntryStatus.pending,
    );

Map<String, dynamic> _$$LocalEntryImplToJson(_$LocalEntryImpl instance) =>
    <String, dynamic>{
      'localEntryId': instance.localEntryId,
      'tenantId': instance.tenantId,
      'receiptId': instance.receiptId,
      'platform': instance.platform,
      'grossAmount': instance.grossAmount,
      'currency': instance.currency,
      'timestamp': instance.timestamp.toIso8601String(),
      'status': _$LedgerEntryStatusEnumMap[instance.status]!,
    };

_$CommittedEntryImpl _$$CommittedEntryImplFromJson(Map<String, dynamic> json) =>
    _$CommittedEntryImpl(
      committedEntryId: json['committedEntryId'] as String,
      localEntryId: json['localEntryId'] as String,
      tenantId: json['tenantId'] as String,
      receiptId: json['receiptId'] as String,
      platform: json['platform'] as String,
      grossAmount: (json['grossAmount'] as num).toDouble(),
      currency: json['currency'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      committedAt: DateTime.parse(json['committedAt'] as String),
      isLocked: json['isLocked'] as bool? ?? false,
    );

Map<String, dynamic> _$$CommittedEntryImplToJson(
        _$CommittedEntryImpl instance) =>
    <String, dynamic>{
      'committedEntryId': instance.committedEntryId,
      'localEntryId': instance.localEntryId,
      'tenantId': instance.tenantId,
      'receiptId': instance.receiptId,
      'platform': instance.platform,
      'grossAmount': instance.grossAmount,
      'currency': instance.currency,
      'timestamp': instance.timestamp.toIso8601String(),
      'committedAt': instance.committedAt.toIso8601String(),
      'isLocked': instance.isLocked,
    };

_$LedgerStateImpl _$$LedgerStateImplFromJson(Map<String, dynamic> json) =>
    _$LedgerStateImpl(
      localEntries: (json['localEntries'] as List<dynamic>?)
              ?.map((e) => LocalEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      committedEntries: (json['committedEntries'] as List<dynamic>?)
              ?.map((e) => CommittedEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isSyncing: json['isSyncing'] as bool? ?? false,
      lastError: json['lastError'] as String?,
    );

Map<String, dynamic> _$$LedgerStateImplToJson(_$LedgerStateImpl instance) =>
    <String, dynamic>{
      'localEntries': instance.localEntries.map((e) => e.toJson()).toList(),
      'committedEntries':
          instance.committedEntries.map((e) => e.toJson()).toList(),
      'isSyncing': instance.isSyncing,
      'lastError': instance.lastError,
    };

const _$LedgerEntryStatusEnumMap = {
  LedgerEntryStatus.pending: 'pending',
  LedgerEntryStatus.syncing: 'syncing',
  LedgerEntryStatus.committed: 'committed',
  LedgerEntryStatus.locked: 'locked',
};
