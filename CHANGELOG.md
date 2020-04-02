# CHANGELOG

## 2020-04-02

### Added

- Make applicant phone number and email interactable ([#606](https://github.com/Samfundet/Samfundet/issues/606))

### Changed

- Clean up Makefile ([#662](https://github.com/Samfundet/Samfundet/pull/662))

### Fixed

- Annotate Ruby on Rails model files ([#663](https://github.com/Samfundet/Samfundet/pull/663))

## 2020-04-01

### Fixed

- Fix tests ([#462](https://github.com/Samfundet/Samfundet/issues/462))
- Upgrade paperclip-compression ([#651](https://github.com/Samfundet/Samfundet/pull/651))
- Validate `publication_time` when creating an `Event` ([#655](https://github.com/Samfundet/Samfundet/issues/655))

## 2020-03-26

### Fixed

- Fix testing infrastructure ([#641](https://github.com/Samfundet/Samfundet/pull/641))

## 2020-03-24

### Changed

- Properly encapsulate and translate log entries ([#642](https://github.com/Samfundet/Samfundet/pull/642))

### Fixed

- Correct typo in `/admission` text ([#560](https://github.com/Samfundet/Samfundet/issues/560))

## 2020-03-20

### Fixed

- Make all columns in interview table sortable ([#639](https://github.com/Samfundet/Samfundet/pull/639))
- Don't compare interview times if it has been removed ([#638](https://github.com/Samfundet/Samfundet/pull/638))

## 2020-03-19

### Fixed

- Upgrade Rails to 5.2.4.2 to fix security vulnerability ([#640](https://github.com/Samfundet/Samfundet/pull/640))
- Fix admission statistics ([#623](https://github.com/Samfundet/Samfundet/pull/623))

## 2020-03-18

### Added

- Add macOS shell script for onboarding new members ([#602](https://github.com/Samfundet/Samfundet/pull/602))

### Fixed

- Fix UI issues with previous and next admission buttons in statistics view ([#618](https://github.com/Samfundet/Samfundet/pull/618))

## 2020-03-17

### Removed

- Completely remove the show unlogged applications functionality ([#635](https://github.com/Samfundet/Samfundet/pull/635))

## 2020-02-22

### Added

- Add calendar icon for Lyche calendar ([#582](https://github.com/Samfundet/Samfundet/issues/582))

## 2020-02-13

### Changed

- Hide show unlogged applicants because of bugs ([#617](https://github.com/Samfundet/Samfundet/pull/617))
- Configure ([#610](https://github.com/Samfundet/Samfundet/pull/610)) and later revert ([#611](https://github.com/Samfundet/Samfundet/pull/611)) LiveReload middleware

## 2020-02-11

### Changed

- Update images created in `seeds.rb` ([#609](https://github.com/Samfundet/Samfundet/pull/609))

## 2020-02-08

### Added

- Show applications by hour statistics ([#449](https://github.com/Samfundet/Samfundet/issues/449))
- Show and log individual/all unlogged applicants ([#578](https://github.com/Samfundet/Samfundet/issues/578))

### Changed

- Improve usability of Lyche admin calendar ([#581](https://github.com/Samfundet/Samfundet/issues/581))

### Fixed

- Fix crash when a reservations' table was deleted ([#539](https://github.com/Samfundet/Samfundet/pull/593))
- Fix minor Lyche admin calendar UI issues ([#595](https://github.com/Samfundet/Samfundet/issues/595))
- Bump version of debugging gem to fix stack traces ([#596](https://github.com/Samfundet/Samfundet/pull/596))

## 2020-02-06

### Changed

- Improve seed script ([#580](https://github.com/Samfundet/Samfundet/pull/580))

### Fixed

- Fix wrong total unique applicant count ([#588](https://github.com/Samfundet/Samfundet/pull/588))

## 2020-02-04

### Changed

- Replace graph library ([#562](https://github.com/Samfundet/Samfundet/pull/562))

### Fixed

- Upgrade Rails to 5.2.4.1 to fix security vulnerability ([#563](https://github.com/Samfundet/Samfundet/pull/563))
- Fix applicant prioritization ([#572](https://github.com/Samfundet/Samfundet/pull/572))

## 2020-01-30

### Added

- Add beta version of new admin reservation panel ([#547](https://github.com/Samfundet/Samfundet/pull/547)), ([#575](https://github.com/Samfundet/Samfundet/pull/575))

### Fixed

- Update README.md ([#573](https://github.com/Samfundet/Samfundet/pull/573)), ([#574](https://github.com/Samfundet/Samfundet/pull/574))

## 2020-01-23

### Fixed

- Fix issue with changing password for applicants ([#568](https://github.com/Samfundet/Samfundet/pull/568))

## 2019-11-14

### Fixed

- Correct UI issues with documents (saksdokumenter) table ([#544](https://github.com/Samfundet/Samfundet/issues/544))
- Point back button in closed periods view to Lyche admin view, not control panel ([#541](https://github.com/Samfundet/Samfundet/issues/541))

## 2019-11-12

### Fixed

- Reinstate confirmation boxes on delete operations ([#545](https://github.com/Samfundet/Samfundet/pull/545))

## 2019-11-10

### Fixed

- Upgrade `loofah` dependency to patch security vulnerability ([#546](https://github.com/Samfundet/Samfundet/pull/546))

## 2019-11-08

### Fixed

- Fix font size of second-level header in information pages ([#538](https://github.com/Samfundet/Samfundet/pull/538))

## 2019-11-07

### Added

- Show previously Lyche closed periods ([#518](https://github.com/Samfundet/Samfundet/issues/518))

### Fixed

- Fix mention of allergies on Lyche reservation form ([#534](https://github.com/Samfundet/Samfundet/issues/534))
- Translate un-translated text ([#530](https://github.com/Samfundet/Samfundet/issues/530))
- Fix typo in title of film club page ([#537](https://github.com/Samfundet/Samfundet/issues/537))

## 2019-10-28

### Changed

- Use old Lyche reservation form now that UKA 2019 is over ([#532](https://github.com/Samfundet/Samfundet/pull/532))

## 2019-10-22

### Added

- Show shortcuts to new reservation form for Lyche admin ([#525](https://github.com/Samfundet/Samfundet/pull/525))

### Fixed

- Fixed issue where Lyche reservation comment icon would appear regardless of whether there was an actual comment or not ([#524](https://github.com/Samfundet/Samfundet/issues/524))

## 2019-10-17

### Added

- Make it visible that a reservation has a comment ([#501](https://github.com/Samfundet/Samfundet/issues/501))
- Set name of admission as link to the corresponding admission page in admissions statistics page ([#495](https://github.com/Samfundet/Samfundet/issues/495))

### Changed

- Update to Rails v5.2 ([#510](https://github.com/Samfundet/Samfundet/pull/510))
- Sort Lyche tables by number in ascending order ([#506](https://github.com/Samfundet/Samfundet/issues/506))
- Don't send/require mail/phone when Lyche admins add a reservation manually ([#505](https://github.com/Samfundet/Samfundet/issues/505))

### Removed

- Remove mentions of allergy in form when creating a reservation ([#503](https://github.com/Samfundet/Samfundet/issues/503))

## 2019-10-16

### Fixed

- Fix issue where Lyche closed periods would be visible regardless of whether they were actually active or not ([#514](https://github.com/Samfundet/Samfundet/issues/514))

## 2019-10-15

### Fixed

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

- Hide delete column if no jobs can be deleted ([#442](https://github.com/Samfundet/Samfundet/issues/442))

### Fixed

- Fix crash when no there were no previous or current admissiona and one navigated to `/admission` ([#475](https://github.com/Samfundet/Samfundet/issues/475))

### Removed

- Delete a useless file `en}` ([#483](https://github.com/Samfundet/Samfundet/pull/483))

## 2019-09-26

### Changed

- Upgrade to Ruby v2.5 ([#474](https://github.com/Samfundet/Samfundet/pull/474))

## 2019-09-24

### Changed

- Set start day of calendar picker to Monday instead of Sunday, which was the default ([#473](https://github.com/Samfundet/Samfundet/pull/473))

## 2019-09-18

### Added

- Add the new reservation form Lyche is using during UKA ([#469](https://github.com/Samfundet/Samfundet/pull/469))

## 2019-09-17

### Added

- Add Hotjar, a service to know where our users are clicking and looking from which heatmaps are generated ([#468](https://github.com/Samfundet/Samfundet/pull/468))
