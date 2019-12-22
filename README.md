# README

## はじめに

このレポジトリは開発環境を揃えるためにDocker Composeを内包しています。

## インストール方法

### 1. Dockerイメージのビルド

以下のコマンドでDockerイメージをビルドします。
```
$ docker-compose build
```

### 2. DBのセットアップ
PostgreSQLにデータベースを設定します。
```
$ docker-compose run rails rails db:create
```

```
$ docker-compose run rails rails db:migrate
```

### DBのReset
```
$ docker-compose run rails rails db:reset
```


### 3. Yarn初期化

```
$ docker-compose run rails yarn install
```

## ローカル環境での実行

以下のコマンドでDocker Composeを起動します。

```
$ docker-compose up
```

起動後、[http://localhost:3000](http://localhost:3000) で起動確認がでます。

### データベースの初期データを作成する

データベースにテスト用のレコードを追加することができます。
以下のコマンドで`db/seeds.rb`ファイルのプログラムを実行し、DBに保存します。
```
$ docker-compose run rails rails db:seed
```

### ブッキング情報を取得する

実際のブッキング情報を取得します。
ここからの操作は、「データベースの初期データを作成する」の操作が完了している必要があります。

まずは以下のコマンドでRedis等を起動します。
```
$ docker-compose up
```

コンテナが全て起動した後、別のターミナルタブを開き以下のコマンドでRailsのコンソールを起動します。
```
$ docker-compose run rails rails c
```

Railsのコンソールが起動したら、以下のコマンドでプログラムを走らせます。
```
> RakutenWorker.get_all_bookings
```

この動作にはしばらく時間がかかります。
ブログラムが終了すると、以下のコマンドでコンソールからログアウトします。
```
> exit
```

## こんなときどうする？

### Facilityにdefaultプロバイダが存在しない場合

1. ターミナルでRailsコンソールを起動します。
```
$ docker-compose run rails rails c
```

2. Railsのコンソールが起動したら、以下のコマンドでバッチスクリプトを実行します。
```
> BatchOta.add_default
```


## 環境情報
* Rails version : 5.2.3
* Ruby version : 2.6.2


