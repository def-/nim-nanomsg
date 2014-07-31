# http://tim.dysinger.net/posts/2013-09-16-getting-started-with-nanomsg.html
import os, nanomsg

proc node0(url: string) =
  var sock = socket(AF_SP, PULL)
  assert sock >= 0
  discard bind(sock, url)
  while true:
    var buf: cstring
    let bytes = recv(sock, addr buf, MSG, 0)
    assert bytes >= 0
    echo "NODE0: RECEIVED \"",buf,"\""
    discard freemsg buf

proc node1(url, msg: string) =
  var sock = socket(AF_SP, PUSH)
  assert sock >= 0
  discard connect(sock, url)
  echo "NODE1: SENDING \"",msg,"\""
  let bytes = send(sock, msg.cstring, msg.len + 1, 0)
  assert bytes == msg.len + 1
  discard shutdown(sock, 0)

if paramStr(1) == "node0":
  node0 paramStr(2)
elif paramStr(1) == "node1":
  node1 paramStr(2), paramStr(3)
