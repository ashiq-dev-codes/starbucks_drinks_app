class Drink {
  const Drink({
    required this.id,
    required this.title,
    required this.price,
    required this.type,
    required this.description,
    required this.imageAsset,
  });

  final int id;
  final String title;
  final String price;
  final String type;
  final String description;
  final String imageAsset;
}
