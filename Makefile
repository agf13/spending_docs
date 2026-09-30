run:
	flutter run --dart-define-from-file=config.json

# Generate the localization files for translations
l10n:
	flutter gen-l10n

# clean drift database
drift_clean:
	dart run build_runner clean

# build drift auto-generated code
drift_build:
	dart run build_runner build

# Generate schema file for current db version
drift_dump_schema:
	dart run drift_dev schema dump lib/core/database/app_database.dart lib/core/database/schemas

# Generate db migration steps in order to update step-by-step
drift_generate_migration_steps:
	dart run drift_dev schema steps lib/core/database/schemas lib/core/database/schema_versions.dart

# Use the make-migrations function of drift_dev
make-migrations:
	dart run drift_dev make-migrations
