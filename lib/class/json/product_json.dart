class Products {
  String? status;
  List<Data>? data;

  Products({this.status, this.data});

  Products.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? title;
  String? description;
  String? genre;
  String? imagePath;
  String? createdAt;
  String? updatedAt;
  String? available;
  String? usingPlayerid;
  String? logsMethod;
  String? imageUrl;
  List<Pricelists>? pricelists;

  Data(
      {this.id,
        this.title,
        this.description,
        this.genre,
        this.imagePath,
        this.createdAt,
        this.updatedAt,
        this.available,
        this.usingPlayerid,
        this.logsMethod,
        this.imageUrl,
        this.pricelists});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    genre = json['genre'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    available = json['available'];
    usingPlayerid = json['using_playerid'];
    logsMethod = json['logs_method'];
    imageUrl = json['image_url'];
    if (json['pricelists'] != null) {
      pricelists = <Pricelists>[];
      json['pricelists'].forEach((v) {
        pricelists!.add(new Pricelists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['genre'] = this.genre;
    data['image_path'] = this.imagePath;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['available'] = this.available;
    data['using_playerid'] = this.usingPlayerid;
    data['logs_method'] = this.logsMethod;
    data['image_url'] = this.imageUrl;
    if (this.pricelists != null) {
      data['pricelists'] = this.pricelists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pricelists {
  int? id;
  String? gameId;
  String? key;
  String? price;
  String? createdAt;
  String? updatedAt;

  Pricelists(
      {this.id,
        this.gameId,
        this.key,
        this.price,
        this.createdAt,
        this.updatedAt});

  Pricelists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gameId = json['game_id'];
    key = json['key'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['game_id'] = this.gameId;
    data['key'] = this.key;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
