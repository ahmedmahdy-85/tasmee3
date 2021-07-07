class Topic {
  String to;
  NotificationModel notificationModel;

  Topic({this.notificationModel, this.to});

  Topic.fromJson(Map<dynamic, dynamic> map)
      : to = map['to'] ?? "",
        notificationModel = map['notification'] ?? NotificationModel();

  Map<String, dynamic> toJson() => {
        'to': to,
        'notification': notificationModel,
      };
}

class NotificationModel {
  String title;
  String text;

  NotificationModel({
    this.text,
    this.title,
  });

  NotificationModel.fromJson(Map<dynamic, dynamic> map)
      : title = map['title'] ?? "",
        text = map['text'] ?? "";

  Map<String, dynamic> toJson() => {
        'text': text,
        'title': title,
      };

  @override
  String toString() {
    return 'NotificationModel{title: $title, text: $text}';
  }
}
