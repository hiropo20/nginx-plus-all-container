
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
## 2. NGINX Plus + NAP WAF + NAP DoS + NJS + LUA のBuild
```
docker build --no-cache -t nginx-plus-all .
```

## 3. Container Imageの登録
作成されたDocker Iamageを適切なContainer Registryに登録

## 4. 利用

### Kubernetes
- [Kubernetes](https://github.com/hiropo20/nginx-plus-all-container/tree/main/kubernetes)   

### Docker-compose
- [docker-compose](https://github.com/hiropo20/nginx-plus-all-container/tree/main/docker-comopse)  