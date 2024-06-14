import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';
import 'package:vote38/src/services/mapper/account_mapper.dart';
import 'package:vote38/src/services/model/account.dart';

class AccountEntryDataInput {
  String key;
  String value;

  AccountEntryDataInput(this.key, this.value);
}

abstract class PostService {
  KeyPair createKeyPair();
  Future<VoteAccount> createAccount(String sponsorSeed, String accountSeed, bool isPostAccount);
  Future<void> saveAccountData(String secretSeed, List<AccountEntryDataInput> data);
  Future<void> setTrustlines(List<String> accounts, String currencyCode, String issuer, String limit);
  Future<void> storeInLocalStorage(String secretSeed);
  Future<List<VoteAccount>> postsForAccount(String secretSeed);
  Future<List<VoteAccount>> getVotingOptionsByPost(String postId);
  Future<NftMeta> getNftMeta(String nftcid);
  Stream<PaymentOperationResponse> subscribeOptionVoting(String accountId);
  Stream<VoteAccount> subscribeToAccount(String secretSeed);
  Future<void> saveToRemoteStorage(
    String secretSeed,
    String limit,
    String code,
    String issuerId,
    List<AccountEntryDataInput> data,
  );
}

class PostServiceImpl implements PostService {
  final StellarSDK sdk;
  final Network network;
  final AccountResponseMapper _accountResponseMapper;
  final Box<VoteAccount> _accountBox;
  final FirebaseFirestore _firestore;

  PostServiceImpl(this.sdk, this.network, this._accountResponseMapper, this._accountBox, this._firestore);

  @override
  KeyPair createKeyPair() {
    return KeyPair.random();
  }

  @override
  Future<VoteAccount> createAccount(String sponsorSeed, String accountSeed, bool isPostAccount) async {
    final sponsorKeyPair = KeyPair.fromSecretSeed(sponsorSeed);
    final accountKp = KeyPair.fromSecretSeed(accountSeed);

    final accountId = accountKp.accountId;

    final beginSponsoringBuilder = BeginSponsoringFutureReservesOperationBuilder(
      accountId,
    );

    /// Load the data of sponsor account from the stellar network.
    final sponsorAccount = await sdk.accounts.account(sponsorKeyPair.accountId);

    /// Create the operation builder.
    final createAccBuilder =
        CreateAccountOperationBuilder(accountId, isPostAccount ? '100' : "5"); // send 1 XLM (lumen)

    final endSponsoringBuilder = EndSponsoringFutureReservesOperationBuilder()..setSourceAccount(accountId);

    final transactionBuilder = TransactionBuilder(sponsorAccount)
      ..addOperation(beginSponsoringBuilder.build())
      ..addOperation(createAccBuilder.build())
      ..addOperation(endSponsoringBuilder.build());

    final transaction = transactionBuilder.build()
      ..sign(sponsorKeyPair, network)
      ..sign(accountKp, network);

    /// Submit the transaction to the stellar network.
    final response = await sdk.submitTransaction(transaction);

    if (!response.success) {
      if (response.extras?.resultCodes?.operationsResultCodes?.isNotEmpty != null) {
        final operationResult = response.extras!.resultCodes!.operationsResultCodes![0];
        if (operationResult == 'op_already_exists') {
          final account = await sdk.accounts.account(accountId);
          return _accountResponseMapper.mapAccountResponse(account, accountSeed);
        }
      }
      debugPrint('Error creating account: $response');
      throw CreateAccountException('Error creating account: $response');
    }

    final account = await sdk.accounts.account(accountId);

    return _accountResponseMapper.mapAccountResponse(account, accountSeed);
  }

  @override
  Future<void> saveAccountData(String secretSeed, List<AccountEntryDataInput> data) async {
    final kp = KeyPair.fromSecretSeed(secretSeed);
    final account = await sdk.accounts.account(kp.accountId);

    for (final entry in data) {
      final key = entry.key;
      final value = entry.value;

      final list = value.codeUnits;
      final valueBytes = Uint8List.fromList(list);

      final operation = ManageDataOperationBuilder(key, valueBytes).build();

      final transaction = TransactionBuilder(account).addOperation(operation).build();

      transaction.sign(kp, network);
      try {
        await sdk.submitTransaction(transaction);
      } catch (e) {
        debugPrint('Error saving account data: $e');
        throw ManageDataException('Error saving account data: $e');
      }
    }
  }

  @override
  Future<void> setTrustlines(List<String> accounts, String currencyCode, String issuer, String limit) async {
    for (final account in accounts) {
      final kp = KeyPair.fromSecretSeed(account);
      AssetTypeCreditAlphaNum asset;

      if (currencyCode.length <= 4) {
        asset = AssetTypeCreditAlphaNum4(currencyCode, issuer);
      } else {
        asset = AssetTypeCreditAlphaNum12(currencyCode, issuer);
      }

      final stellarAccount = await sdk.accounts.account(kp.accountId);

      final transaction =
          TransactionBuilder(stellarAccount).addOperation(ChangeTrustOperationBuilder(asset, limit).build()).build();

      transaction.sign(kp, network);

      final response = await sdk.submitTransaction(transaction);

      if (!response.success) {
        debugPrint('Error setting trustline for account: ${kp.accountId}');
        throw Exception('Error setting trustline for account: ${kp.accountId}');
      }
    }
  }

  @override
  Future<void> saveToRemoteStorage(
    String secretSeed,
    String limit,
    String code,
    String issuerId,
    List<AccountEntryDataInput> data,
  ) async {
    final kp = KeyPair.fromSecretSeed(secretSeed);

    final Map<String, dynamic> mappedJson = {};

    for (final element in data) {
      mappedJson[element.key] = element.value;
    }
    mappedJson['limit'] = limit;
    mappedJson['code'] = code;
    mappedJson['issuerId'] = issuerId;

    await _firestore.collection('votechainupdate').doc('post').set(
      {
        kp.accountId: mappedJson,
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> storeInLocalStorage(String secretSeed) async {
    final accountId = KeyPair.fromSecretSeed(secretSeed).accountId;

    final account = await sdk.accounts.account(accountId);

    final data = _accountResponseMapper.mapAccountResponse(account, secretSeed);

    await _accountBox.put(accountId, data);
  }

  @override
  Future<List<VoteAccount>> postsForAccount(String secretSeed) async {
    final kp = KeyPair.fromSecretSeed(secretSeed);
    return sdk.accounts.forSponsor(kp.accountId).execute().then(
          (value) => value.records?.map((e) => _accountResponseMapper.mapAccountResponse(e, secretSeed)).toList() ?? [],
        );
  }

  @override
  Future<List<VoteAccount>> getVotingOptionsByPost(String postId) async {
    return sdk.accounts.forSponsor(postId).execute().then(
          (value) => value.records?.map((e) => _accountResponseMapper.mapAccountResponse(e, '')).toList() ?? [],
        );
  }

  @override
  Stream<PaymentOperationResponse> subscribeOptionVoting(String accountId) {
    return sdk.payments.forAccount(accountId).stream().map((e) {
      return e as PaymentOperationResponse;
    });
  }

  @override
  Stream<VoteAccount> subscribeToAccount(String secretSeed) {
    final kp = KeyPair.fromSecretSeed(secretSeed);

    return sdk.accounts.forSponsor(kp.accountId).stream().map((e) => _accountResponseMapper.mapAccountResponse(e, ''));
  }

  @override
  Future<NftMeta> getNftMeta(String nftcid) async {
    final url = 'https://ipfs.filebase.io/ipfs/$nftcid';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return parseStringToObject(response.body);
    } else {
      throw Exception('Failed to load NFT meta');
    }
  }

  NftMeta parseStringToObject(String data) {
    final Map<String, String> map = {};

    final updatedData = data.substring(1, data.length - 1);

    final List<String> pairs = updatedData.split(', ');

    for (final String pair in pairs) {
      final List<String> keyValue = pair.split(': ');
      if (keyValue.length == 2) {
        final String key = keyValue[0];
        final String value = keyValue[1];
        map[key] = value;
      }
    }

    return NftMeta.fromMap(map);
  }
}

class ManageDataException implements Exception {
  final String message;

  ManageDataException(this.message);
}

class CreateAccountException implements Exception {
  final String message;

  CreateAccountException(this.message);
}

class SetTrustlineException implements Exception {
  final String message;

  SetTrustlineException(this.message);
}

class NftMeta {
  final String name;
  final String description;
  final String issuer;
  final String code;
  final String url;

  NftMeta(this.name, this.description, this.issuer, this.code, this.url);

  factory NftMeta.fromMap(Map<String, dynamic> json) {
    return NftMeta(
      json['name'] as String,
      json['description'] as String,
      json['issuer'] as String,
      json['code'] as String,
      json['url'] as String,
    );
  }
}
