class Article {
  String title;
  String author;
  String description;
  String urlToImage;
  DateTime publishedAt;
  String content;
  String articleUrl;
  String source;

  Article({
    required this.title,
    required this.description,
    required this.author,
    required this.content,
    required this.publishedAt,
    required this.urlToImage,
    required this.articleUrl,
    required this.source,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      author: json['author'] ?? 'Unknown',
      description: json['description'] ?? 'No Description',
      urlToImage: json['urlToImage'] ?? 'https://via.placeholder.com/150',
      publishedAt: DateTime.parse(
          json['publishedAt'] ?? DateTime.now().toIso8601String()),
      content: json['content'] ?? 'No Content',
      articleUrl: json['url'] ?? '',
      source: json['source']['name'] ?? 'Unknown Source',
    );
  }
}
