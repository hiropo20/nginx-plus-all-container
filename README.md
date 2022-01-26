
# 手順
## 0. git clone
```
git clone https://github.com/hiropo20/nginx-plus-all-container
```

## 1. ライセンスファイルのコピー
ライセンスファイルを取得し、フォルダにコピーしてください
```
$ ls
nginx-repo.crt  nginx-repo.key
```
## 2. NGINX Plus + NGINX App Protect ContainerのBuild
```
docker build --no-cache -t nginx-plus-all .
```

## 3. Container Imageの登録
作成されたDocker Iamageを適切なContainer Registryに登録

## 4. 利用

### Kubernetes
予めNGINX Ingress Controllerをデプロイしておく

ファイルの内容
- webapp-virtual-server.yaml
  - NGINX Plus All の Service へ通信を転送する Virtual Server設定
- nginx-all-svc.yaml
  - シンプルな設定
- nginx-all-svc_lua.yaml
  - lua を用いたサンプル
  - ``/`` : HTTPリクエストのHeader情報をHTMLで表示する
  - /wait : 1秒後応答する
- nginx-all-svc_njs.yaml 
  - njs を用いたサンプル
  - ``/`` で関数を指定することにより応答を変更できる 
    - main.hello :: シンプルな文字列を返す
    - main.headers :: JS配列形式で request headerを返す
    - main.args :: JS配列形式で request argsを返す
    - main.reqall :: JS配列形式で 複数のrequest の情報を返す


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

動作確認

```
curl -H "Host: webapp.example.com" "http://localhost/?a=1&b=2" -X POST -d '{"Name":"sample123"}' 

※ 利用する関数に応じた結果が表示されます ※
```


### Docker-compose ``作成中``