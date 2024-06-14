import 'dart:typed_data';

import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';
import 'package:vote38/src/services/model/account.dart';

class AccountResponseMapper {
  VoteAccount mapAccountResponse(AccountResponse account, String secretSeed) {
    return VoteAccount(
      accountId: account.accountId,
      pagingToken: account.pagingToken,
      subentryCount: account.subentryCount,
      inflationDestination: account.inflationDestination,
      homeDomain: account.homeDomain,
      lastModifiedLedger: account.lastModifiedLedger,
      accountSecretSeed: secretSeed,
      lastModifiedTime: account.lastModifiedTime,
      thresholds: AccountThresholds(
        lowThreshold: account.thresholds.lowThreshold,
        medThreshold: account.thresholds.medThreshold,
        highThreshold: account.thresholds.highThreshold,
      ),
      flags: HorizonFlags(
        authRequired: account.flags.authRequired,
        authRevocable: account.flags.authRevocable,
        authImmutable: account.flags.authImmutable,
        clawbackEnabled: account.flags.clawbackEnabled,
      ),
      balances: account.balances
          .map(
            (balance) => VoteBalance(
              assetType: balance.assetType,
              assetCode: balance.assetCode,
              assetIssuer: balance.assetIssuer,
              balance: balance.balance,
              limit: balance.limit,
              buyingLiabilities: balance.buyingLiabilities,
              sellingLiabilities: balance.sellingLiabilities,
              isAuthorized: balance.isAuthorized,
              isAuthorizedToMaintainLiabilities: balance.isAuthorizedToMaintainLiabilities,
              isClawbackEnabled: balance.isClawbackEnabled,
              lastModifiedLedger: balance.lastModifiedLedger,
              lastModifiedTime: balance.lastModifiedTime,
              sponsor: balance.sponsor,
              liquidityPoolId: balance.liquidityPoolId,
            ),
          )
          .toList(),
      signers: account.signers
          .map(
            (signer) => VoteSigner(
              key: signer.key,
              type: signer.type,
              weight: signer.weight,
              sponsor: signer.sponsor,
            ),
          )
          .toList(),
      data: _mapAccountData(account.data),
      links: _mapAccountLinks(account.links),
      sponsor: account.sponsor,
      numSponsoring: account.numSponsoring,
      numSponsored: account.numSponsored,
      sequenceLedger: account.sequenceLedger,
      sequenceTime: account.sequenceTime,
      sequenceNumber: account.sequenceNumber,
    );
  }

  AccountData _mapAccountData(AccountResponseData data) {
    final Map<String, Uint8List> dataMap = {};

    for (final key in data.keys) {
      dataMap[key] = data.getDecoded(key);
    }

    return AccountData(data.length, data.keys, dataMap);
  }

  AccountLinks _mapAccountLinks(AccountResponseLinks links) {
    return AccountLinks(
      self: _mapLinkItem(links.self),
      transactions: _mapLinkItem(links.transactions),
      operations: _mapLinkItem(links.operations),
      payments: _mapLinkItem(links.payments),
      effects: _mapLinkItem(links.effects),
      offers: _mapLinkItem(links.offers),
      trades: _mapLinkItem(links.trades),
      data: _mapLinkItem(links.data),
    );
  }

  LinkItem _mapLinkItem(Link item) {
    return LinkItem(item.href, item.templated);
  }
}
