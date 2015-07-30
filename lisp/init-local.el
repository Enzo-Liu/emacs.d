;; package --- Filename: init-local.el
;; Description:
;; Author: Liu Enze
;; Maintainer:
;; Created: Thu Nov 27 21:46:50 2014 (+0800)
;; Version:
;; Package-Requires: ()
;; Last-Updated: Wed Jul 29 21:18:23 2015 (+0800)
;;           By: enzo-liu
;;     Update #: 63
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
(require 'enzo-translate)
(if (eq system-type 'gnu/linux)
    (require 'enzo-eclim))

(add-hook 'emacs-startup-hook
          (lambda ()
            (auto-fill)
            (global-evil-leader-mode)
            (evil-mode)
            (projectile-global-mode)
            (setf enable-local-variables :safe)))

(provide 'init-local)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-local.el ends here
