import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:minio/minio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';
import 'package:vote38/src/services/model/digital_asset.dart';
import 'package:vote38/src/services/secure_storage.dart';

interface class AssetService {
  Future<bool> mintNFT(String code, String cid, String issuerSecretSeed, String postSeed, String limit) async {
    throw UnimplementedError();
  }

  Future<String> transfer(String code, String issuerSeed, String recipient) {
    throw UnimplementedError();
  }

  Future<String> createNFT(String code, String issuer, String name, String description, Stream<Uint8List> file) async {
    throw UnimplementedError();
  }
}

class AssetServiceImpl implements AssetService {
  final accessKey = 'A6D80C5A0909D8DD1522';
  final secretKey = '37LQeBnKWqntOpSWEc8YoklAk5YY0S2llDnQ2kCs';
  final bucket = 'stella-vote-chain';
  static const keyPairSwapPath = '/auth/key/pair/';
  final SecureStorage _secureStorage;
  final Box<int> _uploadProgress;
  final Network _network;
  final StellarSDK _sdk;

  AssetServiceImpl(this._secureStorage, this._uploadProgress, this._network, this._sdk);

  Future<(String, String)> createAndFundAccount() async {
    final exisitingAccountID = await _secureStorage.read(SecureStorage.testAccountIDKey);
    if (exisitingAccountID != null) {
      final res = await _secureStorage.read(SecureStorage.testAccountSecretKey);
      return (res!, exisitingAccountID);
    }
    final kp = KeyPair.random();

    await FriendBot.fundTestAccount(kp.accountId);

    await _sdk.accounts.account(kp.accountId);

    final token = await _generateToken(kp.accountId);

    try {
      final userCredential = await FirebaseAuth.instance.signInWithCustomToken(token);
      debugPrint(userCredential.user!.uid);

      await _secureStorage.write(SecureStorage.testAuthToken, token);

      await _secureStorage.write(SecureStorage.testAccountIDKey, kp.accountId);
      await _secureStorage.write(SecureStorage.testAccountSecretKey, kp.secretSeed);
      await _secureStorage.write(SecureStorage.currentNetwork, 'testnet');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-custom-token":
          break;
        case "custom-token-mismatch":
          break;
        default:
      }
    }

    return (kp.secretSeed, kp.accountId);
  }

  Future<String> _generateToken(String accountId) async {
    final path = 'https://eu.ourhaven.app/api$keyPairSwapPath$accountId';
    final response = await http.get(Uri.parse(path));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      // ignore: avoid_dynamic_calls
      return parsed['token'] as String;
    }
    return '';
  }

  @override
  Future<bool> mintNFT(String code, String cid, String issuerSecretSeed, String postSeed, String limit) async {
    final kp = KeyPair.fromSecretSeed(issuerSecretSeed);

    final distributor = KeyPair.fromSecretSeed(postSeed);

    final distributorAccount = await _sdk.accounts.account(distributor.accountId);

    const String key = "ipfshash";
    final String value = cid;

    AssetTypeCreditAlphaNum nftAsset;

    if (code.length <= 4) {
      nftAsset = AssetTypeCreditAlphaNum4(code, kp.accountId);
    } else {
      nftAsset = AssetTypeCreditAlphaNum12(code, kp.accountId);
    }

    final List<int> list = value.codeUnits;
    final Uint8List valueBytes = Uint8List.fromList(list);

    final ManageDataOperationBuilder manageDataOperationBuilder = ManageDataOperationBuilder(key, valueBytes);

    final ChangeTrustOperationBuilder changeTrustOperationBuilder = ChangeTrustOperationBuilder(
      nftAsset,
      limit,
    );

    final paymentOperation = PaymentOperationBuilder(distributor.accountId, nftAsset, limit)
      ..setSourceAccount(kp.accountId);

    final transactionBuilder = TransactionBuilder(distributorAccount)
        .addOperation(manageDataOperationBuilder.build())
        .addOperation(changeTrustOperationBuilder.build())
        .addOperation(paymentOperation.build());

    final transaction = transactionBuilder.build()
      ..sign(distributor, _network)
      ..sign(kp, _network);

    final response = await _sdk.submitTransaction(transaction);

    return response.success;
  }

  @override
  Future<String> transfer(String code, String issuerSeed, String recipient) async {
    final kp = KeyPair.fromSecretSeed(issuerSeed);
    final recipientKp = KeyPair.fromAccountId(recipient);

    final issuerAccount = await _sdk.accounts.account(kp.accountId);

    final nftAsset =
        code.length <= 4 ? AssetTypeCreditAlphaNum4(code, kp.accountId) : AssetTypeCreditAlphaNum12(code, kp.accountId);

    final paymentOperation = PaymentOperationBuilder(recipientKp.accountId, nftAsset, '1')
      ..setSourceAccount(kp.accountId);

    final transaction = TransactionBuilder(issuerAccount).addOperation(paymentOperation.build()).build()
      ..sign(kp, _network);

    final response = await _sdk.submitTransaction(transaction);

    return response.success ? 'success' : 'failed';
  }

  @override
  Future<String> createNFT(
    String code,
    String secretSeed,
    String name,
    String description,
    Stream<Uint8List> file,
  ) async {
    int retry = 0;

    final kp = KeyPair.fromSecretSeed(secretSeed);

    final issuer = kp.accountId;
    try {
      final minio = Minio(
        endPoint: 's3.filebase.com',
        accessKey: accessKey,
        secretKey: secretKey,
      );
      final cid = await _uploadFile(
        code: code,
        secretSeed: secretSeed,
        name: name,
        issuer: issuer,
        description: description,
        file: file,
        minio: minio,
      );
      return cid;
    } catch (e) {
      debugPrint('Error creating NFT: $e');
      if (retry < 1) {
        debugPrint('Retrying...');
        retry++;
        final minio = Minio(
          endPoint: 's3.filebase.com',
          accessKey: accessKey,
          secretKey: secretKey,
        );
        return _uploadFile(
          code: code,
          secretSeed: secretSeed,
          name: name,
          issuer: issuer,
          description: description,
          file: file,
          minio: minio,
        );
      } else {
        throw Exception('Error creating NFT: $e');
      }
    }
  }

  Future<String> _uploadFile({
    required String code,
    required String secretSeed,
    required String name,
    required String issuer,
    required String description,
    required Stream<Uint8List> file,
    required Minio minio,
  }) async {
    final cleanedDescription = description.replaceAll('\n', ' ').replaceAll(RegExp(r'[^\x20-\x7E]'), '');

    final fileName = 'nft-$code-${DateTime.now().millisecondsSinceEpoch}.png';

    final metadata = {
      'name': name,
      'description': cleanedDescription,
      'issuer': issuer,
      'code': code,
    };
    String? cid;

    final fileBuff = await file.toList();
    final fileBuffStream = Stream.fromIterable(fileBuff);

    await minio.putObject(
      bucket,
      fileName,
      fileBuffStream,
      metadata: metadata,
      onProgress: (p0) {
        _uploadProgress.put('nftImageUploadProgress', p0);
      },
      onHeaders: (headers) {
        cid = headers["x-amz-meta-cid"];
      },
    );

    String? metaCid;

    final nftMeta = {
      'name': name,
      'description': description,
      'issuer': issuer,
      'code': code,
      'url': 'https://ipfs.filebase.io/ipfs/$cid',
    };

    final directory = await getApplicationDocumentsDirectory();

    final metaJsonFile = File('${directory.path}/$fileName-meta.json');

    await metaJsonFile.writeAsString(nftMeta.toString());
    final metaFileStream = metaJsonFile.readAsBytes().asStream();

    final jsonBuffer = await metaFileStream.toList();
    final bufferedStream = Stream.fromIterable(jsonBuffer);

    await minio.putObject(
      bucket,
      '$fileName-meta.json',
      bufferedStream,
      onHeaders: (headers) {
        metaCid = headers["x-amz-meta-cid"];
      },
      onProgress: (p0) {
        _uploadProgress.put('metajsonProgress', p0);
      },
    );

    return metaCid!;
  }

  Future<DigitalAsset> getData(String cid) async {
    final String ipfsGatewayUrl = 'https://ipfs.io/ipfs/$cid';

    try {
      // Fetch the data from IPFS using the CID
      final response = await http.get(Uri.parse(ipfsGatewayUrl));

      if (response.statusCode == 200) {
        // Assume the data is in JSON format and decode it
        final data = json.decode(response.body) as Map<String, dynamic>;
        return DigitalAsset.fromJson(data);
      } else {
        throw Exception('Failed to load data from IPFS');
      }
    } catch (e) {
      throw Exception('Failed to load data from IPFS: $e');
    }
  }
}
