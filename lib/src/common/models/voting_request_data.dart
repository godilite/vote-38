class VotingRequestData {
  final String voterId;
  final String postId;
  final String nftCode;
  final String issuerId;
  final String time;

  VotingRequestData({
    required this.voterId,
    required this.postId,
    required this.nftCode,
    required this.issuerId,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'accountId': voterId,
      'postId': postId,
      'code': nftCode,
      'issuerId': issuerId,
      'time': time,
    };
  }

  factory VotingRequestData.fromJson(Map<String, dynamic> json) {
    return VotingRequestData(
      voterId: json['accountId'] as String,
      postId: json['postId'] as String,
      nftCode: json['code'] as String,
      issuerId: json['issuerId'] as String,
      time: json['time'] as String? ?? DateTime.now().toIso8601String(),
    );
  }
}
