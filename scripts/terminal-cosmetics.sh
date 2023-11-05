#!/bin/bash

########################
## Terminal Cosmetics ##
########################

WHITE_TEXT=$(tput sgr0; tput setaf 7)
BOLD_UNDERLINED_LIME_TEXT=$(tput sgr0; tput smul; tput bold; tput setaf 190)
BOLD_LIME_TEXT=$(tput sgr0; tput bold; tput setaf 190)
POWDERBLUE_TEXT=$(tput sgr0; tput setaf 153)
BOLD_RED_TEXT=$(tput sgr0; tput bold; tput setaf 1)

## Format of different Interface parts
FORMAT_NORMAL=${WHITE_TEXT}
FORMAT_TITLE=${BOLD_UNDERLINED_LIME_TEXT}
FORMAT_HIGHLIGHT_1=${BOLD_LIME_TEXT}
FORMAT_HIGHLIGHT_2=${POWDERBLUE_TEXT}
FORMAT_ERROR=${BOLD_RED_TEXT}
