;;; package --- Summary enzo-term.el ---
;;
;; Filename: enzo-term.el
;; Description:
;; Author: Liu Enze
;; Maintainer:
;; Created: Mon Dec 22 09:38:23 2014 (+0800)
;; Version: 1.0.0
;; Package-Requires: ()
;; Last-Updated: Thu Feb 26 18:03:13 2015 (+0900)
;;           By: enzo-liu
;;     Update #: 10
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

(require-package 'multi-term)

(require 'multi-term)

(autoload 'multi-term "multi-term" nil t)
(autoload 'multi-term-next "multi-term" nil t)

(setq multi-term-program "/usr/local/bin/zsh")   ;; use bash
;; (setq multi-term-program "/bin/zsh") ;; or use zsh...

(global-set-key (kbd "C-c t") 'toggle-shell)
(global-set-key (kbd "C-c T") 'multi-term) ;; create a new one

(defun toggle-shell ()
  "Used for multi term toggle and focus."
  (interactive)
  (if (multi-term-dedicated-window-p)
      (multi-term-dedicated-toggle)
    (progn
      (multi-term-dedicated-toggle)
      (multi-term-dedicated-select))))

(provide 'enzo-term)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; enzo-term.el ends here
