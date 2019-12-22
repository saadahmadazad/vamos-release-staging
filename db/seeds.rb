# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# サンプルユーザー
users = [
  {
    email: 'yanagi.yoshio@creatorslab.jp',
    name: 'Yanagi Yoshio'
  },
  {
    email: 'daisuketaki@gmail.com',
    name: 'Taki Daisuke',
    role: :admin
  }
]
users.each do |user|
  unless User.exists?(email: user[:email])
    u = User.find_or_initialize_by(user)
    u.password = 'test0123'
    u.save!
  end
end

# 施設
user = User.find_by(email: 'yanagi.yoshio@creatorslab.jp')
facilities = [
  {
    name: 'Guest house HARU',
    location: '〒531-0074 大阪府大阪市北区本庄東1-19-6',
    user: user
  }
]
facilities.each do |facility|
  f = Facility.find_or_initialize_by(facility)
  f.save! if f.new_record?
end

# 部屋
facility = Facility.find_by(name: 'Guest house HARU')
rooms = [
  {
    name: '3人部屋',
    stock_max: 3,
    overbooking_thresh: 1,
    status: :active,
    facility: facility,
    price: 5000.0,
    currency: 'yen-ja',
  },
  {
    name: '4人部屋',
    stock_max: 1,
    overbooking_thresh: 1,
    status: :active,
    facility: facility,
    price: 9000.0,
    currency: 'yen-ja',
  }
]
rooms.each do |room|
  r = Room.find_or_initialize_by(room)
  r.save! if r.new_record?
end

# OTA情報
encryptor = ::ActiveSupport::MessageEncryptor.new(ENV['OTA_SECRET'], cipher: 'aes-256-cbc')
otas = [
  {
    provider: 'rakuten',
    status: :active,
    account: ENV['RAKUTEN_TEST_ID'],
    facility: facility
  }
]
ota_passwords = [
  encryptor.encrypt_and_sign(ENV['RAKUTEN_TEST_PW'])
]
otas.each_with_index do |ota, i|
  o = Otum.find_or_initialize_by(ota)
  o.password = ota_passwords[i]
  o.save! if o.new_record?
end

# OTA-部屋リレーション
ota_rooms = [
  {
    uid: 'triple',
    status: :linked,
    otum: Otum.find_by(provider: 'rakuten', account: ENV['RAKUTEN_TEST_ID']),
    room: Room.find_by(name: '3人部屋'),
  }, {
    uid: 'quad',
    status: :linked,
    otum: Otum.find_by(provider: 'rakuten', account: ENV['RAKUTEN_TEST_ID']),
    room: Room.find_by(name: '4人部屋'),
  }
]
ota_rooms.each do |ota_room|
  o = OtaRoom.find_or_initialize_by(ota_room)
  o.save! if o.new_record?
end