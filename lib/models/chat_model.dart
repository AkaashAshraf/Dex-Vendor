class DeliveryChatListItem {
  var _id;
  var _createdAt;
  var _updatedAt;
  var _threadId;
  var _senderId;
  var _target;
  var _title;
  var _body;
  var _image;
  var _name;

  DeliveryChatListItem(
      {var id,
      var createdAt,
      var updatedAt,
      var threadId,
      var senderId,
      var target,
      var title,
      var body,
      var image,
      var name}) {
    this._id = id;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._threadId = threadId;
    this._senderId = senderId;
    this._target = target;
    this._title = title;
    this._body = body;
    this._image = image;
    this._name = name;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  int get threadId => _threadId;
  set threadId(int threadId) => _threadId = threadId;
  int get senderId => _senderId;
  set senderId(int senderId) => _senderId = senderId;
  String get target => _target;
  set target(String target) => _target = target;
  String get title => _title;
  set title(String title) => _title = title;
  String get body => _body;
  set body(String body) => _body = body;
  String get image => _image;
  set image(String image) => _image = image;
  String get name => _name;
  set name(String name) => _name = name;

  DeliveryChatListItem.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _threadId = json['thread_id'];
    _senderId = json['sender_id'];
    _target = json['target'];
    _title = json['title'];
    _body = json['body'];
    _image = json['image'] ?? '';
    _name = json['senderInfo']['first_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['thread_id'] = this._threadId;
    data['sender_id'] = this._senderId;
    data['target'] = this._target;
    data['title'] = this._title;
    data['body'] = this._body;
    data['image'] = this._image;
    data['senderInfo']['first_name'] = this._name;
    return data;
  }
}
