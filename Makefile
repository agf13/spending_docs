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
