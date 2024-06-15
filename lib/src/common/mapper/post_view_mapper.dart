import 'package:collection/collection.dart';
import 'package:vote38/src/common/models/post.dart';
import 'package:vote38/src/services/model/account.dart';

List<OptionData> mapOptionsAccountToPost(List<VoteAccount> accounts, Post post, String code) {
  final data = accounts.map((e) {
    final options = post.options;
    final properties = options.firstWhereOrNull((element) => element.id == e.accountId);
    if (properties == null) {
      return null;
    }
    final accountId = e.accountId;
    final votes = e.balances
        .where((e) => e.assetCode == code)
        .fold(0.0, (previousValue, element) => previousValue + double.parse(element.balance));

    final name = properties.properties.first.value;

    return OptionData(
      name: name,
      data: properties.properties,
      accountId: accountId,
      votes: votes.ceil().toString(),
    );
  }).toList();

  return data.whereNotNull().toList();
}

class OptionData {
  final List<OptionEntryDataInput> data;
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
