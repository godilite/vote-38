import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class VoteAccount extends HiveObject {
  @HiveField(0)
  String accountId;
  @HiveField(1)
  String pagingToken;
  @HiveField(2)
  int subentryCount;
  @HiveField(3)
  String? inflationDestination;
  @HiveField(4)
  String? homeDomain;
  @HiveField(5)
  int lastModifiedLedger;
  @HiveField(6)
  String lastModifiedTime;
  @HiveField(7)
  AccountThresholds thresholds;
  @HiveField(8)
  HorizonFlags flags;
  @HiveField(9)
  List<VoteBalance> balances;
  @HiveField(10)
  List<VoteSigner> signers;
  @HiveField(11)
  AccountData data;
  @HiveField(12)
  AccountLinks links;
  @HiveField(13)
  String? sponsor;
  @HiveField(14)
  int numSponsoring;
  @HiveField(15)
  int numSponsored;
  @HiveField(16)
  int? muxedAccountMed25519Id; // ID to be used if this account is used as MuxedAccountMed25519
  @HiveField(17)
  int? sequenceLedger;
  @HiveField(18)
  String? sequenceTime;
  @HiveField(19)
  int sequenceNumber;
  @HiveField(20)
  String accountSecretSeed;

  VoteAccount({
    required this.accountId,
    required this.pagingToken,
    required this.subentryCount,
    this.inflationDestination,
    this.homeDomain,
    required this.lastModifiedLedger,
    required this.lastModifiedTime,
    required this.thresholds,
    required this.flags,
    required this.balances,
    required this.signers,
    required this.data,
    required this.links,
    required this.sponsor,
    required this.numSponsored,
    required this.numSponsoring,
    this.sequenceLedger,
    this.sequenceTime,
    required this.sequenceNumber,
    required this.accountSecretSeed,
  });

  static const String boxName = 'account';
}

@HiveType(typeId: 1)
class AccountThresholds {
  @HiveField(0)
  int lowThreshold;
  @HiveField(1)
  int medThreshold;
  @HiveField(2)
  int highThreshold;

  AccountThresholds({
    required this.lowThreshold,
    required this.medThreshold,
    required this.highThreshold,
  });
}

@HiveType(typeId: 2)
class HorizonFlags {
  @HiveField(0)
  bool authRequired;
  @HiveField(1)
  bool authRevocable;
  @HiveField(2)
  bool authImmutable;
  @HiveField(3)
  bool clawbackEnabled;

  HorizonFlags({
    required this.authRequired,
    required this.authRevocable,
    required this.authImmutable,
    required this.clawbackEnabled,
  });
}

@HiveType(typeId: 3)
class VoteSigner {
  @HiveField(0)
  String key;
  @HiveField(1)
  String type;
  @HiveField(2)
  int weight;
  @HiveField(3)
  String? sponsor;

  VoteSigner({required this.key, required this.type, required this.weight, this.sponsor});
}

@HiveType(typeId: 4)
class VoteBalance extends HiveObject {
  @HiveField(0)
  String assetType;
  @HiveField(1)
  String? assetCode;
  @HiveField(2)
  String? assetIssuer;
  @HiveField(3)
  String? limit;
  @HiveField(4)
  String balance;
  @HiveField(5)
  String? buyingLiabilities;
  @HiveField(6)
  String? sellingLiabilities;
  @HiveField(7)
  bool? isAuthorized;
  @HiveField(8)
  bool? isAuthorizedToMaintainLiabilities;
  @HiveField(9)
  bool? isClawbackEnabled;
  @HiveField(10)
  int? lastModifiedLedger;
  @HiveField(11)
  String? lastModifiedTime;
  @HiveField(12)
  String? sponsor;
  @HiveField(13)
  String? liquidityPoolId;

  VoteBalance({
    required this.assetType,
    this.assetCode,
    this.assetIssuer,
    required this.balance,
    this.limit,
    this.buyingLiabilities,
    this.sellingLiabilities,
    this.isAuthorized,
    this.isAuthorizedToMaintainLiabilities,
    this.isClawbackEnabled,
    this.lastModifiedLedger,
    this.lastModifiedTime,
    this.sponsor,
    this.liquidityPoolId,
  });

  Asset get asset {
    if (assetType == Asset.TYPE_NATIVE) {
      return AssetTypeNative();
    } else {
      return Asset.createNonNativeAsset(assetCode!, assetIssuer!);
    }
  }

  static const String boxName = 'balance';
}

@HiveType(typeId: 5)
class AccountData extends HiveObject {
  @HiveField(0)
  int length;
  @HiveField(1)
  Iterable<String> keys;
  @HiveField(2)
  Map<String, Uint8List> data;
  AccountData(this.length, this.keys, this.data);

  Uint8List? getDecoded(String key) => data[key];
}

@HiveType(typeId: 6)
class LinkItem extends HiveObject {
  @HiveField(0)
  String href;
  @HiveField(1)
  bool? templated;

  LinkItem(this.href, this.templated);
}

@HiveType(typeId: 7)
class AccountLinks extends HiveObject {
  @HiveField(0)
  LinkItem? self;
  @HiveField(1)
  LinkItem? transactions;
  @HiveField(2)
  LinkItem? operations;
  @HiveField(3)
  LinkItem? payments;
  @HiveField(4)
  LinkItem? effects;
  @HiveField(5)
  LinkItem? offers;
  @HiveField(6)
  LinkItem? trades;
  @HiveField(7)
  LinkItem? data;

  AccountLinks({
    this.self,
    this.transactions,
    this.operations,
    this.payments,
    this.effects,
    this.offers,
    this.trades,
    this.data,
  });
}
