all: weblate_language_data/languages.py weblate_language_data/plural_tags.py PLURALS_DIFF.md

weblate_language_data/languages.py: languages.csv aliases.csv extraplurals.csv default_countries.csv $(wildcard modules/iso-codes/data/iso_*.json) scripts/generate-language-data
	./scripts/generate-language-data

PLURALS_DIFF.md: languages.csv cldr.csv gettext.csv l10n-guide.csv translate.csv scripts/list-diff
	./scripts/list-diff
	pre-commit run --files PLURALS_DIFF.md || true

cldr.csv: modules/cldr-to-gettext-plural-rules/bin/export-plural-rules scripts/export-cldr
	./scripts/export-cldr

gettext.csv: modules/gettext/gettext-tools/src/plural-table.c scripts/export-gettext
	./scripts/export-gettext

languages-po/cs.po: modules/cldr-localenames-full/main/en/languages.json $(wildcard modules/cldr-localenames-full/main/*/languages.json) scripts/export-languages-po
	./scripts/export-languages-po

l10n-guide.csv: modules/l10n-guide/docs/l10n/pluralforms.rst scripts/export-l10n-guide
	./scripts/export-l10n-guide

translate.csv: modules/translate/translate/lang/data.py scripts/export-translate
	./scripts/export-translate

weblate_language_data/plural_tags.py: modules/cldr-core/supplemental/plurals.json scripts/export-plural-tags
	./scripts/export-plural-tags

aliases.csv: scripts/export-iso-aliases modules/iso-codes/data/iso_639-2.json modules/iso-codes/data/iso_639-3.json
	./scripts/export-iso-aliases

languages.csv: modules/iso-codes/data/iso_639-2.json scripts/export-iso-languages
	./scripts/export-iso-languages
