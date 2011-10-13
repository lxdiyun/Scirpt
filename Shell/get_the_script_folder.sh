echo $(dirname $0)
DIR="$( cd "$( dirname "$0" )" && pwd )"

#Is a useful one-liner which will give you the full directory name of the script no matter where it is being called from
#
#Or, to get the dereferenced path (all symlinks resolved), do this:

DIR="$( cd -P "$( dirname "$0" )" && pwd )"


