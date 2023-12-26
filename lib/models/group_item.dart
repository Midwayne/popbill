class GroupItem {
  GroupItem({
    required this.itemTitle,
    required this.itemPrice,
    required this.consumerProportions,
  });

  String itemTitle;
  double itemPrice;
  List<Map<String, dynamic>> consumerProportions; //id, share
}
