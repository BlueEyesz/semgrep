(* Yoann Padioleau
 *
 * Copyright (C) 2011 Facebook
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation, with the
 * special exception on linking described in file license.txt.
 * 
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * license.txt for more details.
 *)

open OCaml (* for v_int, v_bool, etc *)

open Ast_html

(* Disable warnings against unused variables *)
[@@@warning "-26"]

(*****************************************************************************)
(* Prelude *)
(*****************************************************************************)

(* 
 * A classic AST visitor, just like for the other PLs in pfff.
 * todo? maybe could reuse some of the ideas in CSS to have more
 * compact visitors?
 *)
(*****************************************************************************)
(* Types *)
(*****************************************************************************)

type visitor_in = {
  khtml_tree: html_tree vin;
  kinfo: info vin;
 }
  and 'a vin = ('a  -> unit) * visitor_out -> 'a  -> unit

and visitor_out = any -> unit

let default_visitor = { 
  kinfo   = (fun (k,_) x -> k x);
  khtml_tree   = (fun (k,_) x -> k x);
}

(*****************************************************************************)
(* Main entry point *)
(*****************************************************************************)

let (mk_visitor: visitor_in -> visitor_out) = fun vin ->

(* autogenerated by ocamltarzan*)
let rec v_info x  =
  let k x = match x with { Parse_info.token = _v_pinfo; _} ->
  (* TODO ? not sure what behavior we want with tokens and fake tokens.
  *)
    (*let arg = v_parse_info v_pinfo in *)
    ()
  in
  vin.kinfo (k, all_functions) x

(* todo: 3.12: could use polymorphic recursion instead of those ugly
 * functions. Just write v_wrap: 'a. 'a wrap -> unit
 *)
and v_wrap _of_a (v1, v2) = let v1 = _of_a v1 and v2 = v_info v2 in ()

and v_html_tree x =
  let k = function
  | Element ((v1, v2, v3)) ->
      let v1 = v_tag v1
      and v2 =
        v_list
          (fun (v1, v2) ->
             let v1 = v_attr_name v1 and v2 = v_attr_value v2 in ())
          v2
      and v3 = v_list v_html_tree v3
      in ()
  | Data v1 -> let v1 = v_wrap v_string v1 in ()
  in
  vin.khtml_tree (k, all_functions) x

and v_tag = function | Tag v1 -> let v1 = v_wrap v_string v1 in ()
and v_attr_name = function | Attr v1 -> let v1 = v_wrap v_string v1 in ()
and v_attr_value = function | Val v1 -> let v1 = v_wrap v_string v1 in ()

and v_any = function
  | HtmlTree v1 -> let v1 = v_html_tree v1 in ()
and all_functions x = v_any x
in
v_any

(*****************************************************************************)
(* Helpers *)
(*****************************************************************************)

let do_visit_with_ref mk_hooks = fun any ->
  let res = ref [] in
  let hooks = mk_hooks res in
  let vout = mk_visitor hooks in
  vout any;
  List.rev !res
