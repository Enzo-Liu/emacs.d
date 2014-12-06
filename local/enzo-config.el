;;; package --- enzo-config.el ---
;;
;; Filename: enzo-config.el
;; Description:
;; Author: Liu Enze
;; Maintainer:
;; Created: Wed Dec  3 11:07:20 2014 (+0800)
;; Version:
;; Package-Requires: ()
;; Last-Updated: Thu Dec  4 13:38:57 2014 (+0800)
;;           By: Liu Enze
;;     Update #: 19
;; URL:
;; Doc URL:
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change Log:
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or (at
;; your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

(require-package 'projectile)

(defun indent-buffer ()
  "Use this to indent the whole file."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun pbcopy ()
  "Make copy function in mac os x."
  (interactive)
  (shell-command-on-region (region-beginning) (region-end) "pbcopy"))

(desktop-save-mode 0)
(setq slime-contribs '(slime-repl slime-fuzzy slime-scratch))
(auto-save-mode 0)
(setq auto-save-default nil)
(setq require-final-newline t)
(setq-default make-backup-files nil)
(setq scroll-margin 3
      scroll-conservatively 10000)
(setq-default major-mode 'text-mode)

;;指针不闪，不恍花眼睛。
(blink-cursor-mode -1)

(setq ring-bell-function 'ignore)

(when (eq system-type 'darwin)
  ;; default Latin font (e.g. Consolas)
  (set-face-attribute 'default nil :family "Sauce Code Powerline")

  ;; default font size (point * 10)
  ;; WARNING!  Depending on the default font,
  ;; if the size is not supported very well, the frame will be clipped
  ;; so that the beginning of the buffer may not be visible correctly.
  (set-face-attribute 'default nil :height 140 :weight 'normal)

  ;; use specific font for Korean charset.
  ;; if you want to use different font size for specific charset,
  ;; add :size POINT-SIZE in the font-spec.
  (set-fontset-font t 'hangul (font-spec :name "NanumGothicCoding"))
  (set-fontset-font t 'chinese-gb2312 (font-spec :name "Hiragino Sans GB"))

  ;; you may want to add different for other charset in this way.
  )

(when (featurep 'ns)
  (defun ns-raise-emacs ()
    "Raise Emacs."
    (ns-do-applescript "tell application \"Emacs\" to activate"))

  (defun ns-raise-emacs-with-frame (frame)
    "Raise Emacs and select the provided frame."
    (with-selected-frame frame
      (when (display-graphic-p)
        (ns-raise-emacs))))

  (add-hook 'after-make-frame-functions 'ns-raise-emacs-with-frame)

  (when (display-graphic-p) (ns-raise-emacs)))

;; 默认 80 列自动换行, 需要 M-x auto-fill-mode 模式下
(defun auto-fill ()
  "Set for auto fill Config."
  (setq-default auto-fill-function 'do-auto-fill)
  (setq-default fill-column 80)
  (setq-default comment-auto-fill-only-comments t))

(defun run ()
  "Use this to run single file in different file type."
  (interactive)
  (let* ((otherCmdMap `(("cpp" . "&& ./a.out")))
         (suffixMap `(("py" . "python") ("rb" . "ruby") ("js" . "node") ("cpp" . "g++")
                      ("sh" . "bash") ("ml" . "ocaml") ("vbs" . "cscript")))
         (fName (buffer-file-name))
         (fSuffix (file-name-extension fName))
         (progName (cdr (assoc fSuffix suffixMap)))
         (otherCmd (cdr (assoc fSuffix otherCmdMap)))
         (cmdStr (concat progName " \""   fName "\" " otherCmd)))
    (when (buffer-modified-p)
      (when (y-or-n-p "Buffer modified.  Do you want to save first? ")
        (save-buffer)))
    (if progName
        (progn
          (message "Running…")
          (shell-command cmdStr))
      (message "No recognized program file suffix for this file."))))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(global-set-key (kbd "C-s-f") 'toggle-frame-fullscreen)
;; For some weird reason C-s-f only means right cmd key!
(global-set-key (kbd "<C-s-268632070>") 'toggle-frame-fullscreen)

(provide 'enzo-config)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; enzo-config.el ends here
