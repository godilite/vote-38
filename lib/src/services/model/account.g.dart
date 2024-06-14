// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VoteAccountAdapter extends TypeAdapter<VoteAccount> {
  @override
  final int typeId = 0;

  @override
  VoteAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoteAccount(
      accountId: fields[0] as String,
      pagingToken: fields[1] as String,
      subentryCount: fields[2] as int,
      inflationDestination: fields[3] as String?,
      homeDomain: fields[4] as String?,
      lastModifiedLedger: fields[5] as int,
      lastModifiedTime: fields[6] as String,
      thresholds: fields[7] as AccountThresholds,
      flags: fields[8] as HorizonFlags,
      balances: (fields[9] as List).cast<VoteBalance>(),
      signers: (fields[10] as List).cast<VoteSigner>(),
      data: fields[11] as AccountData,
      links: fields[12] as AccountLinks,
      sponsor: fields[13] as String?,
      numSponsored: fields[15] as int,
      numSponsoring: fields[14] as int,
      sequenceLedger: fields[17] as int?,
      sequenceTime: fields[18] as String?,
      sequenceNumber: fields[19] as int,
      accountSecretSeed: fields[20] as String,
    )..muxedAccountMed25519Id = fields[16] as int?;
  }

  @override
  void write(BinaryWriter writer, VoteAccount obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.accountId)
      ..writeByte(1)
      ..write(obj.pagingToken)
      ..writeByte(2)
      ..write(obj.subentryCount)
      ..writeByte(3)
      ..write(obj.inflationDestination)
      ..writeByte(4)
      ..write(obj.homeDomain)
      ..writeByte(5)
      ..write(obj.lastModifiedLedger)
      ..writeByte(6)
      ..write(obj.lastModifiedTime)
      ..writeByte(7)
      ..write(obj.thresholds)
      ..writeByte(8)
      ..write(obj.flags)
      ..writeByte(9)
      ..write(obj.balances)
      ..writeByte(10)
      ..write(obj.signers)
      ..writeByte(11)
      ..write(obj.data)
      ..writeByte(12)
      ..write(obj.links)
      ..writeByte(13)
      ..write(obj.sponsor)
      ..writeByte(14)
      ..write(obj.numSponsoring)
      ..writeByte(15)
      ..write(obj.numSponsored)
      ..writeByte(16)
      ..write(obj.muxedAccountMed25519Id)
      ..writeByte(17)
      ..write(obj.sequenceLedger)
      ..writeByte(18)
      ..write(obj.sequenceTime)
      ..writeByte(19)
      ..write(obj.sequenceNumber)
      ..writeByte(20)
      ..write(obj.accountSecretSeed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoteAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccountThresholdsAdapter extends TypeAdapter<AccountThresholds> {
  @override
  final int typeId = 1;

  @override
  AccountThresholds read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountThresholds(
      lowThreshold: fields[0] as int,
      medThreshold: fields[1] as int,
      highThreshold: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AccountThresholds obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.lowThreshold)
      ..writeByte(1)
      ..write(obj.medThreshold)
      ..writeByte(2)
      ..write(obj.highThreshold);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountThresholdsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HorizonFlagsAdapter extends TypeAdapter<HorizonFlags> {
  @override
  final int typeId = 2;

  @override
  HorizonFlags read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HorizonFlags(
      authRequired: fields[0] as bool,
      authRevocable: fields[1] as bool,
      authImmutable: fields[2] as bool,
      clawbackEnabled: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HorizonFlags obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.authRequired)
      ..writeByte(1)
      ..write(obj.authRevocable)
      ..writeByte(2)
      ..write(obj.authImmutable)
      ..writeByte(3)
      ..write(obj.clawbackEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HorizonFlagsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VoteSignerAdapter extends TypeAdapter<VoteSigner> {
  @override
  final int typeId = 3;

  @override
  VoteSigner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoteSigner(
      key: fields[0] as String,
      type: fields[1] as String,
      weight: fields[2] as int,
      sponsor: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VoteSigner obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.sponsor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoteSignerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VoteBalanceAdapter extends TypeAdapter<VoteBalance> {
  @override
  final int typeId = 4;

  @override
  VoteBalance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoteBalance(
      assetType: fields[0] as String,
      assetCode: fields[1] as String?,
      assetIssuer: fields[2] as String?,
      balance: fields[4] as String,
      limit: fields[3] as String?,
      buyingLiabilities: fields[5] as String?,
      sellingLiabilities: fields[6] as String?,
      isAuthorized: fields[7] as bool?,
      isAuthorizedToMaintainLiabilities: fields[8] as bool?,
      isClawbackEnabled: fields[9] as bool?,
      lastModifiedLedger: fields[10] as int?,
      lastModifiedTime: fields[11] as String?,
      sponsor: fields[12] as String?,
      liquidityPoolId: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VoteBalance obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.assetType)
      ..writeByte(1)
      ..write(obj.assetCode)
      ..writeByte(2)
      ..write(obj.assetIssuer)
      ..writeByte(3)
      ..write(obj.limit)
      ..writeByte(4)
      ..write(obj.balance)
      ..writeByte(5)
      ..write(obj.buyingLiabilities)
      ..writeByte(6)
      ..write(obj.sellingLiabilities)
      ..writeByte(7)
      ..write(obj.isAuthorized)
      ..writeByte(8)
      ..write(obj.isAuthorizedToMaintainLiabilities)
      ..writeByte(9)
      ..write(obj.isClawbackEnabled)
      ..writeByte(10)
      ..write(obj.lastModifiedLedger)
      ..writeByte(11)
      ..write(obj.lastModifiedTime)
      ..writeByte(12)
      ..write(obj.sponsor)
      ..writeByte(13)
      ..write(obj.liquidityPoolId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoteBalanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccountDataAdapter extends TypeAdapter<AccountData> {
  @override
  final int typeId = 5;

  @override
  AccountData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountData(
      fields[0] as int,
      (fields[1] as List).cast<String>(),
      (fields[2] as Map)
          .map((dynamic k, dynamic v) => MapEntry(k as String, v as Uint8List)),
    );
  }

  @override
  void write(BinaryWriter writer, AccountData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.length)
      ..writeByte(1)
      ..write(obj.keys.toList())
      ..writeByte(2)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LinkItemAdapter extends TypeAdapter<LinkItem> {
  @override
  final int typeId = 6;

  @override
  LinkItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LinkItem(
      fields[0] as String,
      fields[1] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, LinkItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.href)
      ..writeByte(1)
      ..write(obj.templated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccountLinksAdapter extends TypeAdapter<AccountLinks> {
  @override
  final int typeId = 7;

  @override
  AccountLinks read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountLinks(
      self: fields[0] as LinkItem?,
      transactions: fields[1] as LinkItem?,
      operations: fields[2] as LinkItem?,
      payments: fields[3] as LinkItem?,
      effects: fields[4] as LinkItem?,
      offers: fields[5] as LinkItem?,
      trades: fields[6] as LinkItem?,
      data: fields[7] as LinkItem?,
    );
  }

  @override
  void write(BinaryWriter writer, AccountLinks obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.self)
      ..writeByte(1)
      ..write(obj.transactions)
      ..writeByte(2)
      ..write(obj.operations)
      ..writeByte(3)
      ..write(obj.payments)
      ..writeByte(4)
      ..write(obj.effects)
      ..writeByte(5)
      ..write(obj.offers)
      ..writeByte(6)
      ..write(obj.trades)
      ..writeByte(7)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountLinksAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
