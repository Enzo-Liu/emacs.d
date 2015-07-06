;;; package --- enzo-org.el ---
;;
;; Filename: evil-org.el
;; Description:
;; Author: Liu Enze
;; Maintainer:
;; Created: Wed Dec  3 11:12:01 2014 (+0800)
;; Version:
;; Package-Requires: ()
;; Last-Updated: Mon Jul  6 10:58:48 2015 (+0800)
;;           By: enzo-liu
;;     Update #: 73
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

(require 'evil)

(defun setupEvilOrg ()
  "Setup TAB For Org mode in Evil."
  (define-key evil-normal-state-map (kbd "TAB") 'org-cycle))

(setq org-src-fontify-natively t)
(setq org-export-allow-bind-keywords t)

(require-package 'ox-gfm)

(defvar *beamer*
  '("beamer"
    "\\documentclass[presentation]{beamer}"
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")
    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
    ("\\paragraph{%s}" . "\\paragraph*{%s}")
    ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
  "Beamer org export latex config.")
(defvar *book*
  '("book"
    "\\documentclass[11pt,a4paper]{article}"
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")
    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
    ("\\paragraph{%s}" . "\\paragraph*{%s}")
    ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
  "Book org export latex config.")
(defvar *resume*
  '("resume"
    "\\documentclass[11pt,a4paper]{article}
\\usepackage[T1]{fontenc}
\\usepackage{fontspec}
\\usepackage{xeCJK}
\\setCJKmainfont[BoldFont=FandolSong-Bold.otf,ItalicFont=FandolKai-Regular.otf]{FandolSong-Regular.otf}
\\setCJKsansfont[BoldFont=FandolHei-Bold.otf]{FandolHei-Regular.otf}
\\setCJKmonofont{FandolFang-Regular.otf}
\\usepackage{xcolor}
\\usepackage{listings}
\\usepackage{hyperref}
\\usepackage{graphicx}
\\defaultfontfeatures{Mapping=tex-text}
\\usepackage{geometry}
\\usepackage{verbatim}
\\geometry{a4paper, textwidth=6.5in, textheight=10in,
            marginparsep=7pt, marginparwidth=.6in}
\\pagestyle{empty}
     [NO-DEFAULT-PACKAGES]
     [NO-PACKAGES]
"
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")
    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
    ("\\paragraph{%s}" . "\\paragraph*{%s}")
    ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
  "Acticle org export latex config.")
(defvar *article*
  '("article"
    "\\documentclass[11pt,a4paper]{article}
\\usepackage[T1]{fontenc}
\\usepackage{fontspec}
\\usepackage{xeCJK}
\\setCJKmainfont[BoldFont=FandolSong-Bold.otf,ItalicFont=FandolKai-Regular.otf]{FandolSong-Regular.otf}
\\setCJKsansfont[BoldFont=FandolHei-Bold.otf]{FandolHei-Regular.otf}
\\setCJKmonofont{FandolFang-Regular.otf}
\\usepackage{hyperref}
\\usepackage{graphicx}
\\usepackage{xcolor}
\\usepackage{listings}
\\defaultfontfeatures{Mapping=tex-text}
\\usepackage{geometry}
\\usepackage{verbatim}
\\geometry{a4paper, textwidth=6.5in, textheight=10in,
            marginparsep=7pt, marginparwidth=.6in}
\\pagestyle{empty} "
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")
    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
    ("\\paragraph{%s}" . "\\paragraph*{%s}")
    ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
  "Acticle org export latex config.")

(eval-after-load "org"
  '(progn
     (require 'ox-md nil t)
     (require 'ox-latex)
     (setq org-latex-pdf-process
           '("xelatex -interaction nonstopmode %f"
             "xelatex -interaction nonstopmode %f"))
     (unless (boundp 'org-latex-classes)
       (setq org-latex-classes nil))
     (setq org-latex-listings 'listings)
     (setq org-latex-custom-lang-environments
           '((emacs-lisp "common-lispcode")))
     (setq org-latex-listings-options
           '(("frame" "single")
             ("backgroundcolor" "\\color[gray]{0.95}")
             ("identifierstyle" "\\ttfamily")
             ("keywordstyle" "\\color[rgb]{0,0,1}")
             ("commentstyle" "\\color[rgb]{0.133,0.545,0.133}")
             ("stringstyle" "\\color[rgb]{0.627,0.126,0.941}")
             ("basicstyle" "\\scriptsize")
             ("extendedchars" "true")
             ("breaklines" "true")
             ("prebreak" "\\raisebox{0ex}[0ex][0ex]{\\ensuremath{\\hookleftarrow}}")
             ("columns" "fixed")
             ("keepspaces" "true")
             ("showstringspaces" "false")
             ("numbers" "left")
             ("numberstyle" "\\tiny")))
     (require 'ox-beamer)
     (dolist (class (list *article* *book* *resume* *beamer*))
       (add-to-list 'org-latex-classes
                    class))))
(setq org-confirm-babel-evaluate nil)
(setq org-descriptive-links nil)

;; org 自动换行
(add-hook 'org-mode-hook
          (lambda ()
            (turn-off-auto-fill)
            (toggle-truncate-lines 0)
            (setupEvilOrg)))

(defadvice org-html-paragraph (before org-html-paragraph-advice
                                      (paragraph contents info) activate)
  "Join consecutive Chinese lines into a single long line without unwanted space when exporting 'org-mode to html."
  (let* ((origin-contents (ad-get-arg 1))
         (fix-regexp "[[:multibyte:]]")
         (fixed-contents
          (replace-regexp-in-string
           (concat
            "\\(" fix-regexp "\\) *\n *\\(" fix-regexp "\\)") "\\1\\2" origin-contents)))
    (ad-set-arg 1 fixed-contents)))

(provide 'enzo-org)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; enzo-org.el ends here
