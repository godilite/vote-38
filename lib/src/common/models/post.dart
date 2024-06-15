class Post {
  final String question;
  final String webLink;
  final String videoLink;
  final String imageLink;
  final String limit;
  final String code;
  final String issuerId;
  final String postId;
  final String postAccountSeed;
  final String issuerAccountSeed;
  final String nftCid;
  final String createdAt;
  final List<Candidate> options;

  Post({
    required this.question,
    required this.webLink,
    required this.videoLink,
    required this.imageLink,
    required this.limit,
    required this.code,
    required this.issuerId,
    required this.postId,
    required this.postAccountSeed,
    required this.issuerAccountSeed,
    required this.nftCid,
    required this.createdAt,
    required this.options,
  });

  factory Post.fromDocument(Map<String, dynamic> doc) {
    return Post(
      question: doc['question'] as String? ?? '',
      webLink: doc['webLink'] as String? ?? '',
      videoLink: doc['videoLink'] as String? ?? '',
      imageLink: doc['imageLink'] as String? ?? '',
      limit: doc['limit'] as String? ?? '',
      code: doc['code'] as String? ?? '',
      issuerId: doc['issuerId'] as String? ?? '',
      postId: doc['postId'] as String? ?? '',
      postAccountSeed: doc['postAccountSeed'] as String? ?? '',
      issuerAccountSeed: doc['issuerAccountSeed'] as String? ?? '',
      nftCid: doc['nftCid'] as String? ?? '',
      createdAt: doc['createdAt'] as String? ?? '',
      options: mapOptionsToCandidates(doc['options'] as Map<String, dynamic>? ?? {}),
    );
  }
}

List<Candidate> mapOptionsToCandidates(Map<String, dynamic> options) {
  final List<Candidate> candidates = [];
  options.forEach((key, value) {
    final List<Candidate> mappedValues = [];
    mappedValues.add(Candidate.fromDocument(key, value as List<dynamic>));

    candidates.addAll(mappedValues);
  });
  return candidates;
}

class Candidate {
  final String id;
  final List<OptionEntryDataInput> properties;

  Candidate({
    required this.id,
    required this.properties,
  });

  factory Candidate.fromDocument(String accountId, List<dynamic> values) {
    return Candidate(
      id: accountId,
      properties: _mapOptions(values),
    );
  }
}

List<OptionEntryDataInput> _mapOptions(List<dynamic> options) {
  final List<OptionEntryDataInput> data = [];
  for (final element in options) {
    data.add(OptionEntryDataInput.fromDocument(element as Map<String, dynamic>));
  }
  return data;
}

class OptionEntryDataInput {
  final String key;
  final String value;

  OptionEntryDataInput({
    required this.key,
    required this.value,
  });

  factory OptionEntryDataInput.fromDocument(Map<String, dynamic> doc) {
    return OptionEntryDataInput(
      key: doc['key'] as String? ?? '',
      value: doc['value'] as String? ?? '',
    );
  }
}
