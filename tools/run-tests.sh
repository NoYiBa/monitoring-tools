#!/bin/bash
set -e
export GREP_OPTIONS=""

declare -i n_done=0
declare -i n_failed=0
declare failed=""

# Plugins
cd plugins
for plugin in `ls -d */`; do
    cd $plugin
    file="./test/jenkins/jenkins_unit_tests.sh"
    # workaround, as long as we still have these dirty jenkins scripts
    if [ -e $file ]
    then
        "$file"
    else
        ./run_tests.sh
    fi || {
        n_failed+=1
        failed="$failed\n${plugin}"
    }
    n_done+=1
    cd ..
done
cd ..

# finally: shinkenplugins
cd shinkenplugins
./run_tests.sh || {
    shinkenplugins_failed=1
}
cd ..

cat << END
Final report: $n_done plugins checked ; $n_failed failed.
Following plugins failed: $(echo -e $failed)
END
if test "$shinkenplugins_failed"
then
    echo "More over the shinkenplugins package test itself failed"
fi
