#!/bin/bash
set -eux
source ../../.env

function develop (){
    make up
    test_http.sh develop
}

function deploy (){
    make deploy
    test_http.sh deploy
}

develop
deploy

develop
deploy
