// Created by Sultonbek Tulanov on 31-August 2025

class ExpenseModel {
  final String id;
  final String userId;
  final double amount;
  final String category;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageUrl;

  const ExpenseModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
  });

  factory ExpenseModel.create({
    required String userId,
    required double amount,
    required String category,
    required String description,
    required DateTime? date,
    String? imageUrl,
  }) {
    final now = DateTime.now();
    return ExpenseModel(
      id: '',
      userId: userId,
      amount: amount,
      category: category,
      description: description,
      createdAt: date ?? now,
      updatedAt: now,
      imageUrl: imageUrl,
    );
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble() /100,
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] ?? 0),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'category': category,
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'imageUrl': imageUrl,
    };
  }

  ExpenseModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? category,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imageUrl,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'ExpenseModel(id: $id, userId: $userId, amount: $amount, category: $category, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, imageUrl: $imageUrl)';
  }


}
