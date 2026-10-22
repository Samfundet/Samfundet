# Test coverage audit

Verified on Ruby 3.1.2: **750 examples, 0 failures, 0 pending; 95.16% line coverage (3,363 / 3,534 lines)**. The run passed with `COVERAGE_MINIMUM=95`.

All originally tracked RSpec files were read and reviewed, including the previously undiscovered user-session file. New specs cover controllers, models, helpers, abilities, mailers through actual delivery, the custom input, and library utilities.

Coverage starts before Rails and tracks all Ruby files under `app/` and `lib/`. The standard Rails profile excludes infrastructure configuration, assets, dependencies and test files. No application files were excluded to achieve the target.

## Review of the original suite

| Original file | Review / change |
|---|---|
| `spec/abilities/ability_spec.rb` | Checked guest, applicant ownership and role permissions; split negative multi-action assertions into separate action checks. |
| `spec/abilities/sulten_ability_spec.rb` | Checked guest and restaurant permissions; strengthened negative checks for each forbidden action. |
| `spec/controllers/applicant_session_controller_spec.rb` | Verified and unverified login, pending applications, invalid credentials and verification delivery. |
| `spec/controllers/applicants_controller_spec.rb` | Signup waits for verification; pending applications remain pending; recovery, verification expiry and filtering covered in additional specs. |
| `spec/controllers/application_controller_spec.rb` | Session lookup and deleted users; CSRF, access denial and referrer checks in boundary specs. |
| `spec/controllers/groups_controller_spec.rb` | Corrected an update test that called create; invalid updates assert exact persisted values. |
| `spec/controllers/info_boxes_controller_spec.rb` | Replaced placeholder with ordered listing, CRUD failures and authorization checks. |
| `spec/controllers/job_controller_spec.rb` | Removed global finder and recommendation stubs; recommendations use real shared tags and admission/group data. |
| `spec/controllers/member_sessions_controller_spec.rb` | Added local versus external redirect checks. |
| `spec/controllers/members_controller_spec.rb` | Identity switching checks session state; JSON checks media type independently of charset; control panel and role browsing added. |
| `spec/controllers/roles_controller_spec.rb` | Show checks an authorized child role; invalid updates assert preserved values; transfer checks retained. |
| `spec/controllers/user_session_controller.rb` | Renamed to user_sessions_controller_spec.rb so RSpec discovers the existing logout examples. |
| `spec/models/admission_spec.rb` | Deadline ordering, exact boundaries, custom groups and interview dates added in admission_boundaries_spec.rb. |
| `spec/models/applicant_spec.rb` | Password and token expiry, disabled accounts, confirmations, assignment states and recovery limits added in applicant_workflow_spec.rb. |
| `spec/models/blog_spec.rb` | Missing image now checks model validation instead of an accidental foreign-key failure; display and fallback cases added. |
| `spec/models/campus_spec.rb` | Counts assert the correct campus key; added duplicate-application and no-current-admission cases. |
| `spec/models/event_spec.rb` | Publication validation checks the specific field; ticket states, limits, publication, price choices and ranking covered separately. |
| `spec/models/group_spec.rb` | Replaced interview placeholder with positive and negative group filtering; display and role names added separately. |
| `spec/models/info_box_spec.rb` | Replaced placeholder with required fields, locale fallback and image fallback. |
| `spec/models/job_application_spec.rb` | Fixed interview deletion assertion to query Interview; workflow tests add ownership, deduplication, status and log history. |
| `spec/models/job_spec.rb` | Retained tag and recommendation tests; processing tests separate active, withdrawn and outcome states. |
| `spec/models/member_spec.rb` | Replaced placeholder with authentication, required fields, hierarchy and membership cases. |
| `spec/models/role_spec.rb` | Replaced placeholder with validation, readonly title, hierarchy, transfer scope and membership cleanup. |

## Defects exposed by added examples

- English interview statuses used the Norwegian translation map.
- Page diffs escaped their own insertion/deletion markup; user text remains escaped.
- Group admission permissions called an obsolete authorization helper.
- Paperclip validation passed positional error options incompatible with Ruby 3 and Rails 6.1.
- Reservation slot generation used the process timezone instead of the Rails timezone.
- Missing reservation starts were masked by an earlier duration error.
- Confirmation mail crashed when optional allergy text was absent.
- Interview calendar export used obsolete iCalendar properties and Rails rendering options.
- Expired application priority AJAX errors used an obsolete Rails rendering option.
- Referrer checks accepted unrelated hosts containing the application hostname.
- Withdrawn applications without interviews appeared in the unprocessed list.
- Campus counts crashed when no current admission existed, and the campus show action lacked a template.
- Reservation types lacked the join association needed to list their supported tables.
- Failed-payment simulator redirects attempted to mutate a frozen string.

## Measurement limitations

The threshold is for line coverage. Controller specs normally disable view rendering; helper and mailer output has separate examples. External registration queries and payment interactions use controlled local data. This does not claim exhaustive branch coverage or production-service integration verification.

Files with no executable behavior (empty helpers and commented-out controller implementations) do not need placeholder examples. Inherited namespace behavior is exercised by the concrete controller tests. The legacy `lib/samfundet_auth.rb` adapter remains tracked but uncovered because it requires an engine absent from this checkout; it has not been excluded.

## Per-file line coverage from the full suite

| Source | Covered / relevant lines | Coverage |
|---|---:|---:|
| `app/abilities/ability.rb` | 55 / 63 | 87.30% |
| `app/abilities/admissions_admin_ability.rb` | 13 / 25 | 52.00% |
| `app/abilities/sulten_ability.rb` | 14 / 14 | 100.00% |
| `app/controllers/admissions_admin/admissions_controller.rb` | 215 / 220 | 97.73% |
| `app/controllers/admissions_admin/applicants_controller.rb` | 13 / 13 | 100.00% |
| `app/controllers/admissions_admin/base_controller.rb` | 3 / 3 | 100.00% |
| `app/controllers/admissions_admin/campus_controller.rb` | 37 / 41 | 90.24% |
| `app/controllers/admissions_admin/groups_controller.rb` | 50 / 50 | 100.00% |
| `app/controllers/admissions_admin/interviews_controller.rb` | 57 / 59 | 96.61% |
| `app/controllers/admissions_admin/job_applications_controller.rb` | 24 / 24 | 100.00% |
| `app/controllers/admissions_admin/jobs_controller.rb` | 44 / 52 | 84.62% |
| `app/controllers/admissions_admin/log_entries_controller.rb` | 21 / 21 | 100.00% |
| `app/controllers/admissions_controller.rb` | 10 / 10 | 100.00% |
| `app/controllers/applicant_sessions_controller.rb` | 38 / 42 | 90.48% |
| `app/controllers/applicants_controller.rb` | 108 / 122 | 88.52% |
| `app/controllers/application_controller.rb` | 54 / 58 | 93.10% |
| `app/controllers/areas_controller.rb` | 18 / 19 | 94.74% |
| `app/controllers/blogs_controller.rb` | 36 / 38 | 94.74% |
| `app/controllers/contact_controller.rb` | 3 / 3 | 100.00% |
| `app/controllers/crowd_funding_supporters_controller.rb` | 1 / 1 | 100.00% |
| `app/controllers/documents_controller.rb` | 36 / 39 | 92.31% |
| `app/controllers/events_controller.rb` | 131 / 145 | 90.34% |
| `app/controllers/everything_closed_periods_controller.rb` | 28 / 29 | 96.55% |
| `app/controllers/front_page_locks_controller.rb` | 25 / 29 | 86.21% |
| `app/controllers/groups_controller.rb` | 26 / 29 | 89.66% |
| `app/controllers/images_controller.rb` | 37 / 38 | 97.37% |
| `app/controllers/info_boxes_controller.rb` | 27 / 30 | 90.00% |
| `app/controllers/job_applications_controller.rb` | 63 / 69 | 91.30% |
| `app/controllers/jobs_controller.rb` | 15 / 16 | 93.75% |
| `app/controllers/member_sessions_controller.rb` | 20 / 20 | 100.00% |
| `app/controllers/members_controller.rb` | 27 / 29 | 93.10% |
| `app/controllers/members_roles_controller.rb` | 17 / 17 | 100.00% |
| `app/controllers/new_building_controller.rb` | 3 / 3 | 100.00% |
| `app/controllers/pages_controller.rb` | 86 / 93 | 92.47% |
| `app/controllers/pending_applications.rb` | 10 / 10 | 100.00% |
| `app/controllers/roles_controller.rb` | 40 / 42 | 95.24% |
| `app/controllers/search_controller.rb` | 7 / 7 | 100.00% |
| `app/controllers/site_controller.rb` | 45 / 45 | 100.00% |
| `app/controllers/sulten/admin_controller.rb` | 34 / 35 | 97.14% |
| `app/controllers/sulten/base_controller.rb` | 3 / 3 | 100.00% |
| `app/controllers/sulten/closed_periods_controller.rb` | 26 / 28 | 92.86% |
| `app/controllers/sulten/lyche_controller.rb` | 59 / 65 | 90.77% |
| `app/controllers/sulten/menu_categories_controller.rb` | 30 / 31 | 96.77% |
| `app/controllers/sulten/menu_controller.rb` | 8 / 8 | 100.00% |
| `app/controllers/sulten/menu_items_controller.rb` | 32 / 33 | 96.97% |
| `app/controllers/sulten/reservation_types_controller.rb` | 25 / 28 | 89.29% |
| `app/controllers/sulten/reservations_controller.rb` | 80 / 81 | 98.77% |
| `app/controllers/sulten/tables_controller.rb` | 48 / 48 | 100.00% |
| `app/controllers/user_sessions_controller.rb` | 18 / 20 | 90.00% |
| `app/helpers/admission_groups_helper.rb` | 5 / 5 | 100.00% |
| `app/helpers/applicant_verification_helper.rb` | 9 / 9 | 100.00% |
| `app/helpers/applicants_helper.rb` | 7 / 7 | 100.00% |
| `app/helpers/application_helper.rb` | 53 / 53 | 100.00% |
| `app/helpers/areas_helper.rb` | 7 / 7 | 100.00% |
| `app/helpers/blog_articles_helper.rb` | 5 / 5 | 100.00% |
| `app/helpers/date_helper.rb` | 3 / 3 | 100.00% |
| `app/helpers/event_helper.rb` | 35 / 35 | 100.00% |
| `app/helpers/everything_closed_periods_helper.rb` | 3 / 3 | 100.00% |
| `app/helpers/group_helper.rb` | 17 / 17 | 100.00% |
| `app/helpers/info_boxes_helper.rb` | 1 / 1 | 100.00% |
| `app/helpers/job_applications_admin_helper.rb` | 1 / 1 | 100.00% |
| `app/helpers/pages_helper.rb` | 34 / 34 | 100.00% |
| `app/helpers/standard_hours_helper.rb` | 7 / 7 | 100.00% |
| `app/helpers/user_sessions_helper.rb` | 3 / 3 | 100.00% |
| `app/inputs/color_input.rb` | 3 / 3 | 100.00% |
| `app/mailers/admission_rejection_mailer.rb` | 6 / 6 | 100.00% |
| `app/mailers/sulten_notification_mailer.rb` | 5 / 5 | 100.00% |
| `app/mailers/verify_email_applicant_mailer.rb` | 14 / 14 | 100.00% |
| `app/models/admission.rb` | 70 / 70 | 100.00% |
| `app/models/applicant.rb` | 106 / 113 | 93.81% |
| `app/models/application_record.rb` | 2 / 2 | 100.00% |
| `app/models/area.rb` | 54 / 56 | 96.43% |
| `app/models/billig_event.rb` | 16 / 16 | 100.00% |
| `app/models/billig_payment_error.rb` | 1 / 1 | 100.00% |
| `app/models/billig_payment_error_price_group.rb` | 4 / 4 | 100.00% |
| `app/models/billig_price_group.rb` | 4 / 4 | 100.00% |
| `app/models/billig_purchase.rb` | 5 / 5 | 100.00% |
| `app/models/billig_ticket.rb` | 6 / 6 | 100.00% |
| `app/models/billig_ticket_card.rb` | 6 / 6 | 100.00% |
| `app/models/billig_ticket_group.rb` | 19 / 19 | 100.00% |
| `app/models/blog.rb` | 18 / 18 | 100.00% |
| `app/models/campus.rb` | 24 / 24 | 100.00% |
| `app/models/crowd_funding_supporter.rb` | 5 / 5 | 100.00% |
| `app/models/document.rb` | 12 / 12 | 100.00% |
| `app/models/document_category.rb` | 6 / 6 | 100.00% |
| `app/models/email_verification.rb` | 2 / 2 | 100.00% |
| `app/models/event.rb` | 165 / 165 | 100.00% |
| `app/models/everything_closed_period.rb` | 18 / 18 | 100.00% |
| `app/models/external_organizer.rb` | 2 / 2 | 100.00% |
| `app/models/forgot_password_mailer.rb` | 6 / 6 | 100.00% |
| `app/models/front_page_lock.rb` | 24 / 24 | 100.00% |
| `app/models/group.rb` | 51 / 51 | 100.00% |
| `app/models/group_type.rb` | 11 / 11 | 100.00% |
| `app/models/image.rb` | 36 / 36 | 100.00% |
| `app/models/info_box.rb` | 12 / 12 | 100.00% |
| `app/models/interview.rb` | 49 / 49 | 100.00% |
| `app/models/job.rb` | 56 / 57 | 98.25% |
| `app/models/job_application.rb` | 29 / 29 | 100.00% |
| `app/models/job_tag.rb` | 1 / 1 | 100.00% |
| `app/models/log_entry.rb` | 13 / 13 | 100.00% |
| `app/models/member.rb` | 31 / 38 | 81.58% |
| `app/models/members_role.rb` | 5 / 5 | 100.00% |
| `app/models/page.rb` | 64 / 64 | 100.00% |
| `app/models/page_revision.rb` | 7 / 7 | 100.00% |
| `app/models/password_recovery.rb` | 1 / 1 | 100.00% |
| `app/models/price_group.rb` | 4 / 4 | 100.00% |
| `app/models/registration_event.rb` | 14 / 15 | 93.33% |
| `app/models/rejection_email.rb` | 4 / 4 | 100.00% |
| `app/models/role.rb` | 24 / 24 | 100.00% |
| `app/models/search.rb` | 14 / 14 | 100.00% |
| `app/models/standard_hour.rb` | 17 / 17 | 100.00% |
| `app/models/sulten.rb` | 3 / 3 | 100.00% |
| `app/models/sulten/closed_period.rb` | 13 / 13 | 100.00% |
| `app/models/sulten/menu_category.rb` | 7 / 7 | 100.00% |
| `app/models/sulten/menu_item.rb` | 5 / 5 | 100.00% |
| `app/models/sulten/neighbour_table.rb` | 5 / 5 | 100.00% |
| `app/models/sulten/reservation.rb` | 106 / 109 | 97.25% |
| `app/models/sulten/reservation_type.rb` | 6 / 6 | 100.00% |
| `app/models/sulten/table.rb` | 38 / 38 | 100.00% |
| `app/models/sulten/table_reservation_type.rb` | 3 / 3 | 100.00% |
| `app/models/tag.rb` | 5 / 5 | 100.00% |
| `lib/billig_service.rb` | 41 / 41 | 100.00% |
| `lib/control_panel.rb` | 29 / 29 | 100.00% |
| `lib/generate_roles.rb` | 11 / 11 | 100.00% |
| `lib/localized_fields.rb` | 7 / 7 | 100.00% |
| `lib/samfundet_auth.rb` | 0 / 22 | 0.00% |
| `lib/samfundet_domain.rb` | 12 / 12 | 100.00% |
| `lib/validators/css_hex_color_validator.rb` | 4 / 4 | 100.00% |
| `lib/validators/email_validator.rb` | 4 / 4 | 100.00% |
| `lib/validators/url_validator.rb` | 8 / 8 | 100.00% |

Run `make test` to enforce the 95% full-suite threshold. See [testing.md](testing.md) for setup and focused runs.
