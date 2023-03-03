.PHONY: release
release:
	. .env && APP_ID=$${APP_ID} flutter run --release --dart-define=AD_UNIT_ID=$${AD_UNIT_ID}

.PHONY: appbundle
appbundle:
	. .release.env && APP_ID=$${APP_ID} flutter build appbundle --dart-define=AD_UNIT_ID=$${AD_UNIT_ID}
