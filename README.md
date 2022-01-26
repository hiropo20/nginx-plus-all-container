
# 手順
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

