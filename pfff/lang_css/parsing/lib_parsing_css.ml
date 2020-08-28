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

(*****************************************************************************)
(* Wrappers *)
(*****************************************************************************)

(*****************************************************************************)
(* Filemames *)
(*****************************************************************************)

let find_css_files_of_dir_or_files xs = 
  Common.files_of_dir_or_files_no_vcs_nofilter xs 
  |> List.filter (fun filename ->
    let ftype = File_type.file_type_of_file filename in
    match ftype with
    | File_type.PL (File_type.Web (File_type.Css)) -> true
    | _ -> false
  ) |> Common.sort
