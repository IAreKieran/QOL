linked_shell=$(basename "$(readlink /proc/$$/exe)")
echo "Running from $linked_shell!"

QOL_BASH_VERSION=1

# Set this to any value to turn on debug statements
# QOL_INIT_DEBUG=1

if [ ! -z "$QOL_BASH_DIR" ] ; then
  . "$QOL_BASH_DIR/.qol_initrc"
  echo "Updating QOL_BASH!"
else
  SCRIPTPATH=$(readlink -f "$0")
  QOL_BASH_DIR=$(dirname "$SCRIPTPATH")
  ENV=$QOL_BASH_DIR/shells/shell/.shell_rc
  export ENV
  export QOL_BASH_DIR
  echo "Setting up QOL_BASH!"
  printf "\n" >> ~/.bashrc
  unset SCRIPTPATH
fi

echo "QOL_BASH Version: $QOL_BASH_VERSION"

# source required init files
. "$QOL_BASH_DIR/shells/shell/.shell_functions"
. "$QOL_BASH_DIR/.qol_initrc" # required for init & QOL_debug, nowhere else
CUR_SHELL=$(detect_shell)

unset QOL_init_function_stack
export QOL_init_function_stack
QOL_init_update_function_stack $0

QOL_debug "This is the debug statement for level $QOL_INIT_DEBUG!" $QOL_INIT_DEBUG $LINENO
QOL_debug "This is the debug statement for level 5!" 5 $LINENO

# Temporary file cleanup & initialise
QOL_debug "Running QOL_init_tmp_cleanup..." 1 $LINENO
QOL_debug_wrapper QOL_init_tmp_cleanup

# backing up ~/.bashrc
QOL_debug "Backing up .bashrc..." 1 $LINENO
file='.bashrc'
datetimestamp=`date '+%Y_%m_%d_%H:%M:%S'`
mkdir -p "$QOL_BASH_DIR/backups/"
cp ~/.bashrc "$QOL_BASH_DIR/backups/"$file"_"$datetimestamp
unset file
unset datetimestamp

QOL_debug "Initialising suffixes..." 1 $LINENO
QOL_BASH_VARIABLES="QOL_BASH_VERSION|QOL_BASH_DIR|ENV"
host_suffix_files="~/.bashrc|/etc/profile"
delimiter="|"
QOL_debug_wrapper QOL_suffix_init $delimiter

# for testing auto-sourcing
#tmp_x='export abc="10"'
#printf "$tmp_x" >> ~/.bashrc
unset QOL_INIT_DEBUG
unset debug_level
unset function_debug_level
unset old_function_debug_level

echo && echo "Don't forget to \`source ~/.bashrc\`!"
#current resourcing method. But you lose your exising terminal :/
#exec 'bash'
