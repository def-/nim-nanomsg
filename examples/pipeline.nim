# http://tim.dysinger.net/posts/2013-09-16-getting-started-with-nanomsg.html
#
# Call like
# ./pipeline node0 tcp://127.0.0.1:25000
# ./pipeline node1 tcp://127.0.0.1:25000 "Hello there"
#
# or
#
# ./pipeline node0 ipc:///tmp/pipeline.ipc
# ./pipeline node1 ipc:///tmp/pipeline.ipc "Hello there"
import os, nanomsg

proc node0(url: string) =
  var s = socket(AF_SP, PULL)
  assert s >= 0
  let res = s.bindd url
  assert res >= 0
  while true:
    var buf: cstring
    let bytes = s.recv(addr buf, MSG, 0)
    assert bytes >= 0
    echo "NODE0: RECEIVED \"",buf,"\""
    discard freemsg buf

proc node1(url, msg: string) =
  var s = socket(AF_SP, PUSH)
  assert s >= 0
  let res = s.connect url
  assert res >= 0
  echo "NODE1: SENDING \"",msg,"\""
  let bytes = s.send(msg.cstring, msg.len + 1, 0)
  assert bytes == msg.len + 1
  discard s.shutdown 0

if paramStr(1) == "node0":
  node0 paramStr(2)
elif paramStr(1) == "node1":
  node1 paramStr(2), paramStr(3)
