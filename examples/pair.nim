# http://tim.dysinger.net/posts/2013-09-16-getting-started-with-nanomsg.html
#
# Call like
# ./pair node0 ipc:///tmp/pair.ipc
# ./pair node1 ipc:///tmp/pair.ipc
#
# or
#
# ./pair node0 tcp://127.0.0.1:25000
# ./pair node1 tcp://127.0.0.1:25000
import os, nanomsg

proc sendName(sock; name: var string) =
  echo name,": SENDING \"",name,"\""
  discard send(sock, name.cstring, name.len + 1, 0)

proc recvName(sock, name) =
  var buf: cstring
  let bytes = recv(sock, addr buf, MSG, 0)
  if bytes > 0:
    echo name,": RECEIVED \"",buf,"\""
    discard freemsg buf

proc sendRecv(sock; name: var string) =
  var to: cint = 100
  discard setSockOpt(sock, SOL_SOCKET, RCVTIMEO, addr to, sizeof(to))
  while true:
    recvName(sock, name)
    sleep 1000
    sendName(sock, name)

proc node0(url: string) =
  var sock = socket(AF_SP, nanomsg.PAIR)
  assert sock >= 0
  let res = bindd(sock, url)
  assert res >= 0
  var name = "node0"
  sendRecv(sock, name)
  discard shutdown(sock, 0)

proc node1(url: string) =
  var sock = socket(AF_SP, nanomsg.PAIR)
  assert sock >= 0
  let res = connect(sock, url)
  assert res >= 0
  var name = "node1"
  sendRecv(sock, name)
  discard shutdown(sock, 0)

if paramStr(1) == "node0":
  node0 paramStr(2)
elif paramStr(1) == "node1":
  node1 paramStr(2)
