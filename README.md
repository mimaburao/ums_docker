# ums_docker
Universal Media server9.3.0(以下UMS)以上をDocker上で動かすDockerfileである。  
<img src ="https://img.shields.io/badge/Docker-v.18.09.4-green.svg">
<img src ="https://img.shields.io/badge/UMS-9.3.0-blue.svg">
<img src ="https://img.shields.io/badge/Linux_Mint-v.19.3-green.svg">


2019/11/07

# Dependency
Docker Docker version 18.09.4  
Linux Mint 19.3にて動作確認

# Setup
作業ディレクトリを作成する。（ここではworkフォルダ）  
git pullで引っ張ってきたディレクトリに移動する。  
Dockerが利用できるユーザー上でイメージをビルトする。
~~~sh
docker build ./ -t mimaburao/ums(好きなイメージ名)
~~~

次にUMSが利用するデータベース用フォルダを作成
~~~sh
mkdir data
mkdir database
~~~

注意として各フォルダは読み書き自由な権限にすることである  
そして、UMS.conf.sampleを適時編集してUMS.confとして保存する。  
UMS.confの詳細はUMS公式(https://www.universalmediaserver.com/)を参照のこと
UMS.confの修正箇所は３箇所
~~~
language = "ja" #言語設定
folders = /media
network_interface = eth0 #ifconfigにて調べた物理インターフェース名
~~~
UMS.confを書き込み可能とする
~~~sh
chmod a+rw UMS.conf
~~~

# Usage
初回は起動を確認する。下記コマンドを実行後、webブラウザーでlocalhost:5001にアクセスして立ち上げを確認する。
~~~sh
docker run --net=host --restart=always --name ums \
-v ~/work/ums_docker/UMS.conf:/opt/ums/UMS.conf \
-v ~/work/ums_docker/data:/opt/ums/data \
-v ~/work/ums_docker/database:/opt/ums/database mimaburao/ums
~~~
* 前バージョンにて動作していた場合は、data、databaseを一旦削除か、新設する必要が有る。  

一旦イメージをストップして削除する。次にメディアファイルのあるディレクトリを-vオプションでdocker上の/media以下にボリュームマウントして起動する。初回はデータベースの構築に時間がかかる。（公式より）  
例:
~~~sh
docker run --net=host --restart=always --name ums \
v ~/work/ums_docker/UMS.conf:/opt/ums/UMS.conf \
-v ~/work/ums_docker/data:/opt/ums/data \
-v ~/work/ums_docker/database:/opt/ums/database \
-v /media:/media mimaburao/ums
~~~
問題なくwebブラウザーやDLNAからアクセスできることを確認したら、"-d"コマンドをつけてバックグラウンドとして起動する。以下のコマンドをスクリプト化してもいい。  
例:
~~~sh
docker run -d --net=host --restart=always --name ums \
v ~/work/ums_docker/UMS.conf:/opt/ums/UMS.conf \
-v ~/work/ums_docker/data:/opt/ums/data \
-v ~/work/ums_docker/database:/opt/ums/database \
-v /media:/media mimaburao/ums
~~~

注意として、"-d"コマンドにて起動した場合はリブート後もコンテナが動作している。  
コンテナを停止する場合は
~~~
docker rm ums(起動したイメージ名、もしくはdocker ps -aで確認したIDを指定)
~~~

# Licence
This software is released under the MIT License, see LICENSE.md.

# Authors
Burao Mima

# References
UMS公式(https://www.universalmediaserver.com/)
