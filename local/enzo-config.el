;;; package --- enzo-config.el ---
;;
;; Filename: enzo-config.el
;; Description:
;; Author: Liu Enze
;; Maintainer:
;; Created: Wed Dec  3 11:07:20 2014 (+0800)
;; Version: 1.0-alpha
;; Package-Requires: ()
;; Last-Updated: Wed Sep 16 12:42:13 2015 (+0800)
;;           By: Enze Liu
;;     Update #: 147
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

(defun indent-buffer ()
  "Use this to indent the whole file."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun pbcopy ()
  "Make copy function in mac os x."
  (interactive)
  (shell-command-on-region (region-beginning) (region-end) "pbcopy"))

(menu-bar-mode -1)
(desktop-save-mode 0)
(setq slime-contribs '(slime-repl slime-fuzzy slime-scratch))
(auto-save-mode 0)
(setq auto-save-default nil)
(setq require-final-newline t)
(setq-default make-backup-files nil)
(setq scroll-margin 3
      scroll-conservatively 10000)
(setq-default major-mode 'text-mode)
(setenv "TMPDIR" "/tmp")

;;指针不闪，不恍花眼睛。
(blink-cursor-mode -1)

(setq ring-bell-function 'ignore)

(defun setup-font (size font ratio)
  "Setup font for graphic display with Font SIZE and WEIGHT."
  (when (display-graphic-p)
    ;; default Latin font (e.g. Consolas)
    (set-face-attribute 'default nil :family "Sauce Code Powerline")

    ;; default font size (point * 10)
    ;; WARNING!  Depending on the default font,
    ;; if the size is not supported very well, the frame will be clipped
    ;; so that the beginning of the buffer may not be visible correctly.
    (set-face-attribute 'default nil :height size :weight 'normal)

    ;; use specific font for Korean charset.
    ;; if you want to use different font size for specific charset,
    ;; add :size POINT-SIZE in the font-spec.
    (set-fontset-font t 'hangul (font-spec :name "NanumGothicCoding"))
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font t charset (font-spec :name font)))
    (setq face-font-rescale-alist `((,font . ,ratio) ("文泉驿正黑" . 1.2))))
  ;; you may want to add different for other charset in this way.
  )

(defun customize-font-size (size)
  "Set the default font SIZE for frame."
  (set-face-attribute 'default nil :height size :weight 'normal))

(defun mac-set-font (frame)
  (with-selected-frame frame
    (setup-font 140  "Hiragino Sans GB" 1.2)))

(defun fedora-set-font (frame)
  (with-selected-frame frame
    ;;; (95 1.3)
    (setup-font 130 "WenQuanYi Zen Hei" 1.2)))

(when (eq system-type 'darwin)
  (when (featurep 'ns)
    (defun ns-raise-emacs ()
      "Raise Emacs."
      (ns-do-applescript "tell application \"Emacs\" to activate"))

    (defun ns-raise-emacs-with-frame (frame)
      "Raise Emacs and select the provided frame."
      (with-selected-frame frame
        (when (display-graphic-p) (ns-raise-emacs))))

    (add-hook 'after-make-frame-functions 'ns-raise-emacs-with-frame))
  (add-hook 'after-make-frame-functions 'mac-set-font))

(when (eq system-type 'gnu/linux)
  (add-hook 'after-make-frame-functions 'fedora-set-font))



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
                      ("sh" . "bash") ("ml" . "ocaml") ("vbs" . "cscript") ("c" . "c")
                      ("hs" . "runghc") ("c++" . "c")))
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

(when *is-a-mac*
  (setq mac-command-modifier 'super))

(global-set-key (kbd "C-s-f") 'toggle-frame-fullscreen)
;; For some weird reason C-s-f only means right cmd key!
(global-set-key (kbd "<C-s-268632070>") 'toggle-frame-fullscreen)

(global-set-key (kbd "s-/") 'comment-or-uncomment-region)

(custom-set-variables
 '(markdown-command "/usr/local/bin/pandoc"))

(define-globalized-minor-mode my-global-fci-mode fci-mode turn-on-fci-mode)
;; current this is not compatiable with show-trailing-whitespace
;;(my-global-fci-mode 0)

(require 'flycheck)
(defun disable-flycheck-for-erb ()
  "Disable flycheck for erb, since it caused a lot of wrong distractions."
  (setq-local flycheck-disabled-checkers '(eruby-erubis ruby-rubocop)))
(add-hook 'html-erb-mode-hook 'disable-flycheck-for-erb)

(add-hook 'prog-mode-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

(setq-default tab-width 4)
;; (add-hook 'makefile-mode-hook
;;           (lambda()
;;             (setq tab-width 4)))
;;
;;
(require-package 'color-theme-solarized)
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (let ((mode (if (display-graphic-p frame) 'light 'light)))
              (set-frame-parameter frame 'background-mode mode)
              (set-terminal-parameter frame 'background-mode mode))
            (enable-theme 'solarized)))

(require 'rinari)
(add-hook 'after-init-hook
          (lambda ()
            (exec-path-from-shell-initialize)
            (setq ruby-compilation-executable (executable-find "ruby"))))

(require-package 'rvm)
(require 'rvm)
(rvm-use-default)

(setq-default flycheck-emacs-lisp-load-path 'inherit)


(require-package 'yasnippet)
(require 'yasnippet)
(yas-global-mode)
(setq-default yas-prompt-functions '(yas-ido-prompt yas-dropdown-prompt))

(require-package 'powerline)
(require 'powerline)
(powerline-center-evil-theme)

(require-package 'haskell-snippets)
(require 'haskell-snippets)

(add-hook 'prog-mode-hook (lambda ()
                            (turn-off-auto-fill)))


(provide 'enzo-config)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; enzo-config.el ends here
