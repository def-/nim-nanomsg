{.deadcodeElim: on.}

when defined(windows):
  const
    libnanomsg* = "libnanomsg.dll"
elif defined(macosx):
  const
    libnanomsg* = "libnanomsg.dylib"
else:
  const
    libnanomsg* = "libnanomsg.so"

# c2nim --skipcomments --prefix:nn_ --prefix:NN_ --dynlib:libnanomsg --cdecl
# nn.h

const 
  HAUSNUMERO* = 156384712
  ENOTSUP* = (HAUSNUMERO + 1)
  EPROTONOSUPPORT* = (HAUSNUMERO + 2)
  ENOBUFS* = (HAUSNUMERO + 3)
  ENETDOWN* = (HAUSNUMERO + 4)
  EADDRINUSE* = (HAUSNUMERO + 5)
  EADDRNOTAVAIL* = (HAUSNUMERO + 6)
  ECONNREFUSED* = (HAUSNUMERO + 7)
  EINPROGRESS* = (HAUSNUMERO + 8)
  ENOTSOCK* = (HAUSNUMERO + 9)
  EAFNOSUPPORT* = (HAUSNUMERO + 10)
  EPROTO* = (HAUSNUMERO + 11)
  EAGAIN* = (HAUSNUMERO + 12)
  EBADF* = (HAUSNUMERO + 13)
  EINVAL* = (HAUSNUMERO + 14)
  EMFILE* = (HAUSNUMERO + 15)
  EFAULT* = (HAUSNUMERO + 16)
  EACCESS* = (HAUSNUMERO + 17)
  ENETRESET* = (HAUSNUMERO + 18)
  ENETUNREACH* = (HAUSNUMERO + 19)
  EHOSTUNREACH* = (HAUSNUMERO + 20)
  ENOTCONN* = (HAUSNUMERO + 21)
  EMSGSIZE* = (HAUSNUMERO + 22)
  ETIMEDOUT* = (HAUSNUMERO + 23)
  ECONNABORTED* = (HAUSNUMERO + 24)
  ECONNRESET* = (HAUSNUMERO + 25)
  ENOPROTOOPT* = (HAUSNUMERO + 26)
  EISCONN* = (HAUSNUMERO + 27)
  EISCONN_DEFINED* = true
  ESOCKTNOSUPPORT* = (HAUSNUMERO + 28)
  ETERM* = (HAUSNUMERO + 53)
  EFSM* = (HAUSNUMERO + 54)

proc errno*(): cint {.cdecl, importc: "nn_errno", dynlib: libnanomsg.}

proc strerror*(errnum: cint): cstring {.cdecl, importc: "nn_strerror", 
                                        dynlib: libnanomsg.}

proc symbol*(i: cint; value: ptr cint): cstring {.cdecl, importc: "nn_symbol", 
    dynlib: libnanomsg.}

const 
  NS_NAMESPACE* = 0
  NS_VERSION* = 1
  NS_DOMAIN* = 2
  NS_TRANSPORT* = 3
  NS_PROTOCOL* = 4
  NS_OPTION_LEVEL* = 5
  NS_SOCKET_OPTION* = 6
  NS_TRANSPORT_OPTION* = 7
  NS_OPTION_TYPE* = 8
  NS_OPTION_UNIT* = 9
  NS_FLAG* = 10
  NS_ERROR* = 11
  NS_LIMIT* = 12


const 
  TYPE_NONE* = 0
  TYPE_INT* = 1
  TYPE_STR* = 2


const 
  UNIT_NONE* = 0
  UNIT_BYTES* = 1
  UNIT_MILLISECONDS* = 2
  UNIT_PRIORITY* = 3
  UNIT_BOOLEAN* = 4


type 
  symbol_properties* = object 
    value*: cint
    name*: cstring
    ns*: cint
    typ*: cint
    unit*: cint



proc symbol_info*(i: cint; buf: ptr symbol_properties; buflen: cint): cint {.
    cdecl, importc: "nn_symbol_info", dynlib: libnanomsg.}

proc term*() {.cdecl, importc: "nn_term", dynlib: libnanomsg.}

const MSG* = -1

proc allocmsg*(size: csize; typ: cint): pointer {.cdecl, 
    importc: "nn_allocmsg", dynlib: libnanomsg.}
proc reallocmsg*(msg: pointer; size: csize): pointer {.cdecl, 
    importc: "nn_reallocmsg", dynlib: libnanomsg.}
proc freemsg*(msg: pointer): cint {.cdecl, importc: "nn_freemsg", 
                                    dynlib: libnanomsg.}

type 
  iovec* = object 
    iov_base*: pointer
    iov_len*: csize

  msghdr* = object 
    msg_iov*: ptr iovec
    msg_iovlen*: cint
    msg_control*: pointer
    msg_controllen*: csize

  cmsghdr* = object 
    cmsg_len*: csize
    cmsg_level*: cint
    cmsg_type*: cint



template CMSG_FIRSTHDR*(mhdr: expr): expr = 
  (if (mhdr).msg_controllen >= sizeof(cmsghdr): cast[ptr cmsghdr]((mhdr).msg_control) else: cast[ptr cmsghdr](nil))

template CMSG_NXTHDR*(mhdr, cmsg: expr): expr = 
  cmsg_nexthdr(cast[ptr msghdr]((mhdr)), cast[ptr cmsghdr]((cmsg)))

template CMSG_DATA*(cmsg: expr): expr = 
  (cast[ptr cuchar](((cast[ptr cmsghdr]((cmsg))) + 1)))


template CMSG_SPACE*(len: expr): expr = 
  (CMSG_ALIGN(len) + CMSG_ALIGN(sizeof(cmsghdr)))

template CMSG_LEN*(len: expr): expr = 
  (CMSG_ALIGN(sizeof(cmsghdr)) + (len))


const 
  AF_SP* = 1
  AF_SP_RAW* = 2


const 
  SOCKADDR_MAX* = 128


const 
  SOL_SOCKET* = 0


const 
  LINGER* = 1
  SNDBUF* = 2
  RCVBUF* = 3
  SNDTIMEO* = 4
  RCVTIMEO* = 5
  RECONNECT_IVL* = 6
  RECONNECT_IVL_MAX* = 7
  SNDPRIO* = 8
  RCVPRIO* = 9
  SNDFD* = 10
  RCVFD* = 11
  DOMAIN* = 12
  PROTOCOL* = 13
  IPV4ONLY* = 14
  SOCKET_NAME* = 15


const 
  DONTWAIT* = 1

proc socket*(domain: cint; protocol: cint): cint {.cdecl, importc: "nn_socket", 
    dynlib: libnanomsg.}
proc close*(s: cint): cint {.cdecl, importc: "nn_close", dynlib: libnanomsg.}
proc setsockopt*(s: cint; level: cint; option: cint; optval: pointer; 
                 optvallen: csize): cint {.cdecl, importc: "nn_setsockopt", 
    dynlib: libnanomsg.}
proc getsockopt*(s: cint; level: cint; option: cint; optval: pointer; 
                 optvallen: ptr csize): cint {.cdecl, importc: "nn_getsockopt", 
    dynlib: libnanomsg.}
# TODO: What to do with bind?
proc `bind`*(s: cint; add: cstring): cint {.cdecl, importc: "nn_bind", 
    dynlib: libnanomsg.}
proc connect*(s: cint; add: cstring): cint {.cdecl, importc: "nn_connect", 
    dynlib: libnanomsg.}
proc shutdown*(s: cint; how: cint): cint {.cdecl, importc: "nn_shutdown", 
    dynlib: libnanomsg.}
proc send*(s: cint; buf: pointer; len: csize; flags: cint): cint {.cdecl, 
    importc: "nn_send", dynlib: libnanomsg.}
proc recv*(s: cint; buf: pointer; len: csize; flags: cint): cint {.cdecl, 
    importc: "nn_recv", dynlib: libnanomsg.}
proc sendmsg*(s: cint; msghdr: ptr msghdr; flags: cint): cint {.cdecl, 
    importc: "nn_sendmsg", dynlib: libnanomsg.}
proc recvmsg*(s: cint; msghdr: ptr msghdr; flags: cint): cint {.cdecl, 
    importc: "nn_recvmsg", dynlib: libnanomsg.}

const 
  POLLIN* = 1
  POLLOUT* = 2

type 
  pollfd* = object 
    fd*: cint
    events*: cshort
    revents*: cshort


proc poll*(fds: ptr pollfd; nfds: cint; timeout: cint): cint {.cdecl, 
    importc: "nn_poll", dynlib: libnanomsg.}

proc device*(s1: cint; s2: cint): cint {.cdecl, importc: "nn_device", 
    dynlib: libnanomsg.}

# pipeline.h

const 
  PROTO_PIPELINE* = 5
  PUSH* = (PROTO_PIPELINE * 16 + 0)
  PULL* = (PROTO_PIPELINE * 16 + 1)

# bus.h

const 
  PROTO_BUS* = 7
  BUS* = (PROTO_BUS * 16 + 0)

# inproc.h

const 
  INPROC* = - 1

# ipc.h

const 
  IPC* = - 2

# pair.h

const 
  PROTO_PAIR* = 1
  PAIR* = (PROTO_PAIR * 16 + 0)

# survey.h

const 
  PROTO_SURVEY* = 6
  SURVEYOR* = (PROTO_SURVEY * 16 + 0)
  RESPONDENT* = (PROTO_SURVEY * 16 + 1)
  SURVEYOR_DEADLINE* = 1

# pubsub.h

const 
  PROTO_PUBSUB* = 2
  PUB* = (PROTO_PUBSUB * 16 + 0)
  SUB* = (PROTO_PUBSUB * 16 + 1)
  SUB_SUBSCRIBE* = 1
  SUB_UNSUBSCRIBE* = 2

# reqrep.h

const 
  PROTO_REQREP* = 3
  REQ* = (PROTO_REQREP * 16 + 0)
  REP* = (PROTO_REQREP * 16 + 1)
  REQ_RESEND_IVL* = 1

# tcp.h

const 
  TCP* = - 3
  TCP_NODELAY* = 1
