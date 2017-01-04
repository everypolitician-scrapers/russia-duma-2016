#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'pry'
require 'require_all'
require 'scraped'
require 'scraperwiki'

require_rel 'lib'

# require 'open-uri/cached'
# OpenURI::Cache.cache_path = '.cache'
require 'scraped_page_archive/open-uri'

class String
  def tidy
    gsub(/[[:space:]]+/, ' ').strip
  end
end

url = 'http://www.duma.gov.ru/structure/deputies/?letter=%D0%92%D1%81%D0%B5'
page = AllMembersPage.new(response: Scraped::Request.new(url: url).response)

warn "Found #{page.members.count} members"
page.members.each do |mem|
  data = mem.merge MemberPage.new(response: Scraped::Request.new(url: mem[:source]).response).to_h
  # warn data
  ScraperWiki.save_sqlite(%i(id), data)
end
