DRAFTS_DIR:=_drafts
POSTS_DIR:=_posts

# List available targets
#
# Executing this target is always the recommended
# method for listing the available targets.
#
# However, for platforms with bash-completion 
# package installed this can be done automatically
# with tab completion: 
# > make 'space' 'tab' tab'
# 
# Reference: https://stackoverflow.com/questions/4219255/
_GREEN='\033[0;32m'
_NC='\033[0m' # No Color
help: 
	@printf "${_GREEN}Available Makefile targets are...${_NC}\n"
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null \
	| awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' \
	| sort \
	| egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

	@printf "\n${_GREEN}Available Jekyll compose commands...${_NC}\n"
	bundle exec jekyll help

# Install the dependencies specified in the Gemfile
#
# See the file "Gemfile" for more details
install:
	bundle install

# Build the Jekyll server version specified in the Gemfile
#
# This target is the first thing you should run 
# after cloning the project.
build:
	bundle exec jekyll build --incremental

# Run the Jekyll server
#
# The --host flag will make Jekyll's HTTP server bind to 
# all available IPs in the LAN. 
# 
# This is specially useful for testing the site with 
# another devices (i.e a testing phone, a tablet, etc)
# 
# For example, if you have named your computer username 
# 'johndoe', then you can acces your Jekyll site at 
# johndoe.local:4000
serve: 
	bundle exec jekyll serve --host 0.0.0.0

# Run the Jekyll server with drafts enabled
#
# Same as the "serve" target with drafts enabled.
#
# Use this target when working in development or
# writing drafts.
serve_drafts: 
	bundle exec jekyll serve --drafts --host 0.0.0.0


# Creates a new draft in the _drafts directory
#
# Usage:
#	make draft title="title-with-kebab-case-style"
#
# The new draft is created under the 
# _drafts/%Y/%m/<draft-title>/%Y-%m-%d-<draft-title>.md
# directory. The %Y (Year) and %m (Month) directories 
# represent the date when the draft is created. 
# 
# If the _drafts/%Y/%m/ directory doesn't exist, 
# make parent directories as nedeed.
DIR_DATE_FMT:=$(shell date +%Y/%m)
POST_PREFIX_DATE_FMT:=$(shell date +%Y-%m-%d)
draft:
	bundle exec jekyll compose ${POST_PREFIX_DATE_FMT}-$(title) --collection "drafts/${DIR_DATE_FMT}/${title}"

# Moves a draft to the _posts directory
#
# Usage:
#	make publish title="already-created-draft-title"
#
# Moves the _drafts/%Y/%m/<draft-title> directory
# to the _posts/%Y/%m/<post-title> directory. The 
# %Y (Year) and %m (Month) directories represent 
# the date when the draft was created. 
#
# Note: if the draft has more than one file 
# (i.e images attached to the post), it will also
# copy that content into the _posts/%Y/%m/<post-title>
# directory.
DRAFT_PATH_TO_PUBLISH:=$(shell find ${DRAFTS_DIR} -type d -name $(title) | cut -d'/' -f2-)
publish:
	mkdir -p ${POSTS_DIR}/${DRAFT_PATH_TO_PUBLISH} 
	mv ${DRAFTS_DIR}/${DRAFT_PATH_TO_PUBLISH} ${POSTS_DIR}/${DRAFT_PATH_TO_PUBLISH}

# Moves a post to the _draft directory
#
# Usage:
#	make unpublish title="already-created-post-title"
#unpublish:

clean:
	bundle exec jekyll clean