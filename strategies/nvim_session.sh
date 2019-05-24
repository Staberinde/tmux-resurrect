#!/usr/bin/env bash

# "nvim session strategy"
#
# Same as vim strategy, see file 'vim_session.sh'

ORIGINAL_COMMAND="$1"
DIRECTORY="$2"

nvim_git_session_branch_suffix_get() {
    git branch | grep -Po '\*\ \K.+'
}

nvim_git_session_file_get() {
    echo "$HOME/.vim/sessions${DIRECTORY}/$(nvim_git_session_branch_filename_get)"
}

nvim_git_session_file_exists() {
    [ -e $(nvim_git_session_file_get) ]
}

nvim_session_file_exists() {
	[ -e "${DIRECTORY}/Session.vim" ]
}

original_command_contains_session_flag() {
	[[ "$ORIGINAL_COMMAND" =~ "-S" ]]
}

main() {
	if nvim_git_session_file_exists; then
        echo "nvim -S $(nvim_git_session_file_get)"
	elif nvim_session_file_exists; then
		echo "nvim -S"
	elif original_command_contains_session_flag; then
		# Session file does not exist, yet the original nvim command contains
		# session flag `-S`. This will cause an error, so we're falling back to
		# starting plain nvim.
		echo "nvim"
	else
		echo "$ORIGINAL_COMMAND"
	fi
}
main
