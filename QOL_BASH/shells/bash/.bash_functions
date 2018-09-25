function set-title() {
  if [[ -z "$ORIG" ]]; then
    ORIG=$PS1
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1=${ORIG}${TITLE}
}

function git-change-author() {
  if [ $# != 4 ]; then
    echo "Usage: <old name> <old email> <new name> <new email>"
    return
  fi
  
  git filter-branch -f --env-filter 'if [ "$GIT_AUTHOR_EMAIL" = "'$2'" ] && [ "$GIT_AUTHOR_NAME" = "'$1'" ]; then GIT_AUTHOR_EMAIL='$4'; GIT_AUTHOR_NAME='$3'; GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL; GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"; fi' -- --all
}

function git-add-bitbucket-repo {
  reponame=${PWD##*/}  
  username=`git config user.name`
  email=`git config user.email`
  echo "Password"
  read -s password

  echo 'exec echo "$''GIT_PASSWORD''"' > /tmp/tmp.sh
  chmod +x /tmp/tmp.sh

  curl --user $username:$password https://api.bitbucket.org/1.0/repositories/ --data name=$reponame --data is_private='true'
  #git remote add origin git@bitbucket.org:$username/$reponame.git
  git remote add origin https://$username@bitbucket.org/$username/$reponame.git
  GIT_ASKPASS=/tmp/tmp.sh GIT_PASSWORD=$password git push -u origin --all
  GIT_ASKPASS=/tmp/tmp.sh GIT_PASSWORD=$password git push -u origin --tags

  rm /tmp/tmp.sh
}
