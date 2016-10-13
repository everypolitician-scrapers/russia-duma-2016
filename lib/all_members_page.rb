# frozen_string_literal: true
require_relative 'page'

class AllMembersPage < Page
  field :members do
    noko.xpath('id("lists_list_elements_35")//tr[td]').map do |tr|
      tds = tr.css('td')
      {
        name:    tds[1].text.tidy,
        faction: tds[2].text.sub('Фракция ', '').tidy,
        area:    tds[4].text.tidy,
        image:   absolute_url(tds[0].css('img/@src').text).to_s,
        source:  absolute_url(tds[1].css('a/@href').text).to_s,
      }
    end
  end
end
