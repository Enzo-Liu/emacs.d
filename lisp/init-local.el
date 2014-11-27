;; Filename: init-local.el
;; Description:
;; Author: Liu Enze
;; Maintainer:
;; Created: Thu Nov 27 21:46:50 2014 (+0800)
;; Version:
;; Package-Requires: ()
;; Last-Updated: Thu Nov 27 22:48:35 2014 (+0800)
;;           By: Liu Enze
;;     Update #: 31
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

(require-package 'evil)
(require-package 'evil-leader)
(require-package 'projectile)
(require-package 'auto-complete-clang)
(require-package 'header2)

;;;Evil Config Begin
(global-evil-leader-mode)

(defun indent-buffer ()
  "Use this to indent the whole file."
  (interactive)
  (indent-region (point-min) (point-max)))

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
      (when (y-or-n-p "Buffer modified.  Do you want to save first?")
        (save-buffer)))
    (if progName
        (progn
          (message "Running…")
          (shell-command cmdStr))
      (message "No recognized program file suffix for this file."))))

(evil-leader/set-key
  "e" 'find-file
  "b" 'switch-to-buffer
  "k" 'kill-buffer
  "w" 'save-buffer
  "r" 'run
  "u" 'uco
  "q" 'save-buffers-kill-terminal
  "f" 'indent-buffer
  "t" 'org-show-todo-tree
  "a" 'show-all
  ",f" 'ace-jump-mode
  ",F" 'ace-jump-char-mode
  ",w" 'ace-jump-word-mode)

(evil-leader/set-leader ",")

(defun pbcopy ()
  "Make copy function in mac os x."
  (interactive)
  (shell-command-on-region (region-beginning) (region-end) "pbcopy"))

(require 'evil)
(defun setupEvilOrg ()
  "Setup TAB For Org mode in Evil."
  (define-key evil-normal-state-map (kbd "TAB") 'org-cycle))

(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-insert-state-map (kbd "C-u")
  (lambda ()
    (interactive)
    (evil-delete (point-at-bol) (point))))
(define-key evil-insert-state-map "k" #'cofi/maybe-exit)
(evil-define-command cofi/maybe-exit ()
                     :repeat change
                     (interactive)
                     (let ((modified (buffer-modified-p)))
                       (insert "k")
                       (let ((evt (read-event (format "Insert %c to exit insert state" ?j)
                                              nil 0.5)))
                         (cond
                          ((null evt) (message ""))
                          ((and (integerp evt) (char-equal evt ?j))
                           (delete-char -1)
                           (set-buffer-modified-p modified)
                           (push 'escape unread-command-events))
                          (t (setq unread-command-events (append unread-command-events
                                                                 (list evt))))))))
;;;Evil Config End

;;;AC Config Begin
(require 'auto-complete-config)
(require 'auto-complete-clang)
(defun my-ac-cc-mode-setup ()
  "Set up cc config for autocomplete."
  (setq ac-clang-flags
        (mapcar (lambda (item) (concat "-I" item))
                (split-string
                 " /usr/include/c++/4.8
/usr/include/x86_64-linux-gnu/c++/4.8
/usr/include/c++/4.8/backward
/usr/lib/gcc/x86_64-linux-gnu/4.8/include /usr/local/include
/usr/lib/gcc/x86_64-linux-gnu/4.8/include-fixed
/usr/include/x86_64-linux-gnu /usr/include
")))
  (setq ac-sources (append '(ac-source-clang) ac-sources)))
(add-hook 'c-mode-hook 'my-ac-cc-mode-setup)
(add-hook 'c++-mode-hook 'my-ac-cc-mode-setup)

(desktop-save-mode 0)
(setq slime-contribs '(slime-repl slime-fuzzy slime-scratch))
(auto-save-mode 0)
(setq auto-save-default nil)
(setq require-final-newline t)
(setq-default make-backup-files nil)
(setq scroll-margin 3
      scroll-conservatively 10000)
(setq-default major-mode 'text-mode)

(setq ring-bell-function 'ignore)

;; 默认 80 列自动换行, 需要 M-x auto-fill-mode 模式下
(defun auto-fill ()
  "Set for auto fill Config."
  (setq-default auto-fill-function 'do-auto-fill)
  (setq-default fill-column 80)
  (setq-default comment-auto-fill-only-comments t))

(add-hook 'emacs-startup-hook
          (lambda ()
            (auto-fill)
            (evil-mode)
            (projectile-global-mode)
            (setf enable-local-variables nil)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(defun uco (name)
  "Use this to init the ${NAME} programming for usacontext."
  (interactive "sinput the program name you want to open or create: ")
  (let* ((prefix `((t . "~") (nil . "~/host")))
         (path (concat (cdr (assoc *is-a-mac* prefix)) "/Work/git/usacontext/" ))
         (folder (concat path name "/")))
    (unless (file-exists-p folder)
      (make-directory folder)
      (shell-command (concat  "cp " path  "sample/sample.cpp " folder name
                              ".cpp && sed -i 's/#{name}/" name "/' " folder "*.cpp" )))
    (uco-display folder name)))

(defun uco-display (folder name)
  "FOLDER: the file location.  NAME: the file name."
  (let ((uco-cpp (concat folder name ".cpp"))
        (uco-pro (concat folder name ".pr"))
        (uco-in (concat folder name ".in"))
        (uco-out (concat folder name ".out")))
    (make-frame-command)
    (switch-to-buffer (find-file-noselect uco-cpp))
    (set-window-buffer (split-window-horizontally) (find-file-noselect uco-pro))
    (windmove-right)
    (set-window-buffer (split-window-below) (find-file-noselect uco-in))
    (windmove-down)
    (set-window-buffer (split-window-right) (find-file-noselect uco-out))
    (windmove-left)))

(autoload 'org-present "org-present" nil t)

(add-hook 'org-present-mode-hook
          (lambda ()
            (org-present-big)
            (org-display-inline-images)))

(add-hook 'org-present-mode-quit-hook
          (lambda ()
            (org-present-small)
            (org-remove-inline-images)))

;;指针不闪，不恍花眼睛。
(blink-cursor-mode -1)

;; org 自动换行
(add-hook 'org-mode-hook
          (lambda ()
            (toggle-truncate-lines 0)
            (setupEvilOrg)))

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

  (when (display-graphic-p)
    (ns-raise-emacs)))

(when (eq system-type 'darwin)

  ;; default Latin font (e.g. Consolas)
  (set-face-attribute 'default nil :family "Sauce Code Powerline")

  ;; default font size (point * 10)
  ;;
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

(require 'header2)
(autoload 'auto-update-file-header "header2")
(add-hook 'write-file-hooks 'auto-update-file-header)
(autoload 'auto-make-header "header2")
(defun enzo-make-header ()
  (auto-make-header)
  (auto-update-file-header))
(add-hook 'emacs-lisp-mode-hook 'enzo-make-header)
(add-hook 'c-mode-common-hook   'enzo-make-header)
(add-hook 'lisp-mode-hook 'enzo-make-header)

(provide 'init-local)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-local.el ends here
