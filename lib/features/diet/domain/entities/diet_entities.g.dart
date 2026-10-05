// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_entities.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DietProfileAdapter extends TypeAdapter<DietProfile> {
  @override
  final typeId = 4;

  @override
  DietProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DietProfile(
      age: (fields[0] as num).toInt(),
      heightCm: (fields[1] as num).toInt(),
      weightKg: (fields[2] as num).toDouble(),
      gender: fields[3] as String,
      goal: fields[4] as String,
      activityLevel: fields[5] as String,
      doesExercise: fields[6] as bool,
      job: fields[7] as String?,
      goalNotes: fields[8] as String?,
      exerciseType: fields[9] as String?,
      exerciseDaysPerWeek: (fields[10] as num?)?.toInt(),
      dietaryPreferences: fields[11] == null
          ? const []
          : (fields[11] as List).cast<String>(),
      allergiesNotes: fields[12] as String?,
      bmi: (fields[13] as num?)?.toDouble(),
      dailyCalorieTarget: (fields[14] as num?)?.toInt(),
      mealSlots: fields[15] == null
          ? const {}
          : (fields[15] as Map).cast<String, MealSlotConfig>(),
      shouldRegeneratePlan: fields[16] == null ? false : fields[16] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DietProfile obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.age)
      ..writeByte(1)
      ..write(obj.heightCm)
      ..writeByte(2)
      ..write(obj.weightKg)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.goal)
      ..writeByte(5)
      ..write(obj.activityLevel)
      ..writeByte(6)
      ..write(obj.doesExercise)
      ..writeByte(7)
      ..write(obj.job)
      ..writeByte(8)
      ..write(obj.goalNotes)
      ..writeByte(9)
      ..write(obj.exerciseType)
      ..writeByte(10)
      ..write(obj.exerciseDaysPerWeek)
      ..writeByte(11)
      ..write(obj.dietaryPreferences)
      ..writeByte(12)
      ..write(obj.allergiesNotes)
      ..writeByte(13)
      ..write(obj.bmi)
      ..writeByte(14)
      ..write(obj.dailyCalorieTarget)
      ..writeByte(15)
      ..write(obj.mealSlots)
      ..writeByte(16)
      ..write(obj.shouldRegeneratePlan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DietProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealSlotConfigAdapter extends TypeAdapter<MealSlotConfig> {
  @override
  final typeId = 1;

  @override
  MealSlotConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealSlotConfig(
      enabled: fields[0] as bool,
      time: fields[1] as String,
      notificationsEnabled: fields[2] == null ? true : fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MealSlotConfig obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.enabled)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.notificationsEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealSlotConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DietMealAdapter extends TypeAdapter<DietMeal> {
  @override
  final typeId = 2;

  @override
  DietMeal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DietMeal(
      title: fields[0] as String,
      description: fields[1] as String?,
      ingredients: fields[2] == null
          ? const []
          : (fields[2] as List).cast<Ingredient>(),
      calories: (fields[3] as num).toInt(),
      proteinG: (fields[4] as num).toDouble(),
      carbsG: (fields[5] as num).toDouble(),
      fatG: (fields[6] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, DietMeal obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.ingredients)
      ..writeByte(3)
      ..write(obj.calories)
      ..writeByte(4)
      ..write(obj.proteinG)
      ..writeByte(5)
      ..write(obj.carbsG)
      ..writeByte(6)
      ..write(obj.fatG);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DietMealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DietDayAdapter extends TypeAdapter<DietDay> {
  @override
  final typeId = 3;

  @override
  DietDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DietDay(
      day: fields[0] as String,
      meals: (fields[1] as Map).cast<String, DietMeal?>(),
    );
  }

  @override
  void write(BinaryWriter writer, DietDay obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.meals);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DietDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DietPlanAdapter extends TypeAdapter<DietPlan> {
  @override
  final typeId = 5;

  @override
  DietPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DietPlan(
      id: fields[0] as String,
      status: fields[1] as String,
      dailyCalorieTarget: (fields[2] as num).toInt(),
      days: (fields[3] as List).cast<DietDay>(),
      createdAt: fields[4] as DateTime,
      shouldRegeneratePlan: fields[5] == null ? false : fields[5] as bool,
      remainingFullGenerations: (fields[6] as num?)?.toInt(),
      remainingMealSwaps: (fields[7] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, DietPlan obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.dailyCalorieTarget)
      ..writeByte(3)
      ..write(obj.days)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.shouldRegeneratePlan)
      ..writeByte(6)
      ..write(obj.remainingFullGenerations)
      ..writeByte(7)
      ..write(obj.remainingMealSwaps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DietPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealLogAdapter extends TypeAdapter<MealLog> {
  @override
  final typeId = 6;

  @override
  MealLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealLog(
      id: fields[0] as String,
      slot: fields[1] as String,
      day: fields[2] as String,
      loggedAt: fields[3] as DateTime,
      mealTitle: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MealLog obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.slot)
      ..writeByte(2)
      ..write(obj.day)
      ..writeByte(3)
      ..write(obj.loggedAt)
      ..writeByte(4)
      ..write(obj.mealTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SupplementAdapter extends TypeAdapter<Supplement> {
  @override
  final typeId = 7;

  @override
  Supplement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Supplement(
      id: fields[0] as String,
      name: fields[1] as String,
      dosageNote: fields[2] as String?,
      times: fields[3] == null ? const [] : (fields[3] as List).cast<String>(),
      linkedMealSlot: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Supplement obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.dosageNote)
      ..writeByte(3)
      ..write(obj.times)
      ..writeByte(4)
      ..write(obj.linkedMealSlot);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
