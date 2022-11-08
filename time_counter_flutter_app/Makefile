.PHONY: release
release:
	source .env && APP_ID=${APP_ID} flutter run --release --dart-define=AD_UNIT_ID=${AD_UNIT_ID}

.PHONY: bundle
bundle:
	source .release.env && APP_ID=${APP_ID} flutter build bundle --dart-define=AD_UNIT_ID=${AD_UNIT_ID}
