;; ─────────────────────────────────────────────────────────────
;; Custom Clojure Tree‑sitter highlight extensions
;; Place in: ~/.config/nvim/after/queries/clojure/highlights.scm
;; ─────────────────────────────────────────────────────────────
;; This file augments the default highlights shipped with
;; nvim-treesitter.  It adds finer granularity for reader macros
;; and special punctuation.

;; --- Reader specials -----------------------------------------
;; Quote, syntax‑quote, unquote, unquote‑splicing, deref, var, etc.
;["'" "`" "~" "@" "^"] @punctuation.reader_special
[
  (derefing_lit) ; captures @
  (var_quoting_lit) ; captures #'
  (quoting_lit) ; captures '
  (syn_quoting_lit) ; captures `
  (unquoting_lit) ; captures ~
  (unquote_splicing_lit) ; captures ~@
  (meta_lit) ; captures ^
] @punctuation.reader_special
