## ---------------------------------------------------------------------------
## This is the Lucas Vittor Blog Makefile.
##
## Here, we define the project targets to be executed in the development flow.
##
## Help comments are displayed in the order defined within the Makefile.
## ---------------------------------------------------------------------------
##

# *DOCUMENTATION*
# Comments in this file are targeted only to the developer, do not
# expect to learn how to build the blog reading this file.

DRAFTS_DIR:=_drafts
POSTS_DIR:=_posts

_GREEN='\033[0;32m'
_NC='\033[0m' # No Color

title='' # Default value for post titles

define log
	@printf "${_GREEN}$(1)${_NC}\n"
endef

# To see a list of typical targets execute "make help".
# However, for platforms with bash-completion package installed this can be done automatically with tab completion:
# $ make 'space' 'tab' tab'
# Reference: https://stackoverflow.com/questions/4219255/
help:
	@sed -ne '/@sed/!s/## //p' ${MAKEFILE_LIST}

#	$(call log, Available Jekyll compose commands...)
#	bundle exec jekyll help

## install		Install the dependencies specified in the Gemfile.
## 		See ./Gemfile for more details.
install:
	bundle install

## build		Build the Jekyll server version specified in the Gemfile.
##		This target is the first thing you should run after cloning the project.
build:
	bundle exec jekyll build --incremental

## serve		Run the Jekyll server
#
# The --host flag will make Jekyll's HTTP server bind to all available IPs in the LAN.
# This is specially useful for testing the site with another devices (i.e a testing phone, a tablet, etc)
# 
# For example, if you have named your computer username 'johndoe', then you can access
# your Jekyll site at johndoe.local:4000
serve: 
	bundle exec jekyll serve --host 0.0.0.0

## serve_drafts	Run the Jekyll server with drafts enabled.
#
# Same as the "serve" target with drafts enabled.
# Use this target when working in development or writing drafts.
serve_drafts: 
	bundle exec jekyll serve --drafts --host 0.0.0.0


## draft		Create a new draft in the _drafts directory.
## 		Usage: $ make draft title="title-with-kebab-case-style"
#
# The new draft is created under the _drafts/%Y/%m/<draft-title>/%Y-%m-%d-<draft-title>.md directory.
# The %Y (Year) and %m (Month) directories represent the date when the draft is created.
# If the _drafts/%Y/%m/ directory doesn't exist, make parent directories as needed.
DIR_DATE_FMT:=$(shell date +%Y/%m)
POST_PREFIX_DATE_FMT:=$(shell date +%Y-%m-%d)
draft:
	bundle exec jekyll compose ${POST_PREFIX_DATE_FMT}-$(title) --collection "drafts/${DIR_DATE_FMT}/${title}"

## publish		Moves a draft to the _posts directory.
## 		Usage: $ make publish title="already-created-draft-title"
#
# Moves the _drafts/%Y/%m/<draft-title> directory to the _posts/%Y/%m/<post-title> directory.
# The %Y (Year) and %m (Month) directories represent the date when the draft was created.
#
# Note: if the draft has more than one file (i.e images attached to the post), it will also
# copy that content into the _posts/%Y/%m/<post-title> directory.
DRAFT_PATH_TO_PUBLISH:=$(shell find ${DRAFTS_DIR} -type d -name $(title) | cut -d'/' -f2-)
publish:
	mkdir -p ${POSTS_DIR}/${DRAFT_PATH_TO_PUBLISH} 
	mv ${DRAFTS_DIR}/${DRAFT_PATH_TO_PUBLISH} ${POSTS_DIR}/${DRAFT_PATH_TO_PUBLISH}

## clean		Execute a jekyll clean
clean:
	bundle exec jekyll clean