;; package --- Filename: init-local.el
;; Description:
;; Author: Liu Enze
;; Maintainer:
;; Created: Thu Nov 27 21:46:50 2014 (+0800)
;; Version:
;; Package-Requires: ()
;; Last-Updated: Mon Dec 22 09:37:35 2014 (+0800)
;;           By: Liu Enze
;;     Update #: 56
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

(add-to-list 'load-path (expand-file-name "local" user-emacs-directory))

(require 'enzo-evil)
(require 'enzo-ac)
(require 'enzo-header)
(require 'enzo-uco)
(require 'enzo-config)
(require 'enzo-org)
(require 'enzo-term)

(add-hook 'emacs-startup-hook
          (lambda ()
            (auto-fill)
            (global-evil-leader-mode)
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
