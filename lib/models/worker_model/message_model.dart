class MessageModel {
  final String message;
  final String senderId;
  final String receiverId;
  final String originalName;
  final int type;
  late final DateTime createdAt;

  String get subtitle => [message, originalName, originalName][type];

  MessageModel({
    required this.message,
    required this.senderId,
    required this.receiverId,
    this.type = 0,
    this.originalName = "An Attachment",
    DateTime? createdAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  static MessageModel fromJson(Map<String, dynamic> json) => MessageModel(
        message: json['message'],
        senderId: json['sender_id'],
        receiverId: json['receiver_id'],
        type: json['type'] ?? 0,
        originalName: json['original_name'] ?? '',
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'sender_id': senderId,
        'receiver_id': receiverId,
        'original_name': originalName,
        'type': type,
        'created_at': createdAt.toIso8601String(),
      };
}
