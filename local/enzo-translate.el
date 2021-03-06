;;; package --- Summary enzo-translate.el ---
;;
;; Filename: enzo-translate.el
;; Description:
;; Author:
;; Maintainer:
;; Created: Thu Feb 26 17:53:07 2015 (+0900)
;; Version: 1.0.0
;; Package-Requires: ()
;; Last-Updated: Wed Jun 24 13:25:35 2015 (+0800)
;;           By: Liu Enze
;;     Update #: 7
;; URL:
;; Doc URL:
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;; the file is copy from
;; https://github.com/xuchunyang/google-translate-chinese.el
;; since I cant find the elpa package
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

(require-package 'google-translate)
(require-package 'popup)
(require-package 'chinese-word-at-point)
(require-package 'names)

(require 'google-translate)
(require 'popup)
(require 'chinese-word-at-point)
;;;###autoload
(define-namespace google-translate-chinese-

(defun -region-or-word ()
  (if (use-region-p)
      (buffer-substring-no-properties (region-beginning)
                                      (region-end))
    (thing-at-point 'chinese-or-other-word t)))

(defun -bounds-region-or-word ()
  (if (use-region-p)
      (cons (region-beginning) (region-end))
    (bounds-of-thing-at-point 'chinese-or-other-word)))

(defun -translate (word)
  (google-translate-json-translation
   (if (chinese-word-cjk-string-p word)
       (google-translate-request "zh-CN" "en" word)
     (google-translate-request "en" "zh-CN" word))))

(defun -detailed-translate (word)
  (google-translate-json-detailed-translation
   (if (chinese-word-cjk-string-p word)
       (google-translate-request "zh-CN" "en" word)
     (google-translate-request "en" "zh-CN" word))))

(defun concat-array-as-string (v)
  "Concat strings in v to a whole string."
  (let ((index 0) (str ""))
    (while (< index (length v))
      (setq str (concat str (elt v index) ", "))
      (cl-incf index))
    (substring str 0 (- (length str) 2))))

:autoload
(defun at-point ()
  "Translate at point and show full result with buffer."
  (interactive)
  (let ((word (-region-or-word)))
    (if word
        (if (chinese-word-cjk-string-p word)
            (google-translate-translate "zh-CN" "en" word)
          (google-translate-translate "en" "zh-CN" word))
      (message "Nothing to translate"))))

:autoload
(defun at-point-echo-area ()
  "Translate at point and show only translation in echo area. "
  (interactive)
  (let ((word (-region-or-word)))
    (if word
        (message (-translate word))
      (message "Nothing to translate"))))

:autoload
(defun query ()
  "Translate input and show full result with buffer."
  (interactive)
  (let* ((word (-region-or-word))
         (word (read-string (format "Translate (%s): "
                                    (or word ""))
                            nil nil
                            word)))
    (if word
        (if (chinese-word-cjk-string-p word)
            (google-translate-translate "zh-CN" "en" word)
          (google-translate-translate "en" "zh-CN" word))
      (message "Nothing to translate"))))

:autoload
(defun search-at-point-and-replace ()
  "可以不写 DocString."
  (interactive)
  (let ((word (-region-or-word))
        (bounds (-bounds-region-or-word)))
    (if (and word bounds)
        (let (explains
              popup-list
              (detailed-translate (-detailed-translate word))
              selected-item)
          (if (not detailed-translate)
              (progn
                (setq selected-item (popup-menu* (list (popup-make-item (-translate word)))))
                ;; 此处假设了光标在词的后面，而不是其它位置，下同
                (delete-region (car bounds) (cdr bounds))
                (insert selected-item))
            (loop for item across detailed-translate do
                  (let ((index 0))
                    (unless (string-equal (aref item 0) "")
                      (loop for translation across (aref item 1) do
                            (push (format "%d. %s" (incf index) translation) popup-list)
                            (push (concat "<" (substring (aref item 0) 0 1) "> "
                                          (concat-array-as-string (elt (elt (aref item 2) (1- index)) 1)))
                                  popup-list)))))

            (setq popup-list (reverse popup-list))

            (let ((index 0) (a-popup-menu nil))
              (while (< index (length popup-list))
                (push (popup-make-item (nth index popup-list)
                                       :summary (nth (1+ index) popup-list))
                      a-popup-menu)
                (setq index (+ index 2)))
              (setq selected-item (popup-menu* (reverse a-popup-menu)))
              (delete-region (car bounds) (cdr bounds))
              (insert (substring selected-item 3)))))
      (message "Nothing to translate"))))

:autoload
(defun open-word-with-web ()
  "搜索附近的词，用浏览器打开。"
  (interactive)
  (let ((word (-region-or-word))
        from to)
    (if (not word)
        (message "No word found")
      (if (chinese-word-cjk-string-p word)
          (setq from "zh-CN" to "en")
        (setq from "en" to "zh-Cn"))
      ;; URL 格式：比如需要搜索 "example" (en => zh-Cn), URL
      ;; `https://translate.google.cn/#en/zh-CN/example'
      (browse-url (concat "https://translate.google.cn/#"
                          from "/" to "/"
                          (url-hexify-string word))))))

:autoload
(defun search-and-replace ()
  "Search word at point and replace with selected result."
  (interactive)
  (let ((word (thing-at-point 'word t))
        (bounds (bounds-of-thing-at-point 'word))
        selected)
    (if (not (and word bounds))
        (message "Nothing to translate")
      (setq selected (popup-menu* `("item 1" "item 2" ,word)))
      (delete-region (car bounds) (cdr bounds))
      (insert selected)))))

(provide 'enzo-translate)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; enzo-translate.el ends here
