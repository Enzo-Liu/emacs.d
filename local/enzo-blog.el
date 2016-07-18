;;; enzo-blog.el ---
;;
;; Filename: enzo-blog.el
;; Description:
;; Author: Liu Enze
;; Maintainer:
;; Created: Mon Feb  1 22:23:40 2016 (+0800)
;; Version:
;; Package-Requires: ()
;; Last-Updated: Fri Jul 15 12:03:27 2016 (+0800)
;;           By: enzo liu
;;     Update #: 24
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

(setf user-full-name "enzo liu")
(setf user-mail-address "liuenze6516@gmail.com")

(require-package 'org-page)
(require 'org-page)
(setq op/repository-directory (substitute-in-file-name "$HOME/Documents/blog/"))
(setq op/site-domain "https://blog.enzo.cc/")
;;; for commenting, you can choose either disqus or duoshuo
(setq op/personal-disqus-shortname "enzo-liu")
;;; the configuration below are optional
;;;(setq op/personal-google-analytics-id "your_google_analytics_id")

(setq op/site-main-title "enzo's note book")
(setq op/site-sub-title "M-x (sketch for random ideas)")
(setq op/personal-github-link "https://github.com/Enzo-Liu")
(setq op/category-ignore-list '("work" "draft"))

(provide 'enzo-blog)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; enzo-blog.el ends here
