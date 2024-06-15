import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';
import 'package:vote38/src/common/models/voting_request_data.dart';
import 'package:vote38/src/services/secure_storage.dart';

class VotingService {
  final StellarSDK _sdk;
  final FirebaseFirestore _firestore;
  final SecureStorage _secureStorage;
  final Network _network;
  static const limit = '1';
  final Box<bool> _requestedVotingTokenBox;

  VotingService(this._sdk, this._firestore, this._secureStorage, this._network, this._requestedVotingTokenBox);

  Future<void> vote(String candidateId, String nftCode, String issuerId) async {
    final accountId = await _secureStorage.read(SecureStorage.testAccountIDKey);
    final accountSeed = await _secureStorage.read(SecureStorage.testAccountSecretKey);

    if (accountId == null || accountSeed == null) {
      return;
    }

    final kp = KeyPair.fromSecretSeed(accountSeed);
    final asset = AssetTypeCreditAlphaNum12(nftCode, issuerId);

    final stellarAccount = await _sdk.accounts.account(kp.accountId);

    final transaction = TransactionBuilder(stellarAccount)
        .addOperation(
          PaymentOperationBuilder(candidateId, asset, '1').build(),
        )
        .build();

    transaction.sign(kp, _network);

    final response = await _sdk.submitTransaction(transaction);

    if (!response.success) {
      debugPrint('Error voting for candidate: $candidateId');
      throw Exception('Error voting for candidate: $candidateId');
    }
  }

  Future<bool> canVote(String nftCode, String issuerId) async {
    final accountId = await _secureStorage.read(SecureStorage.testAccountIDKey);

    if (accountId == null) {
      return false;
    }

    if (accountId == issuerId) {
      return false;
    }

    final account = await _sdk.accounts.account(accountId);
    final balance = account.balances.firstWhereOrNull((element) => element.assetCode == nftCode);

    if (balance == null) {
      return false;
    }

    return double.parse(balance.balance) == 1;
  }

  Future<bool> hasVoted(String nftCode) async {
    final accountId = await _secureStorage.read(SecureStorage.testAccountIDKey);

    if (accountId == null) {
      return false;
    }

    final payments = await _sdk.payments.forAccount(accountId).execute();

    final payment = payments.records?.firstWhereOrNull((element) {
      return element is PaymentOperationResponse &&
          element.assetType == 'credit_alphanum12' &&
          element.assetCode == nftCode;
    });

    return payment != null;
  }

  Future<void> requestVotingToken(String postId, String issuerId, String code) async {
    final accountId = await _secureStorage.read(SecureStorage.testAccountIDKey);
    final accountSeed = await _secureStorage.read(SecureStorage.testAccountSecretKey);

    if (accountId == null || accountSeed == null) {
      return;
    }

    final kp = KeyPair.fromSecretSeed(accountSeed);
    AssetTypeCreditAlphaNum asset;

    if (code.length <= 4) {
      asset = AssetTypeCreditAlphaNum4(code, issuerId);
    } else {
      asset = AssetTypeCreditAlphaNum12(code, issuerId);
    }

    final stellarAccount = await _sdk.accounts.account(kp.accountId);

    final transaction =
        TransactionBuilder(stellarAccount).addOperation(ChangeTrustOperationBuilder(asset, limit).build()).build();

    transaction.sign(kp, _network);

    final response = await _sdk.submitTransaction(transaction);

    if (!response.success) {
      debugPrint('Error setting trustline for account: ${kp.accountId}');
      throw Exception('Error setting trustline for account: ${kp.accountId}');
    }

    await _firestore.collection('votingrequests').doc(postId).set(
      {
        accountId: {
          'accountId': kp.accountId,
          'postId': postId,
          'code': code,
          'issuerId': issuerId,
          'time': DateTime.now().toIso8601String(),
        },
      },
      SetOptions(merge: true),
    );

    await _requestedVotingTokenBox.put(postId, true);
  }

  bool hasRequestedVotingToken(String postId) {
    return _requestedVotingTokenBox.get(postId, defaultValue: false) ?? false;
  }

  Stream<VotingRequestData?> subscribeRequests(String postId) {
    return _firestore.collection('votingrequests').doc(postId).snapshots().map((event) {
      final result = event.data();
      if (result != null && result.values.isNotEmpty) {
        final data = result.values.first as Map<String, dynamic>;
        return VotingRequestData(
          voterId: data['accountId'] as String? ?? '',
          postId: data['postId'] as String? ?? '',
          nftCode: data['code'] as String? ?? '',
          issuerId: data['issuerId'] as String? ?? '',
          time: data['time'] as String? ?? DateTime.now().toIso8601String(),
        );
      }

      return null;
    });
  }

  Future<void> deleteRequest(String accountId, String postId) async {
    await _firestore.collection('votingrequests').doc(postId).update({accountId: FieldValue.delete()});
  }

  Future<void> deleteAllRequests(String postId) async {
    await _firestore.collection('votingrequests').doc(postId).delete();
  }
}
