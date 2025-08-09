# Инструкции по импорту проекта в Godot 4.4

## Шаг 1: Подготовка проекта
1. Скачайте и установите Godot 4.4 с официального сайта: https://godotengine.org/
2. Скопируйте папку `vampire_survivors_godot` в удобное место на вашем компьютере

## Шаг 2: Импорт в Godot
1. Откройте Godot 4.4
2. В Project Manager нажмите "Import"
3. Найдите файл `project.godot` в папке `vampire_survivors_godot`
4. Нажмите "Import & Edit"

## Шаг 3: Первый запуск
1. После открытия проекта, откройте сцену `scenes/Main.tscn`
2. Нажмите F5 или кнопку "Play" в верхней панели
3. Выберите `Main.tscn` как главную сцену проекта

## Шаг 4: Настройка Input Map (если нужно)
Если управление не работает:
1. Откройте Project -> Project Settings
2. Перейдите на вкладку "Input Map"
3. Убедитесь, что настроены действия:
   - move_up (W, ↑)
   - move_down (S, ↓)  
   - move_left (A, ←)
   - move_right (D, →)
   - pause (Esc)

## Возможные проблемы и решения

### Проблема: Сцены не загружаются
**Решение**: Убедитесь, что все файлы .tscn находятся в правильных папках и пути в скриптах корректны.

### Проблема: Ошибки в скриптах
**Решение**: Откройте каждый скрипт и проверьте, что нет ошибок синтаксиса. Godot покажет ошибки красным цветом.

### Проблема: Враги не спавнятся
**Решение**: Проверьте, что сцены врагов находятся в папке `scenes/enemies/` и правильно настроены в EnemySpawner.

### Проблема: Оружие не стреляет
**Решение**: Убедитесь, что сцены снарядов находятся в папке `scenes/projectiles/`.

## Дополнительные настройки

### Слои коллизии (Physics Layers):
- Layer 1: Player
- Layer 2: Enemy  
- Layer 3: Projectile
- Layer 4: Pickup

### Audio Bus Layout (опционально):
1. Project -> Project Settings -> Audio -> Buses
2. Создайте шины: Master, SFX, Music

## Структура файлов проекта:
```
vampire_survivors_godot/
├── project.godot
├── icon.svg
├── README.md
├── scenes/
│   ├── Main.tscn
│   ├── ExperienceOrb.tscn
│   ├── HealthPickup.tscn
│   ├── enemies/
│   ├── weapons/
│   └── projectiles/
└── scripts/
    ├── GameManager.gd
    ├── Player.gd
    ├── Enemy.gd
    ├── EnemySpawner.gd
    ├── ExperienceOrb.gd
    ├── UI.gd
    ├── CameraController.gd
    ├── AudioManager.gd
    ├── HealthPickup.gd
    ├── weapons/
    ├── projectiles/
    └── enemies/
```

После успешного импорта вы сможете играть в аналог Vampire Survivors!