# -*- coding: utf-8 -*-
require 'open-uri'
require 'nokogiri'
require 'mechanize'
require 'dotenv'
require 'pry'

Dotenv.load

agent = Mechanize.new
agent.user_agent = 'Mac Mozilla';
# ログイン
agent.get('https://manage.travel.rakuten.co.jp/portal/inn/mp_kanri.main') do |page|
  dashboard = page.form_with(action: '/portal/inn/mp_kanri.main') do |form|
    # puts form.inspect
    formdata = {
      flag: 'LOGIN',
      lang: 'J',
      id: ENV['RAKUTEN_TEST_ID'],
      password: ENV['RAKUTEN_TEST_PW']
      # password: 'xxx'
    }
    form.field_with(name: 'f_flg').value = formdata[:flag]
    form.field_with(name: 'f_lang').value = formdata[:lang]
    form.field_with(name: 'f_id').value = formdata[:id]
    form.field_with(name: 'f_pass').value = formdata[:password]
  end.submit

  puts dashboard.code

  # ===========================
  # 部屋管理TOP
  #
  # rooms_page = dashboard.form_with(action: 'mp_kanri_stock.main').submit
  # # idを取得
  # # 部屋名を取得
  # tds = rooms_page.search('td.h_top_rm_name')
  # tds.each do |td|
  #   puts td.text.strip.split(':').inspect
  # end
  # ===========================


  # ===========================
  # 予約ページ
  #
  puts dashboard.form_with(action: 'mp_kanri_yoyaku.main').nil?.inspect
  reservations_page = dashboard.form_with(action: 'mp_kanri_yoyaku.main').submit

  # 過去一年分の予約を取得
  reservations_result = reservations_page.form_with(action: 'mp_kanri_yoyaku.itiran') do |form|
    # 予約受付日で検索
    form.radiobutton_with(value: 'UKETUKE').check
    # 過去一年分
    year = Time.now.year
    month = Time.now.month
    day = Time.now.day
    form.field_with(name: 'f_nen1').value = (year - 1).to_s
    form.field_with(name: 'f_tuki1').value = month.to_s
    form.field_with(name: 'f_hi1').value = day.to_s
    form.field_with(name: 'f_nen2').value = year.to_s
    form.field_with(name: 'f_tuki2').value = month.to_s
    form.field_with(name: 'f_hi2').value = day.to_s
  end.submit
  # puts reservations_result.inspect

  # detail_page = reservations_result.form_with(action: 'mp_kanri_yoyaku.syosai').submit
  detail_page = reservations_result.forms[10].submit
  # puts detail_page.inspect
  # comment = detail_page.search('body > table > tr > td > table > tr > td > table > tr:nth-child(3) font').text
  # puts comment.inspect

  num = detail_page.search('body > table > tr > td > table > tr > td > table > tr:nth-child(2) table:nth-child(1) tr:nth-child(2) td:nth-child(1) table tr:nth-child(4) td:nth-child(2) b').text.strip.split(/\R/)
  puts num.inspect

  if num.length > 2
    number_males = num[1].gsub(/[^0-9]/,"").to_i
    number_females = num[2].gsub(/[^0-9]/,"").to_i
  else
    if num[1].include?('男性')
      number_males = 1
      number_females = 0
    else
      number_males = 0
      number_females = 1
    end
  end
  puts number_males
  puts number_females

  price_total = 0
  price_balance = 0
  trs = detail_page.search('body > table > tr > td > table > tr > td > table > tr:nth-child(2) table:nth-child(2) tr')
  trs.each do |tr|
    label = tr.search('td:nth-child(1)').text.strip
    content = tr.search('td:nth-child(2)').text.strip
    if label == '料金合計'
      price_total = content.gsub(/[^0-9]/,"").to_i
      puts price_total
    elsif label == '現地精算金額'
      price_balance = content.gsub(/[^0-9]/,"").to_i
      puts price_balance
    end
  end

  price = price_total - price_balance
  puts price_total
  puts price_balance
  puts price

  # ===========================


  # ===========================
  # 在庫
  #
  # rooms_page = dashboard.form_with(action: 'mp_kanri_stock.main').submit

  # # 在庫のページ
  # stock_page = rooms_page.form_with(action: 'mp_kanri_heya_zaiko_touroku.main') do |form|
  #   form.field_with(name: 'f_syu').value = 'test'
  # end.submit
  # puts stock_page.search('input[name=f_touroku_after]')[27]['value'] = 2

  # # result_page = stock_page.form_with(name: 'func2') do |form|
  # stock_page_form1 = stock_page.form_with(name: 'func1')
  # stock_page_form2 = stock_page.form_with(name: 'func2')
  # stock_page.search('input[name=f_touroku_after]').each_with_index do |field, i|
  #   stock_page_form1.add_field!(stock_page.search('input[name=f_touroku_befor]')[i].attr(:name), stock_page.search('input[name=f_touroku_befor]')[i].attr(:value))
  #   stock_page_form1.add_field!(field.attr(:name), field.attr(:value))
  # end
  # stock_page_form2.fields_with(type: 'hidden').each do |field|
  #   stock_page_form1.add_field!(field.name, field.value)
  # end

  # stock_page_form1.action = '/hmsari/setRoomInventoryCalender'
  # result_page = stock_page_form1.submit

  # binding.pry

  # # puts result_page.inspect
  # # ===========================

end