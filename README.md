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
>mkdir data
>mkdir database
注意として各フォルダは読み書き自由な権限にすることである
そして、UMS.conf.sampleを適時編集してUMS.confとして保存する。
UMS.confの詳細はUMS公式(https://www.universalmediaserver.com/)を参照のこと

# Usage
初回は起動を確認する。下記コマンドを実行後、webブラウザーでlocalhost:5001にアクセスして立ち上げを確認する。
>docker run --net=host --restart=always --name ums \
-v ~/work/ums_docker/UMS.conf:/opt/ums/UMS.conf \
-v ~/work/ums_docker/data:/opt/ums/data \
-v ~/work/ums_docker/database:/opt/ums/database ums/mima

次にメディアファイルのあるディレクトリを-vオプションでdocker上の/media以下にボリュームマウントして起動する。
# Licence
This software is released under the MIT License, see LICENSE.

# Authors
作者を明示する。特に、他者が作成したコードを利用する場合は、そのコードのライセンスに従った上で、リポジトリのそれぞれのコードのオリジナルの作者が誰か分かるように明示する（私はそれが良いと思い自主的にしています）。

# References
参考にした情報源（サイト・論文）などの情報、リンク