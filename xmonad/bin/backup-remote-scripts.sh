#!/bin/bash

# rsync remote files

rm -rf ~/Downloads/*

rsync -6 -Lavze ssh config@usdsb:ECR-SCRIPTS/ --exclude=".*" ~/Downloads/ && \
rm -rf ~/Google-Drive/Linux/BETHEL/ECR-SCRIPTS/* && \
mv ~/Downloads/* ~/Google-Drive/Linux/BETHEL/ECR-SCRIPTS/

rsync -6 -Lavze ssh config@usdsb:SCRIPTS/ --exclude=".*" ~/Downloads/ && \
rm -rf ~/Google-Drive/Linux/BETHEL/SCRIPTS/* && \
mv ~/Downloads/* ~/Google-Drive/Linux/BETHEL/SCRIPTS/

rsync -6 -Lavze ssh config@usdsb:DATACOM/ --exclude=".*" ~/Downloads/ && \
rm -rf ~/Google-Drive/Linux/BETHEL/DATACOM/* && \
mv ~/Downloads/* ~/Google-Drive/Linux/BETHEL/DATACOM/

rsync -6 -Lavze ssh config@usdsb:nelkit/rules/ --exclude=".*" ~/Downloads/ && \
rm -rf ~/Google-Drive/Linux/BETHEL/nelkit/* && \
mv ~/Downloads/* ~/Google-Drive/Linux/BETHEL/nelkit/

rsync -6 -Lavze ssh $USER@usdsb: --exclude="*/temp" --exclude=".*" ~/Downloads/ && \
rm -rf ~/Google-Drive/Linux/BETHEL/SHELL/* && \
mv ~/Downloads/* ~/Google-Drive/Linux/BETHEL/SHELL/
