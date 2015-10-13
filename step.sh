#!/usr/bin/env bash

set +x
cat << task

    Compile

task
(rm -rf bin && mkdir bin) || exit
mkdir bin/com.socket
mkdir bin/com.greetings
mkdir bin/org.fastsocket
set -x

javac -d bin/com.socket \
    $(find src/com.socket -name '*.java') || exit

javac -d bin/com.greetings \
    -modulepath bin \
    $(find src/com.greetings -name '*.java') || exit

javac -d bin/org.fastsocket \
    -modulepath bin \
    $(find src/org.fastsocket -name '*.java') || exit

find bin -type f


set +x
cat << task

    Assemble

task
(rm -rf lib && mkdir lib) || exit
set -x

jar --create --archive=lib/com.socket.jar \
    -C bin/com.socket . || exit

jar --print-module-descriptor --archive=lib/com.socket.jar || exit

jar --create --archive=lib/com.greetings.jar \
    --main-class=com.greetings.Main \
    -C bin/com.greetings . || exit

jar --print-module-descriptor --archive=lib/com.greetings.jar || exit

jar --create --archive=lib/org.fastsocket.jar \
    -C bin/org.fastsocket . || exit

jar --print-module-descriptor --archive=lib/org.fastsocket.jar || exit


set +x
cat << task

    Run

task
set -x

java \
    -modulepath lib \
    -m com.greetings
