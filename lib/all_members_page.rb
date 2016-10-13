# frozen_string_literal: true
require_relative 'page'

class AllMembersPage < Page
  field :members do
    noko.xpath('id("lists_list_elements_35")//tr[td]').map do |tr|
      tds = tr.css('td')
      {
        name: tds[1].text.tidy,
        url:  absolute_url(tds[1].css('a/@href').text),
      }
    end
  end
end
