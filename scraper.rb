#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'pry'
require 'require_all'
require 'scraped'
require 'scraperwiki'

require_rel 'lib'

require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

def scrape(h)
  url, klass = h.to_a.first
  klass.new(response: Scraped::Request.new(url: url).response)
end

CEASED_MEMBER_IDS = %w[1756605 1756928 1757002].freeze
ceased_member_urls = CEASED_MEMBER_IDS.map { |id| "http://www.duma.gov.ru/structure/deputies/#{id}/" }

url = 'http://www.duma.gov.ru/structure/deputies/?letter=%D0%92%D1%81%D0%B5'
current_member_urls = scrape(url => AllMembersPage).member_urls
member_urls = current_member_urls + ceased_member_urls
warn "Found #{member_urls.count} members"

data = member_urls.map { |url| scrape(url => MemberPage).to_h }
data.each { |mem| puts mem.reject { |_, v| v.to_s.empty? }.sort_by { |k, _| k }.to_h } if ENV['MORPH_DEBUG']

ScraperWiki.sqliteexecute('DROP TABLE data') rescue nil
ScraperWiki.save_sqlite(%i[id], data)
