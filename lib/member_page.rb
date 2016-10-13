# frozen_string_literal: true

require_relative 'page'

class MemberPage < Page
  field :id do
    Pathname.new(url.to_s).basename.to_s
  end

  field :birth_date do
    date_from(noko.css('p.deputat-info-date').text)
  end

  field :start_date do
    date_from(noko.xpath('//p[contains(.,"Дата начала полномочий")]').text)
  end

  field :area_id do
    area_id_from(noko.xpath('//p[contains(.,"избирательного округа")]').text)
  end

  private

  MONTHS = %w(_ января февраля марта апреля мая июня июля августа
              сентября октября ноября декабря).freeze

  def date_from(str)
    return unless md = str.to_s.match(/(\d{1,2}) (.*?) (\d{4})/)
    '%d-%02d-%02d' %
      [md.captures[2], MONTHS.find_index(md.captures[1]), md.captures[0]]
  end

  def area_id_from(str)
    return if str.to_s.empty?
    str[/избирательного округа\s+(\d+)/, 1]
  end
end
