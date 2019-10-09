# CHANGELOG

## [Ureleased]

## 2019-10-08

### Changed

- Updated `Samfundet`, `SamfundetAuth` and `SamfundetDomain` to Rails 5.1
- More clearly show the status of whether the applicant wants other offers
- Make `Samfundet` use latest versions of `SamfundetAuth` and `SamfundetDomain`

## 2019-10-03

### Changed

- Speed up loading of job applications at `/admission-admin/admission/<admission>/groups/<group>`

## 2019-10-01

### Added

- Show reservation counts for each day of the last week at `/lyche/reservations`

### Changed

- Hide delete column if no jobs can be deleted

### Fixed

- Fix crash when no there were no previous or current admissiona and one navigated to `/admission`

### Removed

- Deleted a useless file `en}`

## 2019-09-26

### Changed

- Upgrade to Ruby v2.5

## 2019-09-24

### Changed

- Set start day of calendar picker to Monday instead of Sunday, which was the default

## 2019-09-18

### Added

- Added the new reservation form the Luka is using during UKA

## 2019-09-17

### Added

- Added Hotjar, a service to know where our users are clicking and looking fom which heatmaps are generated
