# frozen_string_literal: true
require 'scraped'

class AllMembersPage < Scraped::HTML
  decorator Scraped::Response::Decorator::AbsoluteUrls

  field :members do
    noko.xpath('id("lists_list_elements_35")//tr[td]').map do |tr|
      tds = tr.css('td')
      {
        name:    tds[1].text.tidy,
        faction: tds[2].text.sub('Фракция ', '').tidy,
        area:    tds[4].text.tidy,
        image:   tds[0].css('img/@src').text,
        source:  tds[1].css('a/@href').text,
      }
    end
  end

  field :member_urls do
    noko.xpath('id("lists_list_elements_35")//tr[td]//td[1]//a/@href').map(&:text)
  end
end
