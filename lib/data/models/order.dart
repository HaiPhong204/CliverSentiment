import 'package:json_annotation/json_annotation.dart';
import '../enums/enums.dart';
import 'model.dart';
part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order {
  DateTime? createdAt;
  DateTime? updatedAt;
  int? id;
  int? price;
  String? note;
  String? dueBy;
  String? recruiterId;
  User? recruiter;
  String? candidateId;
  User? candidate;
  int? revisionTimes;
  int? leftRevisionTimes;
  int? packageId;
  String? paymentMethod;
  Package? package;
  Status? status;
  List<Review>? reviews;
  List<OrderHistory>? histories;
  Order({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.price,
    this.note,
    this.dueBy,
    this.recruiterId,
    this.recruiter,
    this.candidateId,
    this.candidate,
    this.revisionTimes,
    this.leftRevisionTimes,
    this.packageId,
    this.paymentMethod,
    this.package,
    this.status,
    this.reviews,
    this.histories,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
