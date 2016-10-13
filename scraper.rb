#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'pry'
require 'require_all'
require 'scraperwiki'

require_rel 'lib'

require 'open-uri/cached'
# require 'scraped_page_archive/open-uri'

LIST_PAGE = 'http://www.duma.gov.ru/structure/deputies/?letter=%D0%92%D1%81%D0%B5'

data = AllMembersPage.new(LIST_PAGE).to_h
warn "Found #{data[:members].count} members"
