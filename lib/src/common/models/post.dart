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
  });

  factory Post.fromDocument(String key, Map<String, dynamic> doc) {
    return Post(
      question: doc['question'] as String? ?? '',
      webLink: doc['webLink'] as String? ?? '',
      videoLink: doc['videoLink'] as String? ?? '',
      imageLink: doc['imageLink'] as String? ?? '',
      limit: doc['limit'] as String? ?? '',
      code: doc['code'] as String? ?? '',
      issuerId: doc['issuerId'] as String? ?? '',
      postId: key,
      postAccountSeed: doc['postAccountSeed'] as String? ?? '',
      issuerAccountSeed: doc['issuerAccountSeed'] as String? ?? '',
      nftCid: doc['nftCid'] as String? ?? '',
      createdAt: doc['createdAt'] as String? ?? '',
    );
  }
}
