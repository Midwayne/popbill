class GroupItem {
  GroupItem({
    required this.itemTitle,
    required this.itemPrice,
    required this.itemQuantity,
    required this.consumerProportions,
  });

  String itemTitle;
  double itemPrice;
  int itemQuantity;
  List<Map<String, dynamic>> consumerProportions; //id, share
}
