#!/bin/bash

screen -ls | grep pl | grep Deta | cut -d. -f1 | xargs kill
