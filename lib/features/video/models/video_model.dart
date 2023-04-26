class VideoModel {
  final String title, description, fileUrl, thumbnailUrl, creatorUid, creator;
  final int likes, comments, createdAt;

  VideoModel({
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.thumbnailUrl,
    required this.creatorUid,
    required this.creator,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  VideoModel.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        description = json["description"],
        fileUrl = json["fileUrl"],
        thumbnailUrl = json["thumbnailUrl"],
        creatorUid = json["creatorUid"],
        creator = json["creator"],
        likes = json["likes"],
        comments = json["comments"],
        createdAt = json["createdAt"];

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "fileUrl": fileUrl,
      "thumbnailUrl": thumbnailUrl,
      "creatorUid": creatorUid,
      "creator": creator,
      "likes": likes,
      "comments": comments,
      "createdAt": createdAt,
    };
  }
}
