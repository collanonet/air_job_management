class ItemSelectModel {
  String? title;
  String? id;
  int? index;
  ItemSelectModel({this.id = "", this.title = "", this.index = 1});

  @override
  int get hashCode => id.hashCode ^ title.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ItemSelectModel && runtimeType == other.runtimeType && id == other.id && title == other.title;
}
