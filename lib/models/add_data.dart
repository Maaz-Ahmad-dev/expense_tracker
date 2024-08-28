import 'package:hive/hive.dart';
part 'add_data.g.dart';

@HiveType(typeId: 1)
class AddData extends HiveObject {
  @HiveField(0)
  String category;
  @HiveField(1)
  String name;
  @HiveField(2)
  String amount;
  @HiveField(3)
  String type;
  @HiveField(4)
  DateTime datetime;
  AddData(this.category, this.name, this.amount, this.type, this.datetime);
}
