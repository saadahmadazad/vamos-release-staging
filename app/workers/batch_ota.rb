class BatchOta
  class << self
    def add_default
      Facility.all.each do |f|
        puts "#{f.id}回目の処理を開始します"
        # Otumテーブルのfacility_id毎に、デフォルトレコードが存在するか検索し、オブジェクトを代入
        otum = Otum.find_by(facility_id: f.id, provider: "default")

        # 条件分岐でexist変数がnilだったらみたいな感じ？
        if otum.nil?
          puts "default追加処理実行 理由：Facility.idが「#{f.id}」、「#{f.name}」の施設にはdefaultが存在しない。"
          o = Otum.new
          o.provider = 'default'
          o.facility_id = f.id
          o.status = :active
          o.account = 'default'
          o.set_encrypt_password('default')
          if o.save
            puts "default追加処理成功"
            puts "facilityの全roomに対して、defaultと関連したota_room作成"

            # Facility（施設）テーブルに属するRoomテーブルに登録されてる、部屋に対応したota_roomテーブルにレコード追加
            # Room.where(facility_id: f.id).each do |r|
            f.rooms.each do |r|
              # OtaRoomテーブルにuid,statusカラムのレコード追加
              ota_room = OtaRoom.new
              ota_room.room = r
              ota_room.otum = o
              if ota_room.save
                puts "room追加処理成功"
              else
                puts "room追加処理失敗"
              end
            end
          else
            puts "default追加処理中断 理由：otumテーブルにdefaultレコード追加処理が失敗"
          end
        else
          puts "追加処理不実行 理由：Facility.idが#{f.id}の施設にはdefaultが存在する。"
        end
      end
    end
  end
end
