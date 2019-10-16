# CHANGELOG

## [Unreleased]

## 2019-10-16

- Fix issue where Lyche closed periods would be visible regardless of whether they were actually active or not ([#514](https://github.com/Samfundet/Samfundet/issues/514))

## 2019-10-15

- Fix issue with site crashing when clicking on an individual tag while viewing an image ([#513](https://github.com/Samfundet/Samfundet/issues/513))

## 2019-10-08

### Changed

- Update `Samfundet`, `SamfundetAuth` and `SamfundetDomain` to Rails 5.1 ([#24](https://github.com/Samfundet/SamfundetAuth/pull/24)), ([#4](https://github.com/Samfundet/SamfundetDomain/pull/4))
- More clearly show the status of whether the applicant wants other offers ([#494](https://github.com/Samfundet/Samfundet/issues/494))
- Make `Samfundet` use latest versions of `SamfundetAuth` and `SamfundetDomain` ([#519](https://github.com/Samfundet/Samfundet/pull/519))

## 2019-10-03

### Changed

- Speed up loading of job applications at `/admission-admin/admission/<admission>/groups/<group>` ([#480](https://github.com/Samfundet/Samfundet/issues/480))

## 2019-10-01

### Added

- Show reservation counts for each day of the last week at `/lyche/reservations` ([#79](https://github.com/Samfundet/Samfundet/issues/79))

### Changed

- Hide delete column if no jobs can be deleted

### Fixed

- Fix crash when no there were no previous or current admissiona and one navigated to `/admission`

### Removed

- Delete a useless file `en}`

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
