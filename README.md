# time_counter

Clock inspired by In Time.

## How to run
### Debug mode
1. `cd ./time_counter_flutter_app`
2. Create .env file and edit it like:
```shell
cat <<EOF > .env
AD_UNIT_ID=your-test-unit-id
APP_ID=your-test-app-id
EOF
```
3. flutter run --debug

### Release mode
1. `cd ./time_counter_flutter_app`
2. APP_ID=your-app-id flutter run --release --dart-define=AD_UNIT_ID=your-unit-id
