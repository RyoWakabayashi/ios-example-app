#!/bin/zsh
set -e

BASE=`pwd`
export MIX_ENV=prod
export MIX_TARGET=ios

if [ ! -d "elixir-app" ]; then
  git clone https://github.com/RyoWakabayashi/yolo-on-elixir-desktop.git elixir-app
fi

cd elixir-app

mix clean
mix deps.clean --all
rm -f mix.lock
mix deps.get

if [ ! -d "assets/node_modules" ]; then
  cd assets && npm i && cd ..
fi

if [ -f "$BASE/yoloapp/app.zip" ]; then
  rm "$BASE/yoloapp/app.zip"
fi

mix assets.deploy && \
  mix release --overwrite && \
  cd _build/ios_prod/rel/yolo_app && \
  zip -9r "$BASE/yoloapp/app.zip" lib/ releases/ --exclude "*.so"
