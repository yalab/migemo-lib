#! /bin/sh

#
# symbol handling test
#
echo "|()<>[]='\`{"| ruby -I.. ../migemo -n test-dict > tmp.out
cat <<'EOF' > tmp.right
\|\(\)\<\>\[\]\=\'\`\{|｜（）＜＞［］＝’‘｛
EOF
cmp tmp.right tmp.out || exit 1

echo "|()<>[]='\`{"| ruby -I.. ../migemo -temacs -n test-dict > tmp.out
cat <<'EOF' > tmp.right
|()<>\[\]='`{\|｜（）＜＞［］＝’‘｛
EOF
cmp tmp.right tmp.out || exit 1

exit 0
