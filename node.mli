(* --------------------------- *)
(* Node modules representation *)

(* A node module is represented as a JavaScript object *)
type node_module = Ojs.t

(* As bindings to NodeJS module will use this type for the returned require
 * function, we need to add these functions in the interface for switching
 * between OCaml and JavaScript representation.
 *)
val node_module_of_js : Ojs.t -> node_module

val node_module_to_js : node_module -> Ojs.t

(** Binding to require function when the returned type is an object, not a
 * function! See require_fn for this case. *)
val require : string -> node_module
  [@@js.global "process.mainModule.require"]

(* Some modules export functions and not an object. As OCaml is strongly typed,
 * we need to have a function for each case.
 * require_option is the object passed to the function returned by the require
 * function require_fn.
 *
 * Bindings to modules returning a function must simplify the require_option
 * type (by using a builder for example. If a binding doesn't give this
 * high-level abstraction, you have to use low-level JavaScript representation
 * by using Ojs module.
 *)
type require_option = Ojs.t

val require_fn : string -> (require_option -> node_module [@foo])
  [@@js.global "process.mainModule.require"]

(* As bindings to NodeJS module will use this type for the returned require
 * function, we need to add these functions in the interface for switching
 * between OCaml and JavaScript representation.
 *)
val require_option_of_js : Ojs.t -> require_option

val require_option_to_js : require_option -> Ojs.t

(* Node modules representation *)
(* --------------------------- *)

module DNS :
  sig
    type t

     [@@@js.stop]
     val dns : unit -> t
     [@@@js.start]

     [@@@js.implem
       let dns () = require "dns"
    ]
  end

module FS :
  sig
    type t

    [@@@js.stop]
    val fs : unit -> t
    [@@@js.start]

    [@@@js.implem
      let fs () = require "fs"
    ]

    module Stats :
      sig
        type t

        (* ------- *)
        (* Getters *)

        val dev :
          t ->
          int

        val ino :
          t ->
          int

        val mode :
          t ->
          int

        val nlink :
          t ->
          int

        val uid :
          t ->
          int

        val gid :
          t ->
          int

        val rdev :
          t ->
          int

        val size :
          t ->
          int

        val blksize :
          t ->
          int

        val atime :
          t ->
          Js_date.t

        val mtime :
          t ->
          Js_date.t

        val ctime :
          t ->
          Js_date.t

        val birthtime :
          t ->
          Js_date.t


        (* Getters *)
        (* ------- *)

        val is_file :
          t ->
          unit ->
          bool

        val is_directory :
          t ->
          unit ->
          bool

        val is_block_device :
          t ->
          unit ->
          bool

        val is_character_device :
          t ->
          unit ->
          bool

        val is_symbolink_link :
          t ->
          unit ->
          bool

        val is_FIFO :
          t ->
          unit ->
          bool

        val is_socket :
          t ->
          unit ->
          bool
      end
  end

module OS :
  sig
    type t

    [@@@js.stop]
    val os : unit -> t
    [@@@js.start]

    [@@@js.implem
      let os () : t = require "os"
    ]

    type architecture =
      | Arm [@js "arm"]
      | Arm64 [@js "arm64"]
      | Ia32 [@js "ia32"]
      | MIPS [@js "mips"]
      | MIPSel [@js "mipsel"]
      | PPC [@js "ppc"]
      | PPC64 [@js "ppc64"]
      | S390 [@js "s390"]
      | S390x [@js "s390x"]
      | X32 [@js "x32"]
      | X64 [@js "x64"]
      | X86 [@js "x86"]
      [@@js.enum]

    module CPU :
      sig
        type t

        module Times :
          sig
            type t

            val user : t -> int

            val nice : t -> int

            val sys : t -> int

            val idle : t -> int

            val irq : t -> int
          end

        val model : t -> string

        val speed : t -> int

        val times : t -> Times.t
      end

    val cpus : t -> CPU.t list

    val eol : t -> architecture [@@js.global "EOL"]

    type endianness =
      | BE [@js "BE"]
      | LE [@js "LE"]
      [@@js.enum]

    val endianness : t -> endianness

    val freemem : t -> int

    val hostname : t -> string

    (* ------------ *)
    (* Load average *)

    type loadavg = Ojs.t

    [@@@js.stop]
    val loadavg_1 : loadavg -> int

    val loadavg_5 : loadavg -> int

    val loadavg_15 : loadavg -> int
    [@@@js.start]

    [@@@js.implem
      let loadavg_1 (s : loadavg) =
        Ojs.int_of_js (Ojs.array_get (Ojs.t_to_js s) 0)

      let loadavg_5 (s : loadavg) =
        Ojs.int_of_js (Ojs.array_get (Ojs.t_to_js s) 1)

      let loadavg_15 (s : loadavg) =
        Ojs.int_of_js (Ojs.array_get (Ojs.t_to_js s) 2)
    ]

    val loadavg : t -> loadavg

    (* Load average *)
    (* ------------ *)

    (* -------- *)
    (* platform *)

    type platform =
      | Aix [@js "aix"]
      | Darwin [@js "darwin"]
      | FreeBSD [@js "freebsd"]
      | Linux [@js "linux"]
      | OpenBSD [@js "openbsd"]
      | SunOS [@js "sunos"]
      | Win32 [@js "win32"]
      [@@js.enum]

    val platforms : t -> platform

    (* platform *)
    (* -------- *)

    (* ------- *)
    (* release *)

    val release : t -> string

    (* release *)
    (* ------- *)

    val totalmem : t -> int

    (* FIXME: What about typing it? What are all possible values? *)
    val os_type : t -> string


    val uptime : t -> float

    (* FIXME: userInfo *)

    (* FIXME: Constants *)

  end

module Path :
  sig
    type t

    [@@@js.stop]
    val path : unit -> t
    [@@@js.start]

    [@@@js.implem
      let path () : t = require "path"
    ]

    val basename :
      t           ->
      string      ->
      ?ext:string ->
      unit        ->
      string

    type delimiter =
      | Semicolon [@js ";"]
      | Colon [@js ":"]
      [@@js.enum]

    val delimiter     :
      t           ->
      delimiter

    val delimiter_str :
      t           ->
      string

    val dirname       :
      t           ->
      string

    val extname       :
      t           ->
      string

    (* ------ *)
    (* format *)

    type path_object

    val dir_of_path_object :
      path_object ->
      string
      [@@js.get "dir"]

    val root_of_path_object :
      path_object ->
      string
      [@@js.get "root"]

    val base_of_path_object :
      path_object ->
      string
      [@@js.get "base"]

    val ext_of_path_object :
      path_object ->
      string
      [@@js.get "ext"]


    val create_path_object :
      ?dir:string  ->
      ?root:string ->
      ?base:string ->
      ?name:string ->
      ?ext:string  ->
      unit         ->
      path_object
      [@@js.builder]

    val format_ :
      t           ->
      path_object ->
      string
      [@@js.call "format"]

    (* format *)
    (* ------ *)

    (* -------------- *)
    (* isAbsolutePath *)

    val is_absolute_path :
      t      ->
      string ->
      bool

    (* isAbsolutePath *)
    (* -------------- *)


    (* ---- *)
    (* FIXME: join. *)

    (* join *)
    (* ---- *)

    (* --------- *)
    (* normalize *)

    val normalize :
      t      ->
      string ->
      string

    (* normalize *)
    (* --------- *)

    (* ----- *)
    (* parse *)

    val parse :
      t      ->
      string ->
      path_object

    (* parse *)
    (* ----- *)

    (* ----- *)
    (* FIXME: posix *)

    (* posix *)
    (* ----- *)

    (* -------- *)
    (* relative *)

    val relative :
      t      ->
      string ->
      string ->
      string

    (* relative *)
    (* -------- *)

    (* ------- *)
    (* FIXME: resolve *)

    (* resolve *)
    (* ------- *)

    (* --- *)
    (* sep *)

    val sep :
      t      ->
      string

    (* sep *)
    (* --- *)

    (* ----- *)
    (* FIXME: win32 *)

    (* win32 *)
    (* ----- *)
  end

module Stream :
  sig
    type t

    [@@@js.stop]
    val stream : unit -> t
    [@@@js.start]

    [@@@js.implem
      let stream () : t = require "stream"
    ]
  end

module HTTP :
  sig
    type t

    [@@@js.stop]
    val http : unit -> t
    [@@@js.start]

    [@@@js.implem
      let http () : t = require "http"
    ]

    module Agent :
      sig
        type t

        type options = Ojs.t

        val create_option :
          ?keep_alive:bool ->
          ?keep_alive_msecs:int ->
          ?max_sockets:int ->
          ?max_free_sockets:int ->
          unit ->
          t
          [@@js.builder]

        val create :
          ?options:options ->
          unit ->
          t
      end
  end

module Crypto :
  sig
    type t

    [@@@js.stop]
    val crypto : unit -> t
    [@@@js.start]

    [@@@js.implem
      let crypto () : t = require "crypto"
    ]

    module Certificate :
      sig
        type t

        val new_certificate :
          unit -> t
          [@@js.new "Certificate"]

        val export_challenge :
          t ->
          string ->
          string

        val export_public_key :
          t ->
          string ->
          string
      end
  end

module Process: sig
  type t

  [@@@js.stop]
  val process : unit -> t
  [@@@js.start]

  [@@@js.implem
    let process : unit -> t = fun () -> require "process"
  ]

  val abort: t -> unit -> unit
  val arch: t -> string
  val argv: t -> string list
  val argv0: t -> string
  val chdir: t -> string -> unit
  val config: t -> Ojs.t
  val connected: t -> bool
  (*val cpu_usage*)
  val cwd: t -> unit -> string
  val disconnect: t -> unit -> unit
  val env: t -> Ojs.t
  (* TODO *)
  val exec_path: t -> string
  val exit_: t -> int -> unit [@@js.call "exit"]
  val exit_code: t -> int
end
