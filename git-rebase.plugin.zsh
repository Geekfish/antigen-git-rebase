rebase() {
    stashArg='--no-autostash'
    commit=$1

    if ! git diff-index --quiet HEAD; then
        # We only care about stashing if there are unstaged changes
        printf "Stash? (Y/n): "
        read -r shouldStash

        if [[ ! $shouldStash =~ ^[Nn]$ ]]; then
            stashArg='--autostash'
        fi
    fi


    #git log --color --graph --pretty=format:'%Cgreen%h%Creset %C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit | cat -n | less


    git rebase -i --autosquash $stashArg HEAD~$commit
}

compdef _add_completion rebase


_add_completion() {
    local -a commits
    # TODO: This quoting is dubious
    commits=`git log --pretty=oneline --abbrev-commit`
    commits=(${(f)"$(awk '{print NR "\\:\x27"  $s "\x27"}' <<< $commits)"})
    _arguments "1: :(($^commits))"
}
