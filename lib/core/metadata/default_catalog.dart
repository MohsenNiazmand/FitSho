class DefaultCatalog {
  const DefaultCatalog._();

  static const int defaultVersion = 1;

  static const Map<String, List<Map<String, dynamic>>> catalog = {
    'muscle_group': [
      {'key': 'chest', 'labelFa': 'سینه', 'labelEn': 'Chest', 'order': 1, 'icon': 'chest'},
      {'key': 'back', 'labelFa': 'پشت', 'labelEn': 'Back', 'order': 2, 'icon': 'back'},
      {'key': 'legs', 'labelFa': 'پا', 'labelEn': 'Legs', 'order': 3, 'icon': 'legs'},
      {'key': 'arms', 'labelFa': 'بازو', 'labelEn': 'Arms', 'order': 4, 'icon': 'arms'},
      {'key': 'shoulders', 'labelFa': 'سرشانه', 'labelEn': 'Shoulders', 'order': 5, 'icon': 'shoulders'},
      {'key': 'core', 'labelFa': 'میان‌تنه و شکم', 'labelEn': 'Core', 'order': 6, 'icon': 'core'},
      {'key': 'glutes', 'labelFa': 'باسن', 'labelEn': 'Glutes', 'order': 7, 'icon': 'glutes'},
      {'key': 'calves', 'labelFa': 'ساق پا', 'labelEn': 'Calves', 'order': 8, 'icon': 'calves'},
      {'key': 'full_body', 'labelFa': 'تمام بدن', 'labelEn': 'Full Body', 'order': 9, 'icon': 'full_body'},
    ],
    'exercise_category': [
      {'key': 'strength', 'labelFa': 'قدرتی', 'labelEn': 'Strength', 'order': 1, 'icon': 'dumbbell'},
      {'key': 'cardio', 'labelFa': 'هوازی', 'labelEn': 'Cardio', 'order': 2, 'icon': 'heart_pulse'},
      {'key': 'flexibility', 'labelFa': 'انعطاف‌پذیری', 'labelEn': 'Flexibility', 'order': 3, 'icon': 'stretch'},
      {'key': 'mobility', 'labelFa': 'پویایی و تحرک‌پذیری', 'labelEn': 'Mobility', 'order': 4, 'icon': 'mobility'},
      {'key': 'balance', 'labelFa': 'تعادل', 'labelEn': 'Balance', 'order': 5, 'icon': 'balance'},
      {'key': 'plyometric', 'labelFa': 'پلیومتریک', 'labelEn': 'Plyometric', 'order': 6, 'icon': 'jump'},
    ],
    'movement_pattern': [
      {'key': 'push', 'labelFa': 'فشاری (Push)', 'labelEn': 'Push', 'order': 1},
      {'key': 'pull', 'labelFa': 'کششی (Pull)', 'labelEn': 'Pull', 'order': 2},
      {'key': 'squat', 'labelFa': 'اسکات (Squat)', 'labelEn': 'Squat', 'order': 3},
      {'key': 'hinge', 'labelFa': 'لولا / خم شدن (Hinge)', 'labelEn': 'Hinge', 'order': 4},
      {'key': 'lunge', 'labelFa': 'لانج (Lunge)', 'labelEn': 'Lunge', 'order': 5},
      {'key': 'core', 'labelFa': 'میان‌تنه (Core)', 'labelEn': 'Core', 'order': 6},
      {'key': 'carry', 'labelFa': 'حمل بار (Carry)', 'labelEn': 'Carry', 'order': 7},
      {'key': 'rotation', 'labelFa': 'چرخشی (Rotation)', 'labelEn': 'Rotation', 'order': 8},
    ],
    'workout_type': [
      {'key': 'strength_training', 'labelFa': 'تمرین قدرتی', 'labelEn': 'Strength Training', 'order': 1},
      {'key': 'HIIT', 'labelFa': 'اینتروال شدید (HIIT)', 'labelEn': 'HIIT', 'order': 2},
      {'key': 'circuit', 'labelFa': 'تمرین دایره‌ای', 'labelEn': 'Circuit', 'order': 3},
      {'key': 'endurance', 'labelFa': 'استقامتی', 'labelEn': 'Endurance', 'order': 4},
      {'key': 'yoga', 'labelFa': 'یوگا', 'labelEn': 'Yoga', 'order': 5},
      {'key': 'pilates', 'labelFa': 'پیلاتس', 'labelEn': 'Pilates', 'order': 6},
      {'key': 'crossfit', 'labelFa': 'کراس‌فیت', 'labelEn': 'CrossFit', 'order': 7},
    ],
    'equipment': [
      {'key': 'bodyweight', 'labelFa': 'وزن بدن', 'labelEn': 'Bodyweight', 'order': 1},
      {'key': 'dumbbell', 'labelFa': 'دمبل', 'labelEn': 'Dumbbell', 'order': 2},
      {'key': 'barbell', 'labelFa': 'هالتر', 'labelEn': 'Barbell', 'order': 3},
      {'key': 'cable', 'labelFa': 'سیم‌کش', 'labelEn': 'Cable', 'order': 4},
      {'key': 'resistance_band', 'labelFa': 'کش تمرینی', 'labelEn': 'Resistance Band', 'order': 5},
      {'key': 'machine', 'labelFa': 'دستگاه بدنسازی', 'labelEn': 'Machine', 'order': 6},
      {'key': 'kettlebell', 'labelFa': 'کتل‌بل', 'labelEn': 'Kettlebell', 'order': 7},
      {'key': 'pull_up_bar', 'labelFa': 'میله بارفیکس', 'labelEn': 'Pull-up Bar', 'order': 8},
    ],
    'injury_type': [
      {'key': 'knee', 'labelFa': 'زانو', 'labelEn': 'Knee', 'order': 1},
      {'key': 'shoulder', 'labelFa': 'شانه', 'labelEn': 'Shoulder', 'order': 2},
      {'key': 'lower_back', 'labelFa': 'گودی کمر / کمر', 'labelEn': 'Lower Back', 'order': 3},
      {'key': 'upper_back', 'labelFa': 'بالای کمر و کول', 'labelEn': 'Upper Back', 'order': 4},
      {'key': 'ankle', 'labelFa': 'مچ پا', 'labelEn': 'Ankle', 'order': 5},
      {'key': 'wrist', 'labelFa': 'مچ دست', 'labelEn': 'Wrist', 'order': 6},
      {'key': 'neck', 'labelFa': 'گردن', 'labelEn': 'Neck', 'order': 7},
      {'key': 'hip', 'labelFa': 'لگن و ران', 'labelEn': 'Hip', 'order': 8},
      {'key': 'elbow', 'labelFa': 'آرنج', 'labelEn': 'Elbow', 'order': 9},
    ],
    'goal': [
      {'key': 'weight_loss', 'labelFa': 'کاهش وزن و لاغری', 'labelEn': 'Weight Loss', 'order': 1},
      {'key': 'muscle_gain', 'labelFa': 'عضله‌سازی و افزایش حجم', 'labelEn': 'Muscle Gain', 'order': 2},
      {'key': 'endurance', 'labelFa': 'افزایش استقامت', 'labelEn': 'Endurance', 'order': 3},
      {'key': 'flexibility', 'labelFa': 'افزایش انعطاف‌پذیری', 'labelEn': 'Flexibility', 'order': 4},
      {'key': 'general_fitness', 'labelFa': 'تناسب اندام و سلامت عمومی', 'labelEn': 'General Fitness', 'order': 5},
      {'key': 'rehabilitation', 'labelFa': 'توانبخشی و اصلاح آسیب', 'labelEn': 'Rehabilitation', 'order': 6},
    ],
    'difficulty_level': [
      {'key': 'beginner', 'labelFa': 'مبتدی', 'labelEn': 'Beginner', 'order': 1},
      {'key': 'intermediate', 'labelFa': 'متوسط', 'labelEn': 'Intermediate', 'order': 2},
      {'key': 'advanced', 'labelFa': 'پیشرفته', 'labelEn': 'Advanced', 'order': 3},
      {'key': 'elite', 'labelFa': 'حرفه‌ای', 'labelEn': 'Elite', 'order': 4},
    ],
  };
}
