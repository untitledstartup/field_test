## 0.3.2 [unreleased]

- Added support for excluding IP addresses

## 0.3.1

- Added `closed` and `keep_variant`
- Added `field_test_upgrade_memberships` method
- Fixed API controller error
- Fixed bug where conversions were recorded after winner

Security

- Fixed arbitrary variants via query parameters - see [#17](https://github.com/ankane/field_test/issues/17)

## 0.3.0

- Added support for native apps
- Added `cookies` option
- Added `precision` option
- Fixed bug in results with multiple goals
- Fixed issue where metrics disappeared from dashboard when moving to multiple goals
- Dropped support for Rails < 5

Breaking changes

- Split out participant id and type
- Changed participant logic for emails

## 0.2.4

- Fixed `PG::AmbiguousColumn` error

## 0.2.3

- Fixed participant reporting for multiple goals

## 0.2.2

- Added support for Rails 5.1

## 0.2.1

- Added support for multiple goals

## 0.2.0

- Better web UI
- Removed `cookie:` prefix for unknown participants

## 0.1.2

- Exclude bots
- Mailer improvements

## 0.1.1

- Added basic web UI

## 0.1.0

- First release
