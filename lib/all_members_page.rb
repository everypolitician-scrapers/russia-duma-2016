# frozen_string_literal: true
require 'scraped'

class AllMembersPage < Scraped::HTML
  decorator Scraped::Response::Decorator::AbsoluteUrls

  field :member_urls do
    noko.xpath('id("lists_list_elements_35")//tr[td]//td[1]//a/@href').map(&:text)
  end
end
