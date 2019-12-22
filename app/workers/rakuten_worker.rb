class RakutenWorker
  require 'sidekiq-scheduler'

  # queue_as :rakuten
  include Sidekiq::Worker

  # ---------------------------------------
  # target     | action     | args
  # ---------------------------------------
  # stock      | change     | {ota_room, booking}
  # ---------------------------------------
  # room       | get        | {otum}
  # ---------------------------------------
  # booking    | get_all    | --
  #            | get        | {otum}
  def perform(target, action, args=nil)
    case target
    when 'stock' then
      case action
      when 'change' then
        RakutenWorker.change_roomstock(ota_room, booking) if args.ota_room.instance_of?('OtaRoom') && args.booking.instance_of?('Booking')
      end
    when 'room' then
      case action
      when 'get' then
        RakutenWorker.get_ota_rooms(args.otum) if args.otum.instance_of?('Otum')
      end
    when 'booking' then
      case action
      when 'get_all' then
        RakutenWorker.get_all_bookings()
      when 'get' then
        RakutenWorker.get_ota_bookings(args.otum) if args.otum.instance_of?('Otum')
      end
    when 'room_and_booking' then
      case action
      when 'get' then
        RakutenWorker.get_ota_rooms(args.otum) if args.otum.instance_of?('Otum')
        RakutenWorker.get_ota_bookings(args.otum) if args.otum.instance_of?('Otum')
      end
    end
  end

  class << self
    # =========================
    # 部屋のストックを変更する
    def change_roomstock(ota_room, booking, decrease=true)
      # 管理画面を取得
      dashboard = login(ota_room.otum)
      return nil if dashboard.nil?

      # 部屋管理TOP
      rooms_page = dashboard.form_with(action: 'mp_kanri_stock.main').submit
      if rooms_page.nil?
        notification = Notification.new({
          target_type: 'otum',
          target_id: ota.id,
          profile: 'err_change_room_stock',
          status: :unread,
          url: '/api/v1/ota/' + ota.id.to_s + '/',
          user_id: ota.user.id
        })
        notification.save
        ota_room.otum.status = :error
        ota_room.otum.save
        return nil
      end

      # 在庫のページ
      d = booking.checkin
      while d < booking.checkout # 1日ずつ在庫変更
        stock_page = rooms_page.form_with(action: 'mp_kanri_heya_zaiko_touroku.main') do |form|
          form.field_with(name: 'f_syu').value = ota_room.uid
          form.field_with(name: 'f_hizuke').value = d.strftime("%Y-%m-%d")
        end.submit
        # クロールエラー
        if stock_page.nil?
          notification = Notification.new({
            target_type: 'otum',
            target_id: ota.id,
            profile: 'err_change_room_stock',
            status: :unread,
            url: '/api/v1/ota/' + ota.id.to_s + '/',
            user_id: ota.user.id
          })
          notification.save
          ota_room.otum.status = :error
          ota_room.otum.save
          return nil
        end
        change_roomstock_of_a_day(ota_room, stock_page, d, booking.count_room, decrease)
        d += 1.days
      end
    end

    # =========================
    # １日分のストックを変更
    def change_roomstock_of_a_day(ota_room, page, date, count=1, decrease=true)

      val_prev = page.search('input[name=f_touroku_after]')[date.day-1]['value'].to_i
      if val_prev - count >= 0
        # 変更後の数値をセット
        if decrease
          page.search('input[name=f_touroku_after]')[date.day-1]['value'] = (val_prev - count).to_s
        else
          page.search('input[name=f_touroku_after]')[date.day-1]['value'] = (val_prev + count).to_s
        end

        form1 = page.form_with(name: 'func1')
        form2 = page.form_with(name: 'func2')

        page.search('input[name=f_touroku_after]').each_with_index do |field, i|
          form1.add_field!(page.search('input[name=f_touroku_befor]')[i].attr(:name), page.search('input[name=f_touroku_befor]')[i].attr(:value))
          form1.add_field!(field.attr(:name), field.attr(:value))
        end
        form2.fields_with(type: 'hidden').each do |field|
          form1.add_field!(field.name, field.value)
        end

        form1.action = '/hmsari/setRoomInventoryCalender'
        result = form1.submit
      else
        # オーバーブッキングの場合
        notification = Notification.new({
          target_type: 'ota_room',
          target_id: ota_room.id,
          profile: 'overbooking',
          status: :unread,
          url: '/api/v1/ota_rooms/' + ota_room.id.to_s + '/',
          user_id: ota_room.otum.user.id
        })
        notification.save
      end
    end

    # =========================
    # OtaRoomの取得
    def get_ota_rooms(ota)
      # 管理画面を取得
      dashboard = login(ota)
      return nil if dashboard.nil?

      # 部屋管理TOP
      rooms_page = dashboard.form_with(action: 'mp_kanri_stock.main').submit
      # クロールエラー
      if rooms_page.nil?
        notification = Notification.new({
          target_type: 'otum',
          target_id: ota.id,
          profile: 'err_crawling_get_ota_room',
          status: :unread,
          url: '/api/v1/ota/' + ota.id.to_s + '/',
          user_id: ota.user.id
        })
        notification.save
        ota.status = :error
        ota.save
        return nil
      end

      # 部屋名とIDを取得
      tds = rooms_page.search('td.h_top_rm_name')
      tds.each do |td|
        # 0: ID, 1: 名前
        info = td.text.strip.split(':')
        # OtaRoomのcolumn作成
        OtaRoom.find_or_create_by(ota: ota, uid: info[0]) do |ota_room|
          ota_room.name = info[1]
        end
      end
    end

    # =========================
    # 全てのOTAをクローリング
    def get_all_bookings
      Otum.where.not(provider: 'default').each do |ota|
        get_ota_bookings(ota)
      end
    end

    # =========================
    # 予約一覧を取得
    def get_ota_bookings(ota)
      init_ota_status = ota.status

      # 管理画面を取得
      dashboard = login(ota)
      return nil if dashboard.nil?

      # 予約管理画面へ
      bookings_page = dashboard.form_with(action: 'mp_kanri_yoyaku.main').submit
      # クロールエラー
      if bookings_page.nil?
        notification = Notification.new({
          target_type: 'otum',
          target_id: ota.id,
          profile: 'err_crawling_get_bookings',
          status: :unread,
          url: '/api/v1/ota/' + ota.id.to_s + '/',
          user_id: ota.user.id
        })
        notification.save
        ota.status = :error
        ota.save
        return nil
      end

      # 過去一年分の予約を取得（）
      bookings_result = bookings_page.form_with(action: 'mp_kanri_yoyaku.itiran') do |form|
        # 予約受付日で検索
        form.radiobutton_with(value: 'UKETUKE').check
        year = Time.now.year
        month = Time.now.month
        day = Time.now.day
        if ota.status == 'init'
          # 最初は過去一年分取得
          year_from = Time.now.year - 1
          month_from = Time.now.month
          day_from = Time.now.day
        else
          # それ以外は一日分
          year_from = Time.now.yesterday.year
          month_from = Time.now.yesterday.month
          day_from = Time.now.yesterday.day
        end
        ota.status = :sync
        ota.save
        form.field_with(name: 'f_nen1').value = year_from.to_s
        form.field_with(name: 'f_tuki1').value = month_from.to_s
        form.field_with(name: 'f_hi1').value = day_from.to_s
        form.field_with(name: 'f_nen2').value = year.to_s
        form.field_with(name: 'f_tuki2').value = month.to_s
        form.field_with(name: 'f_hi2').value = day.to_s

        # puts form.inspect
      end.submit
      # クロールエラー
      if bookings_result.nil?
        notification = Notification.new({
          target_type: 'otum',
          target_id: ota.id,
          profile: 'err_crawling_get_bookings',
          status: :unread,
          url: '/api/v1/ota/' + ota.id.to_s + '/',
          user_id: ota.user.id
        })
        notification.save
        ota.status = :error
        ota.save
        return nil
      end

      # 予約を一つずつ確認
      bookings_result.forms.each do |form|
        # 関係ないフォームは無視する
        next if form.action != 'mp_kanri_yoyaku.syosai'

        # 予約DBを生成する
        if find_or_create_booking(ota, form).nil?
          # クロールエラー
          if bookings_result.nil?
            notification = Notification.new({
              target_type: 'otum',
              target_id: ota.id,
              profile: 'err_crawling_get_bookings',
              status: :unread,
              url: '/api/v1/ota/' + ota.id.to_s + '/',
              user_id: ota.user.id
            })
            notification.save
            ota.status = :error
            ota.save
            return nil
          end
        end
      end

      # otaのステータス変更
      ota.status = :active
      ota.save
    end

    # =========================
    # 一つのOTAに対してcancel
    def get_ota_cancels(ota)
      # 管理画面を取得
      dashboard = login(ota)
      return nil if dashboard.nil?

      # 予約管理画面へ
      bookings_page = dashboard.form_with(action: 'mp_kanri_yoyaku.main').submit
      # クロールエラー
      if bookings_page.nil?
        notification = Notification.new({
          target_type: 'otum',
          target_id: ota.id,
          profile: 'err_crawling_get_bookings',
          status: :unread,
          url: '/api/v1/ota/' + ota.id.to_s + '/',
          user_id: ota.user.id
        })
        notification.save
        ota.status = :error
        ota.save
        return nil
      end
      # 過去一年分の予約を取得（）
      bookings_result = bookings_page.form_with(action: 'mp_kanri_yoyaku.itiran') do |form|
        # 予約受付日で検索
        form.radiobutton_with(value: 'CANCEL').check
        year = Time.now.year
        month = Time.now.month
        day = Time.now.day
        # 一日分
        year_from = Time.now.yesterday.year
        month_from = Time.now.yesterday.month
        day_from = Time.now.yesterday.day
        # OTAステータスを同期中に変更
        ota.status = :sync
        ota.last_crawl_at = Time.now
        ota.save
        form.field_with(name: 'f_nen1').value = year_from.to_s
        form.field_with(name: 'f_tuki1').value = month_from.to_s
        form.field_with(name: 'f_hi1').value = day_from.to_s
        form.field_with(name: 'f_nen2').value = year.to_s
        form.field_with(name: 'f_tuki2').value = month.to_s
        form.field_with(name: 'f_hi2').value = day.to_s
      end.submit
      if bookings_result.nil?
        notification = Notification.new({
          target_type: 'otum',
          target_id: ota.id,
          profile: 'err_crawling_get_bookings',
          status: :unread,
          url: '/api/v1/ota/' + ota.id.to_s + '/',
          user_id: ota.user.id
        })
        notification.save
        ota_room.otum.status = :error
        ota_room.otum.save
        return nil
      end

      # 予約を一つずつ確認
      bookings_result.forms.each do |form|
        # 関係ないフォームは無視する
        next if form.action != 'mp_kanri_yoyaku.syosai'

        # 予約DBを生成する
        if update_cancel_status(ota, form).nil?
          # クロールエラー
          if bookings_result.nil?
            notification = Notification.new({
              target_type: 'otum',
              target_id: ota.id,
              profile: 'err_crawling_get_bookings',
              status: :unread,
              url: '/api/v1/ota/' + ota.id.to_s + '/',
              user_id: ota.user.id
            })
            notification.save
            ota.status = :error
            ota.save
            return nil
          end
        end
      end

      # otaのステータス変更
      ota.status = :active
      ota.save
    end

    # =========================
    # ログインし、ダッシュボードページを返す
    def login(ota)
      agent = Mechanize.new
      agent.user_agent = 'Mac Mozilla';
      page = agent.get('https://manage.travel.rakuten.co.jp/portal/inn/mp_kanri.main')

      response = page.form_with(action: '/portal/inn/mp_kanri.main') do |form|
        formdata = {
          flag: 'LOGIN',
          lang: 'J',
          id: ota.account,
          password: ota.decrypt_password
        }
        form.field_with(name: 'f_flg').value = formdata[:flag]
        form.field_with(name: 'f_lang').value = formdata[:lang]
        form.field_with(name: 'f_id').value = formdata[:id]
        form.field_with(name: 'f_pass').value = formdata[:password]
      end.submit

      # return nil unless response.form_with(action: '/portal/inn/mp_kanri.main').nil?
      if response.search('table table table table table tr:nth-child(2) center strong').text.strip.include?('ＩＤまたはパスワードに誤りがあります。')
        # ログイン失敗
        notification = Notification.new({
          target_type: 'otum',
          target_id: ota.id,
          profile: 'err_login',
          status: :unread,
          url: '/api/v1/ota/' + ota.id.to_s + '/',
          user_id: ota.user.id
        })
        notification.save
        ota.status = :error
        ota.save
        return nil
      end
      return response
    end

    # =========================
    # 予約番号が存在していなければ予約を作成する
    def find_or_create_booking(ota, form)
      # 違うコントローラーが来たらnilを返す
      return nil if form.action != 'mp_kanri_yoyaku.syosai'

      # 詳細ボタンからキャンセル済かどうか判断
      canceled = form.button_with(value: '詳細').nil?
      room_uid = form.field_with(name: 'f_syu').value

      # 予約の存在確認
      booking_id = form.field_with(name: 'f_yoyaku_no').value
      booking = Booking.find_by(uid: booking_id)
      if booking.nil? || booking.otum.provider != 'rakuten'
        # 予約が存在しなかった場合、新規作成
        detail_page = form.submit
        params = {
          booking_id: booking_id,
          ota: ota,
          canceled: canceled,
          room_uid: room_uid
        }
        booking = create_booking_from_page( detail_page, params )
      else
        # 予約が存在する場合、ステータスだけ確認
        if canceled
          booking.status = :canceled
        else
          booking.status = :active
        end
        return nil unless booking.save
      end
      return booking
    end

    # =========================
    # ステータスをcancelに変更
    def update_cancel_status(ota, form)
      # 違うコントローラーが来たらnilを返す
      return nil if form.action != 'mp_kanri_yoyaku.syosai'

      # 詳細ボタンからキャンセル済かどうか判断
      canceled = form.button_with(value: '詳細').nil?
      room_uid = form.field_with(name: 'f_syu').value

      # 予約の存在確認
      booking_id = form.field_with(name: 'f_yoyaku_no')
      booking = Booking.find_by(uid: booking_id)
      if booking.nil? || booking.otum.provider != 'rakuten'
        # 予約が存在しなかった場合、新規作成
        detail_page = form.submit
        params = {
          booking_id: booking_id,
          ota: ota,
          canceled: canceled,
          room_uid: room_uid
        }
        booking = create_booking_from_page( detail_page, params )
      else
        # 予約が存在する場合、ステータスだけ確認
        if canceled
          boooking.status = :canceled
        else
          boooking.status = :active
        end
        return nil unless booking.save
      end
      return booking
    end

    # 予約詳細ページからブッキング情報を取得し、新しくレコードを作成
    def create_booking_from_page(page, params)
      puts params.inspect

      # チェックイン時間
      checkin_str = page.search('body > table > tr > td > table > tr > td > table > tr:nth-child(2) table:nth-child(1) tr:nth-child(2) td:nth-child(1) table tr:nth-child(1) td:nth-child(2) b').text.strip
      if checkin_str.include?('[--:--]')
        checkin = DateTime.strptime(checkin_str, '%Y-%m-%d[--:--]')
      else
        checkin = DateTime.strptime(checkin_str, '%Y-%m-%d[%H:%M]')
      end
      # チェックアウト時間
      checkout_str = page.search('body > table > tr > td > table > tr > td > table > tr:nth-child(2) table:nth-child(1) tr:nth-child(2) td:nth-child(1) table tr:nth-child(2) td:nth-child(2) b').text.strip
      checkout = DateTime.strptime(checkout_str, '%Y-%m-%d')
      # OtaRoomのuid
      uid = params[:room_uid]
      # 宿泊者
      booking_infos = page.search('body > table > tr > td > table > tr > td > table > tr:nth-child(2) table:nth-child(1) tr:nth-child(2) td:nth-child(1) table tr:nth-child(4) td:nth-child(2) b').text.strip.split(/\R/)
      guest_name = booking_infos[0]
      guest_kana = guest_name
      # 人数
      if booking_infos.length > 2
        number_males = booking_infos[1].gsub(/[^0-9]/,"").to_i
        number_females = booking_infos[2].gsub(/[^0-9]/,"").to_i
      else
        if booking_infos[1].include?('男性')
          number_males = 1
          number_females = 0
        else
          number_males = 0
          number_females = 1
        end
      end
      number_total = number_males + number_females
      booking_number = page.search('body > table > tr > td > table > tr > td > table > tr:nth-child(2) table:nth-child(1) tr:nth-child(2) td:nth-child(2) table tr:nth-child(1) td:nth-child(2) b').text.strip.split(/\R/)
      number_adults = booking_number[0].gsub(/[^0-9]/,"").to_i
      number_children = booking_number[1].gsub(/[^0-9]/,"").to_i
      # 電話番号
      subscriber_tel = page.search('body > table > tr > td > table > tr > td > table > tr:nth-child(2) table:nth-child(1) tr:nth-child(2) td:nth-child(1) table tr:nth-child(4) td:nth-child(2) b').text.strip
      # 予約者
      subscriber_page = page.form_with(action: 'hotels.kaiin').submit
      subscriber_name = subscriber_page.search('table:nth-child(6) tr:nth-child(1) td:nth-child(2)').text.strip
      subscriber_kana = subscriber_page.search('table:nth-child(6) tr:nth-child(2) td:nth-child(2)').text.strip
      subscriber_address = subscriber_page.search('table:nth-child(6) tr:nth-child(3) td:nth-child(2)').text.strip
      subscriber_tel = subscriber_page.search('table:nth-child(6) tr:nth-child(4) td:nth-child(2)').text.strip
      # 金額
      trs = page.search('body > table > tr > td > table > tr > td > table > tr:nth-child(2) table:nth-child(2) tr')
      price_total = 0
      price_balance = 0
      trs.each do |tr|
        label = tr.search('td:nth-child(1)').text.strip
        content = tr.search('td:nth-child(2)').text.strip
        if label == '料金合計'
          price_total = content.gsub(/[^0-9]/,"").to_i
        elsif label == '現地精算金額'
          price_balance = content.gsub(/[^0-9]/,"").to_i
        end
      end
      price = price_total - price_balance
      # 備考
      comment = page.search('body > table > tr > td > table > tr > td > table > tr:nth-child(3) font').text

      # レコードの生成
      ota_room = OtaRoom.find_by(otum_id: params[:ota].id, uid: params[:room_uid])
      if ota_room.nil?
        puts 'can not find ota_room'
        return nil
      end
      booking = Booking.create!(
        uid: params[:booking_id],
        status: params[:canceled] ? :canceled : :active,
        ota_room: ota_room,
        checkin: checkin,
        checkout: checkout,
        count_room: 1,
        price: price,
        price_balance: price_balance,
        price_total: price_total,
        subscriber_name: subscriber_name,
        subscriber_kana: subscriber_kana,
        subscriber_tel: subscriber_tel,
        subscriber_email: '',
        subscriber_address: subscriber_address,
        guest_name: guest_name,
        guest_kana: guest_kana,
        number_total: number_total,
        number_males: number_males,
        number_females: number_females,
        number_adults: number_adults,
        number_children: number_children,
        currency: 'yen-ja',
        comment: comment
      )
    end
  end
end
