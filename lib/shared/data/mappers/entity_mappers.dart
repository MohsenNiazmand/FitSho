import 'package:fitsho/features/auth/data/models/user_model.dart';
import 'package:fitsho/features/preferences/data/models/preference_model.dart';
import 'package:fitsho/shared/data/models/ingredient_model.dart';
import 'package:fitsho/shared/data/models/pagination_model.dart';
import 'package:fitsho/shared/domain/entities/ingredient.dart';
import 'package:fitsho/shared/domain/entities/paginated_result.dart';
import 'package:fitsho/shared/domain/entities/preference.dart';
import 'package:fitsho/shared/domain/entities/user.dart';

extension UserModelX on UserModel {
  User toEntity() {
    return User(
      id: id,
      mobileNumber: mobileNumber,
      name: name,
    );
  }
}

extension IngredientModelX on IngredientModel {
  Ingredient toEntity() {
    return Ingredient(
      name: name,
      amount: amount.toDouble(),
      unit: unit,
    );
  }
}

extension PreferenceModelX on PreferenceModel {
  Preference toEntity() {
    return Preference(
      id: id,
      dietaryRestrictions: dietaryRestrictions,
      preferredCuisines: preferredCuisines,
      updatedAt: updatedAt,
    );
  }
}

extension PaginationModelX on PaginationModel {
  Pagination toEntity() {
    return Pagination(
      page: page,
      limit: limit,
      total: total,
      totalPages: totalPages,
    );
  }
}
