#!/bin/bash

function check() {
	for j in {1..6}
	do
		FILE=$1$j.png
		echo -n "$FILE: " >> $SAVEFILE
		curl -s https://www.anzen.mofa.go.jp/attached2_master/$FILE|sha1sum|cut -d' ' -f1 >> $SAVEFILE
	done
}

function detect() {
	DIFF=""

	for i in $(diff -u $SAVEFILE $SAVEFILE_OLD|grep '^+'|grep -v '+++'|sed s/\+//|cut -d':' -f1|grep $1)
	do
		curl -s -o $(date +%Y%m%d)$i https://www.anzen.mofa.go.jp/attached2_master/$i
		DIFF=$DIFF" https://www.anzen.mofa.go.jp/attached2_master/"$i
	done
}

pushd $(dirname $(readlink -f $0)) >> /dev/null
source twitter-token-prod.sh

SAVEFILE=mofa.sha
SAVEFILE_OLD=mofa.old.sha

mv $SAVEFILE $SAVEFILE_OLD

check "RiskMap_"
check "InfectionMap_"

detect "RiskMap_"
if [ "$DIFF" != "" ]; then
	twitter "#海外安全情報 危険地図の変更を検知しました！ $DIFF (自動投稿)"
fi

detect "InfectionMap_"
if [ "$DIFF" != "" ]; then
	twitter "#海外安全情報 感染症地図の変更を検知しました！ $DIFF (自動投稿)"
fi

popd >> /dev/null
