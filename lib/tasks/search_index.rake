# frozen_string_literal: true
task search_index: :environment do
  puts 'Deleting old index'
  PgSearch::Document.delete_all
  puts 'Updating search index for events'
  Event.find_each do |record|
    record.update_pg_search_document
    print '.'
  end
  print "\n"
  puts 'Updating search index for pages'
  Page.find_each do |record|
    record.update_pg_search_document
    print '.'
  end
  print "\n"
end
