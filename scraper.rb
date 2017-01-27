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

def scrape(h)
  url, klass = h.to_a.first
  klass.new(response: Scraped::Request.new(url: url).response)
end

url = 'http://www.duma.gov.ru/structure/deputies/?letter=%D0%92%D1%81%D0%B5'
member_urls = scrape(url => AllMembersPage).member_urls
warn "Found #{member_urls.count} members"

ScraperWiki.sqliteexecute('DELETE FROM data') rescue nil
member_urls.each do |mem_url|
  data = scrape(mem_url => MemberPage).to_h
  ScraperWiki.save_sqlite(%i(id), data)
end
