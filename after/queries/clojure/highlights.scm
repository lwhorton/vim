;; ─────────────────────────────────────────────────────────────
;; Custom Clojure Tree‑sitter highlight extensions
;; Place in: ~/.config/nvim/after/queries/clojure/highlights.scm
;; ─────────────────────────────────────────────────────────────
;; This file augments the default highlights shipped with
;; nvim-treesitter.  It adds finer granularity for reader macros
;; and special punctuation.

;; --- Reader specials -----------------------------------------
;; Quote, syntax‑quote, unquote, unquote‑splicing, deref, var, etc.
["'" "`" "~" "@" "^"] @punctuation.reader_special
