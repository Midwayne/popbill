class GroupItem {
  GroupItem({
    required this.itemTitle,
    required this.itemPrice,
    required this.consumerProportions,
  });

  String itemTitle;
  String itemPrice;
  List<Map<String, String>> consumerProportions;
}
