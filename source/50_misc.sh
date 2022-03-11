# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

alias grep='grep --color=auto'

# Prevent less from clearing the screen while still showing colors.
export LESS=-XR

# Set tty for gpg
GPG_TTY=$(tty)

# Set ls coloring
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad

# Set the terminal's title bar.
function titlebar() {
  echo -n $'\e]0;'"$*"$'\a'
}

# SSH auto-completion based on entries in known_hosts.
if [[ -e ~/.ssh/known_hosts ]]; then
  complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v '[0-9]')" ssh scp sftp
fi

#Terminal Notifier
alias tmn="terminal-notifier -message"

# Disable ansible cows }:]
export ANSIBLE_NOCOWS=1

#CMatrix Shortcut
alias cm='cmatrix -a -u 5 -s; clear'

dockertail() {
usage="dockertail (dev|pro) (tomcat | loggly | datadog) ip_address"
  if [ $# -ne 3 ]
    then
      echo $usage
  else
    ssh -i ~/.ssh/vic-deploy-$1.pem ec2-user@$3 "sudo docker logs --tail=100 -f \$(sudo docker ps | grep $2 | cut -f1 -d' ')"
  fi
}

alias mvndev='BUILD_VERSION=dev mvn clean package'
alias backup_consul='consul kv export vikings/ > ~/Backups/$(date +"%Y")/consul_backup_$(date +"%m%d%Y").json'
alias be='bundle exec'
alias tf='terraform'
alias venv="python3 -m venv venv && source venv/bin/activate"
alias lint="docker run --rm -e RUN_LOCAL=true -v $(pwd):/tmp/lint -e LOG_LEVEL=NOTICE -e JAVA_FILE_NAME=checkstyle.xml  github/super-linter"


urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}

urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

export_aws(){
  # usage: export_aws filename.csv
  # default will be set to credentials.csv if not specified
  file="${1:-credentials.csv}"
  echo "export creds from ${file}"
  export AWS_ACCESS_KEY_ID=$(tail -1 ${file} | cut -d, -f 1 | tr -d '\040\011\012\015')
  export AWS_SECRET_ACCESS_KEY=$(tail -1 ${file} | cut -d, -f 2 | tr -d '\040\011\012\015')
}

clear_aws() {
  # clear out all AWS_* environmnet variables
  unset $(env | grep -i ^aws | awk -F= '{print $1}')
}

clear_terraform() {
  find . -type d -name .terraform -exec rm -rf {} \;
}

op_find_item_uuid() {
  op list items | jq -r ".[] | select(.overview.title == \"$1\") | .uuid"
}

op_get_item_field() {
  search=$1
  field=$2
  # echo "Searching for item $search"
  uuid=$(op_find_item_uuid "$search")
  if [ -n $uuid ]; then
    # echo "Found uuid $uuid"
    op get item $uuid | jq -r ".details.sections[0].fields[] | select(.t == \"$field\") | .v"
  else
    # echo "no uuid found"
    exit 1
  fi
}

superlinter() {
  docker run -it --rm -e RUN_LOCAL=true -v $(pwd):/tmp/lint -e SSH_KEY="$(cat ~/.ssh/superlinter)" -e LOG_LEVEL=NOTICE -e JAVA_FILE_NAME=checkstyle.xml  github/super-linter
}

fix_text() {
  textlint -c .github/linters/.textlintrc  --fix "${1:-.}"
}
