
# 1. ファイルの内容
- nginx-all-docker-compose.yaml
  - Docker Composeファイル
  - ./config 配下のどのフォルダをマウントするか用途に合わせて選択する
- ./config/conf.d
  - シンプルな設定
- ./config/lua-conf.d
  - lua を用いたサンプル
  - ``/`` : HTTPリクエストのHeader情報をHTMLで表示する
  - ``/wait`` : 一定秒数の後、応答する。デフォルト1秒。uri args の sec で秒数を指定できる。(例:sec=3)
- ./config/njs-conf.d
  - njs を用いたサンプル
  - ``/`` で関数を指定することにより応答を変更できる 
    - main.hello :: シンプルな文字列を返す
    - main.headers :: JS配列形式で request headerを返す
    - main.args :: JS配列形式で request argsを返す
    - main.reqall :: JS配列形式で 複数のrequest の情報を返す
  - ``/wait`` : 一定秒数の後、応答する。デフォルト1秒。uri args の msec で秒数を指定できる。(例:msec=3000)
- ./config/waf-conf.d
  - シンプルなWAF設定

# 2. 利用方法

```
cd ~/nginx-plus-all-container/docker-comopse
docker-compose -f nginx-all-docker-compose.yaml up -d
```

他の設定を読み込む場合
```
# vi nginx-all-docker-compose.yaml
docker-compose -f nginx-all-docker-compose.yaml restart
```

# 3.動作確認

## NJS / LUA
```
curl -H "Host: webapp.example.com" "http://localhost/wait?msec=3000"  
※ JSの場合msec、LUAの場合secを指定します
```
指定した秒数停止した後、応答を返します
```
wait 3000msec 
※ JSの場合msec、LUAの場合secの表示となります
```

```
curl -H "Host: webapp.example.com" "http://localhost/?a=1&b=2" -X POST -d '{"Name":"sample123"}' 

※ 利用する関数に応じた結果が表示されます ※
```

main.reqall を指定した場合の実行例

```
$ curl -s -H "Host: webapp.example.com" "http://localhost/?a=1&b=2,3,4,5" -X POST -d '{"Name":"dummy-data"}' | jq
=====Serviceに到達したリクエストの情報が以下の様に表示される
{
  "headers": [
    [
      "Connection",
      "close"
    ],
    [
      "X-Real-IP",
      "10.1.1.9"
    ],
    [
      "X-Forwarded-For",
      "10.1.1.9"
    ],
    [
      "X-Forwarded-Host",
      "webapp.example.com"
    ],
    [
      "X-Forwarded-Port",
      "80"
    ],
    [
      "X-Forwarded-Proto",
      "http"
    ],
    [
      "Host",
      "webapp.example.com"
    ],
    [
      "Content-Length",
      "21"
    ],
    [
      "User-Agent",
      "curl/7.68.0"
    ],
    [
      "Accept",
      "*/*"
    ],
    [
      "Content-Type",
      "application/x-www-form-urlencoded"
    ]
  ],
  "status": 0,
  "httpversion": "1.1",
  "method": "POST",
  "uri": "/",
  "args": [
    [
      "a",
      "1"
    ],
    [
      "b",
      "2,3,4,5"
    ]
  ],
  "reqbody": "{\"Name\":\"dummy-data\"}"
}
```


## WAF
Log転送先設定の変更

以下、Directiveの宛先を適切なSyslogサーバへ変更してください
```
        app_protect_security_log "/etc/nginx/conf.d/custom_log_format.json" syslog:server=127.0.0.1:514;
```

正常な通信の結果
```
$ curl "http://localhost/"
nginx-plus-all
```

攻撃をブロックした場合の結果
```
$ curl "http://localhost/?<script>"
<html><head><title>Request Rejected</title></head><body>The requested URL was rejected. Please consult with your administrator.<br><br>Your support ID is: 3509312729745697583<br><br><a href='javascript:history.back();'>[Go Back]</a></body></html>ubuntu@ip-10-1-1-8:~/nginx-plus-all-container/kubernetes$
```

ターミナルのログ
```
$ docker logs nginx-plus-all
※省略※
127.0.0.1 - - [27/Jan/2022:00:23:37 +0000] "GET / HTTP/1.1" 200 15 "-" "curl/7.68.0" "10.1.1.9"
192.168.127.15 - - [27/Jan/2022:00:23:37 +0000] "GET / HTTP/1.1" 200 15 "-" "curl/7.68.0" "10.1.1.9"
192.168.127.15 - - [27/Jan/2022:00:23:45 +0000] "GET /?<script> HTTP/1.1" 200 246 "-" "curl/7.68.0" "10.1.1.9"

```