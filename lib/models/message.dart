Messages messages;
String nesxtPage;

class Messages {
  dynamic currentPage;
  List<Message> message = [];
  dynamic firstPageUrl;
  dynamic from;
  dynamic lastPage;
  dynamic lastPageUrl;
  dynamic nextPageUrl;
  dynamic path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  Messages(
      {this.currentPage,
      this.message,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Messages.fromJson(Map<dynamic, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      message =
          json['data'].map<Message>((json) => Message.fromJson(json)).toList();
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = Map<dynamic, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.message != null) {
      data['data'] = this.message.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Message {
  dynamic id;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic threadId;
  dynamic senderId;
  dynamic target;
  dynamic title;
  dynamic body;
  dynamic image;

  Message(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.threadId,
      this.senderId,
      this.target,
      this.title,
      this.body,
      this.image});

  Message.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    threadId = json['thread_id'];
    senderId = json['sender_id'];
    target = json['target'];
    title = json['title'];
    body = json['body'];
    image = json['image'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['thread_id'] = this.threadId;
    data['sender_id'] = this.senderId;
    data['target'] = this.target;
    data['title'] = this.title;
    data['body'] = this.body;
    data['image'] = this.image;
    return data;
  }
}
