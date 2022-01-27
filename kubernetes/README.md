
# 0. NGINX Ingress Controlerのデプロイ
予めNGINX Ingress Controllerをデプロイしておく

# 1. ファイルの内容
- webapp-virtual-server.yaml
  - NGINX Plus All の Service へ通信を転送する Virtual Server設定
- nginx-all-svc.yaml
  - シンプルな設定
- nginx-all-svc_lua.yaml
  - lua を用いたサンプル
  - ``/`` : HTTPリクエストのHeader情報をHTMLで表示する
  - ``/wait`` : 一定秒数の後、応答する。デフォルト1秒。uri args の sec で秒数を指定できる。(例:sec=3)
- nginx-all-svc_njs.yaml 
  - njs を用いたサンプル
  - ``/`` で関数を指定することにより応答を変更できる 
    - main.hello :: シンプルな文字列を返す
    - main.headers :: JS配列形式で request headerを返す
    - main.args :: JS配列形式で request argsを返す
    - main.reqall :: JS配列形式で 複数のrequest の情報を返す

# 2. 利用方法

```
cd ~/nginx-plus-all-container/kubernetes
kubectl apply -f webapp-virtual-server.yaml
kubectl apply -f nginx-all-svc.yaml
```

他の設定を読み込む場合
```
# kubectl replace --force -f <yaml file name>
kubectl replace --force -f nginx-all-svc_njs.yaml
```

# 3.動作確認

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