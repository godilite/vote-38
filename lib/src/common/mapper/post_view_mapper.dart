import 'package:vote38/src/common/extension/string_extension.dart';
import 'package:vote38/src/common/models/post.dart';
import 'package:vote38/src/services/model/account.dart';

List<Post> mapAccountToPost(List<VoteAccount> accounts) {
  final data = accounts.map((e) {
    final question = e.data.data['question']?.toDecodedString();
    final webLink = e.data.data['webLink']?.toDecodedString();
    final videoLink = e.data.data['videoLink']?.toDecodedString();
    final imageLink = e.data.data['imageLink']?.toDecodedString();
    final nftCid = e.data.data['nftCid']?.toDecodedString();
    final createdAt = e.data.data['createdAt']?.toDecodedString();

    return Post(
      postId: e.accountId,
      question: question ?? '',
      webLink: webLink ?? '',
      videoLink: videoLink ?? '',
      imageLink: imageLink ?? '',
      createdAt: createdAt ?? '',
      limit: '',
      code: '',
      issuerId: e.sponsor ?? '',
      postAccountSeed: e.accountSecretSeed,
      issuerAccountSeed: '',
      nftCid: nftCid ?? '',
    );
  }).toList();

  return data.where(_cleanUpPost).toList();
}

bool _cleanUpPost(Post post) {
  return post.question.isNotEmpty && post.createdAt.isNotEmpty && post.nftCid.isNotEmpty;
}

List<OptionData> mapOptionsAccountToPost(List<VoteAccount> accounts, String code) {
  final data = accounts.map((e) {
    final Map<String, String> properties = {};
    e.data.data.forEach((key, value) {
      properties[key] = value.toDecodedString();
    });

    final accountId = e.accountId;
    final votes = e.balances
        .where((e) => e.assetCode == code)
        .fold(0.0, (previousValue, element) => previousValue + double.parse(element.balance));

    return OptionData(
      name: properties['name'] ?? '',
      data: properties,
      accountId: accountId,
      votes: votes.ceil().toString(),
    );
  }).toList();

  return data;
}

class OptionData {
  final Map<String, String> data;
  final String accountId;
  final String votes;
  final String name;

  OptionData({
    required this.name,
    required this.data,
    required this.accountId,
    required this.votes,
  });
}
