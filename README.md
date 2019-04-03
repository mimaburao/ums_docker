# ums_docker
Universal Media server8.0(以下UMS)以上をDocker上で動かすDockerfileである。

2019/04/03

# Dependency
Docker Docker version 18.09.4

Linux Mint 19.1にて動作確認

# Setup
作業ディレクトリを作成する。（ここではworkフォルダ）

git pullで引っ張ってきたディレクトリに移動する。

Dockerが利用できるユーザー上でイメージをビルトする。
> docker build ./ -t ums/mima(好きなイメージ名)

次にUMSが利用するデータベース用フォルダを作成
>mkdir data \
>mkdir database \
注意として各フォルダは読み書き自由な権限にすることである

そして、UMS.conf.sampleを適時編集してUMS.confとして保存する。

UMS.confの詳細はUMS公式(https://www.universalmediaserver.com/)を参照のこと

# Usage
初回は起動を確認する。下記コマンドを実行後、webブラウザーでlocalhost:5001にアクセスして立ち上げを確認する。
>docker run --net=host --restart=always --name ums \
-v ~/work/ums_docker/UMS.conf:/opt/ums/UMS.conf \
-v ~/work/ums_docker/data:/opt/ums/data \
-v ~/work/ums_docker/database:/opt/ums/database ums/mima

一旦イメージをストップして削除する。次にメディアファイルのあるディレクトリを-vオプションでdocker上の/media以下にボリュームマウントして起動する。初回はデータベースの構築に時間がかかる。（公式より）

例:
>docker run --net=host --restart=always --name ums \
-v /home/mima/work/ums_docker/UMS.conf:/opt/ums/UMS.conf \
-v /mnt/hdd_x/tmp/ums/data:/opt/ums/data \
-v /mnt/hdd_x/tmp/ums/database:/opt/ums/database \
-v /media:/media ums/mima

問題なくwebブラウザーやDLNAからアクセスできることを確認したら、"-d"コマンドをつけてデーモンとして起動する。以下のコマンドをスクリプト化してもいい。

例:
>docker run -d --net=host --restart=always --name ums \
-v /home/mima/work/ums_docker/UMS.conf:/opt/ums/UMS.conf \
-v /mnt/hdd_x/tmp/ums/data:/opt/ums/data \
-v /mnt/hdd_x/tmp/ums/database:/opt/ums/database \
-v /media:/media ums/mima

注意として、"-d"コマンドにて起動した場合はリブート後も起動したイメージが残っているため、リブートも前にdocker rmにてイメージを削除すること

# Licence
This software is released under the MIT License, see LICENSE.md.

# Authors
Burao Mima

# References
UMS公式(https://www.universalmediaserver.com/)