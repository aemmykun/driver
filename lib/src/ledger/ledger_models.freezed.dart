// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. '
    'This constructor is only meant to be used by freezed and you are not '
    'supposed to need it nor use it.\nPlease check the documentation here for '
    'more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LocalEntry {
  String get localEntryId => throw _privateConstructorUsedError;
  String get tenantId => throw _privateConstructorUsedError;
  String get receiptId => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  double get grossAmount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  LedgerEntryStatus get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocalEntryCopyWith<LocalEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalEntryCopyWith<$Res> {
  factory $LocalEntryCopyWith(
          LocalEntry value, $Res Function(LocalEntry) then) =
      _$LocalEntryCopyWithImpl<$Res, LocalEntry>;
  @useResult
  $Res call({
    String localEntryId,
    String tenantId,
    String receiptId,
    String platform,
    double grossAmount,
    String currency,
    DateTime timestamp,
    LedgerEntryStatus status,
  });
}

/// @nodoc
class _$LocalEntryCopyWithImpl<$Res, $Val extends LocalEntry>
    implements $LocalEntryCopyWith<$Res> {
  _$LocalEntryCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localEntryId = null,
    Object? tenantId = null,
    Object? receiptId = null,
    Object? platform = null,
    Object? grossAmount = null,
    Object? currency = null,
    Object? timestamp = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      localEntryId: null == localEntryId
          ? _value.localEntryId
          : localEntryId as String,
      tenantId: null == tenantId ? _value.tenantId : tenantId as String,
      receiptId: null == receiptId ? _value.receiptId : receiptId as String,
      platform: null == platform ? _value.platform : platform as String,
      grossAmount:
          null == grossAmount ? _value.grossAmount : grossAmount as double,
      currency: null == currency ? _value.currency : currency as String,
      timestamp: null == timestamp ? _value.timestamp : timestamp as DateTime,
      status: null == status ? _value.status : status as LedgerEntryStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocalEntryImplCopyWith<$Res>
    implements $LocalEntryCopyWith<$Res> {
  factory _$$LocalEntryImplCopyWith(
          _$LocalEntryImpl value, $Res Function(_$LocalEntryImpl) then) =
      __$$LocalEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String localEntryId,
    String tenantId,
    String receiptId,
    String platform,
    double grossAmount,
    String currency,
    DateTime timestamp,
    LedgerEntryStatus status,
  });
}

/// @nodoc
class __$$LocalEntryImplCopyWithImpl<$Res>
    extends _$LocalEntryCopyWithImpl<$Res, _$LocalEntryImpl>
    implements _$$LocalEntryImplCopyWith<$Res> {
  __$$LocalEntryImplCopyWithImpl(
      _$LocalEntryImpl _value, $Res Function(_$LocalEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localEntryId = null,
    Object? tenantId = null,
    Object? receiptId = null,
    Object? platform = null,
    Object? grossAmount = null,
    Object? currency = null,
    Object? timestamp = null,
    Object? status = null,
  }) {
    return _then(_$LocalEntryImpl(
      localEntryId: null == localEntryId
          ? _value.localEntryId
          : localEntryId as String,
      tenantId: null == tenantId ? _value.tenantId : tenantId as String,
      receiptId: null == receiptId ? _value.receiptId : receiptId as String,
      platform: null == platform ? _value.platform : platform as String,
      grossAmount:
          null == grossAmount ? _value.grossAmount : grossAmount as double,
      currency: null == currency ? _value.currency : currency as String,
      timestamp: null == timestamp ? _value.timestamp : timestamp as DateTime,
      status: null == status ? _value.status : status as LedgerEntryStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocalEntryImpl implements _LocalEntry {
  const _$LocalEntryImpl({
    required this.localEntryId,
    required this.tenantId,
    required this.receiptId,
    required this.platform,
    required this.grossAmount,
    required this.currency,
    required this.timestamp,
    this.status = LedgerEntryStatus.pending,
  });

  factory _$LocalEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocalEntryImplFromJson(json);

  @override
  final String localEntryId;
  @override
  final String tenantId;
  @override
  final String receiptId;
  @override
  final String platform;
  @override
  final double grossAmount;
  @override
  final String currency;
  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final LedgerEntryStatus status;

  @override
  String toString() {
    return 'LocalEntry(localEntryId: $localEntryId, tenantId: $tenantId, '
        'receiptId: $receiptId, platform: $platform, grossAmount: $grossAmount, '
        'currency: $currency, timestamp: $timestamp, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalEntryImpl &&
            (identical(other.localEntryId, localEntryId) ||
                other.localEntryId == localEntryId) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.receiptId, receiptId) ||
                other.receiptId == receiptId) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.grossAmount, grossAmount) ||
                other.grossAmount == grossAmount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, localEntryId, tenantId,
      receiptId, platform, grossAmount, currency, timestamp, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalEntryImplCopyWith<_$LocalEntryImpl> get copyWith =>
      __$$LocalEntryImplCopyWithImpl<_$LocalEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocalEntryImplToJson(this);
  }
}

abstract class _LocalEntry implements LocalEntry {
  const factory _LocalEntry({
    required final String localEntryId,
    required final String tenantId,
    required final String receiptId,
    required final String platform,
    required final double grossAmount,
    required final String currency,
    required final DateTime timestamp,
    final LedgerEntryStatus status,
  }) = _$LocalEntryImpl;

  factory _LocalEntry.fromJson(Map<String, dynamic> json) =
      _$LocalEntryImpl.fromJson;

  @override
  String get localEntryId;
  @override
  String get tenantId;
  @override
  String get receiptId;
  @override
  String get platform;
  @override
  double get grossAmount;
  @override
  String get currency;
  @override
  DateTime get timestamp;
  @override
  LedgerEntryStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$LocalEntryImplCopyWith<_$LocalEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// ---------------------------------------------------------------------------
// CommittedEntry
// ---------------------------------------------------------------------------

/// @nodoc
mixin _$CommittedEntry {
  String get committedEntryId => throw _privateConstructorUsedError;
  String get localEntryId => throw _privateConstructorUsedError;
  String get tenantId => throw _privateConstructorUsedError;
  String get receiptId => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  double get grossAmount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  DateTime get committedAt => throw _privateConstructorUsedError;
  bool get isLocked => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommittedEntryCopyWith<CommittedEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommittedEntryCopyWith<$Res> {
  factory $CommittedEntryCopyWith(
          CommittedEntry value, $Res Function(CommittedEntry) then) =
      _$CommittedEntryCopyWithImpl<$Res, CommittedEntry>;
  @useResult
  $Res call({
    String committedEntryId,
    String localEntryId,
    String tenantId,
    String receiptId,
    String platform,
    double grossAmount,
    String currency,
    DateTime timestamp,
    DateTime committedAt,
    bool isLocked,
  });
}

/// @nodoc
class _$CommittedEntryCopyWithImpl<$Res, $Val extends CommittedEntry>
    implements $CommittedEntryCopyWith<$Res> {
  _$CommittedEntryCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? committedEntryId = null,
    Object? localEntryId = null,
    Object? tenantId = null,
    Object? receiptId = null,
    Object? platform = null,
    Object? grossAmount = null,
    Object? currency = null,
    Object? timestamp = null,
    Object? committedAt = null,
    Object? isLocked = null,
  }) {
    return _then(_value.copyWith(
      committedEntryId: null == committedEntryId
          ? _value.committedEntryId
          : committedEntryId as String,
      localEntryId: null == localEntryId
          ? _value.localEntryId
          : localEntryId as String,
      tenantId: null == tenantId ? _value.tenantId : tenantId as String,
      receiptId: null == receiptId ? _value.receiptId : receiptId as String,
      platform: null == platform ? _value.platform : platform as String,
      grossAmount:
          null == grossAmount ? _value.grossAmount : grossAmount as double,
      currency: null == currency ? _value.currency : currency as String,
      timestamp: null == timestamp ? _value.timestamp : timestamp as DateTime,
      committedAt:
          null == committedAt ? _value.committedAt : committedAt as DateTime,
      isLocked: null == isLocked ? _value.isLocked : isLocked as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommittedEntryImplCopyWith<$Res>
    implements $CommittedEntryCopyWith<$Res> {
  factory _$$CommittedEntryImplCopyWith(_$CommittedEntryImpl value,
          $Res Function(_$CommittedEntryImpl) then) =
      __$$CommittedEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String committedEntryId,
    String localEntryId,
    String tenantId,
    String receiptId,
    String platform,
    double grossAmount,
    String currency,
    DateTime timestamp,
    DateTime committedAt,
    bool isLocked,
  });
}

/// @nodoc
class __$$CommittedEntryImplCopyWithImpl<$Res>
    extends _$CommittedEntryCopyWithImpl<$Res, _$CommittedEntryImpl>
    implements _$$CommittedEntryImplCopyWith<$Res> {
  __$$CommittedEntryImplCopyWithImpl(
      _$CommittedEntryImpl _value, $Res Function(_$CommittedEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? committedEntryId = null,
    Object? localEntryId = null,
    Object? tenantId = null,
    Object? receiptId = null,
    Object? platform = null,
    Object? grossAmount = null,
    Object? currency = null,
    Object? timestamp = null,
    Object? committedAt = null,
    Object? isLocked = null,
  }) {
    return _then(_$CommittedEntryImpl(
      committedEntryId: null == committedEntryId
          ? _value.committedEntryId
          : committedEntryId as String,
      localEntryId: null == localEntryId
          ? _value.localEntryId
          : localEntryId as String,
      tenantId: null == tenantId ? _value.tenantId : tenantId as String,
      receiptId: null == receiptId ? _value.receiptId : receiptId as String,
      platform: null == platform ? _value.platform : platform as String,
      grossAmount:
          null == grossAmount ? _value.grossAmount : grossAmount as double,
      currency: null == currency ? _value.currency : currency as String,
      timestamp: null == timestamp ? _value.timestamp : timestamp as DateTime,
      committedAt:
          null == committedAt ? _value.committedAt : committedAt as DateTime,
      isLocked: null == isLocked ? _value.isLocked : isLocked as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommittedEntryImpl implements _CommittedEntry {
  const _$CommittedEntryImpl({
    required this.committedEntryId,
    required this.localEntryId,
    required this.tenantId,
    required this.receiptId,
    required this.platform,
    required this.grossAmount,
    required this.currency,
    required this.timestamp,
    required this.committedAt,
    this.isLocked = false,
  });

  factory _$CommittedEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommittedEntryImplFromJson(json);

  @override
  final String committedEntryId;
  @override
  final String localEntryId;
  @override
  final String tenantId;
  @override
  final String receiptId;
  @override
  final String platform;
  @override
  final double grossAmount;
  @override
  final String currency;
  @override
  final DateTime timestamp;
  @override
  final DateTime committedAt;
  @override
  @JsonKey()
  final bool isLocked;

  @override
  String toString() {
    return 'CommittedEntry(committedEntryId: $committedEntryId, localEntryId: $localEntryId, '
        'tenantId: $tenantId, receiptId: $receiptId, platform: $platform, '
        'grossAmount: $grossAmount, currency: $currency, timestamp: $timestamp, '
        'committedAt: $committedAt, isLocked: $isLocked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommittedEntryImpl &&
            (identical(other.committedEntryId, committedEntryId) ||
                other.committedEntryId == committedEntryId) &&
            (identical(other.localEntryId, localEntryId) ||
                other.localEntryId == localEntryId) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.receiptId, receiptId) ||
                other.receiptId == receiptId) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.grossAmount, grossAmount) ||
                other.grossAmount == grossAmount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.committedAt, committedAt) ||
                other.committedAt == committedAt) &&
            (identical(other.isLocked, isLocked) ||
                other.isLocked == isLocked));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, committedEntryId, localEntryId,
      tenantId, receiptId, platform, grossAmount, currency, timestamp,
      committedAt, isLocked);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommittedEntryImplCopyWith<_$CommittedEntryImpl> get copyWith =>
      __$$CommittedEntryImplCopyWithImpl<_$CommittedEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommittedEntryImplToJson(this);
  }
}

abstract class _CommittedEntry implements CommittedEntry {
  const factory _CommittedEntry({
    required final String committedEntryId,
    required final String localEntryId,
    required final String tenantId,
    required final String receiptId,
    required final String platform,
    required final double grossAmount,
    required final String currency,
    required final DateTime timestamp,
    required final DateTime committedAt,
    final bool isLocked,
  }) = _$CommittedEntryImpl;

  factory _CommittedEntry.fromJson(Map<String, dynamic> json) =
      _$CommittedEntryImpl.fromJson;

  @override
  String get committedEntryId;
  @override
  String get localEntryId;
  @override
  String get tenantId;
  @override
  String get receiptId;
  @override
  String get platform;
  @override
  double get grossAmount;
  @override
  String get currency;
  @override
  DateTime get timestamp;
  @override
  DateTime get committedAt;
  @override
  bool get isLocked;
  @override
  @JsonKey(ignore: true)
  _$$CommittedEntryImplCopyWith<_$CommittedEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// ---------------------------------------------------------------------------
// LedgerState
// ---------------------------------------------------------------------------

/// @nodoc
mixin _$LedgerState {
  List<LocalEntry> get localEntries => throw _privateConstructorUsedError;
  List<CommittedEntry> get committedEntries =>
      throw _privateConstructorUsedError;
  bool get isSyncing => throw _privateConstructorUsedError;
  String? get lastError => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LedgerStateCopyWith<LedgerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LedgerStateCopyWith<$Res> {
  factory $LedgerStateCopyWith(
          LedgerState value, $Res Function(LedgerState) then) =
      _$LedgerStateCopyWithImpl<$Res, LedgerState>;
  @useResult
  $Res call({
    List<LocalEntry> localEntries,
    List<CommittedEntry> committedEntries,
    bool isSyncing,
    String? lastError,
  });
}

/// @nodoc
class _$LedgerStateCopyWithImpl<$Res, $Val extends LedgerState>
    implements $LedgerStateCopyWith<$Res> {
  _$LedgerStateCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localEntries = null,
    Object? committedEntries = null,
    Object? isSyncing = null,
    Object? lastError = freezed,
  }) {
    return _then(_value.copyWith(
      localEntries: null == localEntries
          ? _value.localEntries
          : localEntries as List<LocalEntry>,
      committedEntries: null == committedEntries
          ? _value.committedEntries
          : committedEntries as List<CommittedEntry>,
      isSyncing: null == isSyncing ? _value.isSyncing : isSyncing as bool,
      lastError: freezed == lastError
          ? _value.lastError
          : lastError as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LedgerStateImplCopyWith<$Res>
    implements $LedgerStateCopyWith<$Res> {
  factory _$$LedgerStateImplCopyWith(
          _$LedgerStateImpl value, $Res Function(_$LedgerStateImpl) then) =
      __$$LedgerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<LocalEntry> localEntries,
    List<CommittedEntry> committedEntries,
    bool isSyncing,
    String? lastError,
  });
}

/// @nodoc
class __$$LedgerStateImplCopyWithImpl<$Res>
    extends _$LedgerStateCopyWithImpl<$Res, _$LedgerStateImpl>
    implements _$$LedgerStateImplCopyWith<$Res> {
  __$$LedgerStateImplCopyWithImpl(
      _$LedgerStateImpl _value, $Res Function(_$LedgerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localEntries = null,
    Object? committedEntries = null,
    Object? isSyncing = null,
    Object? lastError = freezed,
  }) {
    return _then(_$LedgerStateImpl(
      localEntries: null == localEntries
          ? _value._localEntries
          : localEntries as List<LocalEntry>,
      committedEntries: null == committedEntries
          ? _value._committedEntries
          : committedEntries as List<CommittedEntry>,
      isSyncing: null == isSyncing ? _value.isSyncing : isSyncing as bool,
      lastError: freezed == lastError
          ? _value.lastError
          : lastError as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LedgerStateImpl implements _LedgerState {
  const _$LedgerStateImpl({
    final List<LocalEntry> localEntries = const [],
    final List<CommittedEntry> committedEntries = const [],
    this.isSyncing = false,
    this.lastError,
  })  : _localEntries = localEntries,
        _committedEntries = committedEntries;

  factory _$LedgerStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$LedgerStateImplFromJson(json);

  final List<LocalEntry> _localEntries;
  @override
  @JsonKey()
  List<LocalEntry> get localEntries {
    if (_localEntries is EqualUnmodifiableListView) return _localEntries;
    return EqualUnmodifiableListView(_localEntries);
  }

  final List<CommittedEntry> _committedEntries;
  @override
  @JsonKey()
  List<CommittedEntry> get committedEntries {
    if (_committedEntries is EqualUnmodifiableListView) return _committedEntries;
    return EqualUnmodifiableListView(_committedEntries);
  }

  @override
  @JsonKey()
  final bool isSyncing;
  @override
  final String? lastError;

  @override
  String toString() {
    return 'LedgerState(localEntries: $localEntries, committedEntries: $committedEntries, '
        'isSyncing: $isSyncing, lastError: $lastError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LedgerStateImpl &&
            const DeepCollectionEquality()
                .equals(other._localEntries, _localEntries) &&
            const DeepCollectionEquality()
                .equals(other._committedEntries, _committedEntries) &&
            (identical(other.isSyncing, isSyncing) ||
                other.isSyncing == isSyncing) &&
            (identical(other.lastError, lastError) ||
                other.lastError == lastError));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_localEntries),
      const DeepCollectionEquality().hash(_committedEntries),
      isSyncing,
      lastError);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LedgerStateImplCopyWith<_$LedgerStateImpl> get copyWith =>
      __$$LedgerStateImplCopyWithImpl<_$LedgerStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LedgerStateImplToJson(this);
  }
}

abstract class _LedgerState implements LedgerState {
  const factory _LedgerState({
    final List<LocalEntry> localEntries,
    final List<CommittedEntry> committedEntries,
    final bool isSyncing,
    final String? lastError,
  }) = _$LedgerStateImpl;

  factory _LedgerState.fromJson(Map<String, dynamic> json) =
      _$LedgerStateImpl.fromJson;

  @override
  List<LocalEntry> get localEntries;
  @override
  List<CommittedEntry> get committedEntries;
  @override
  bool get isSyncing;
  @override
  String? get lastError;
  @override
  @JsonKey(ignore: true)
  _$$LedgerStateImplCopyWith<_$LedgerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
