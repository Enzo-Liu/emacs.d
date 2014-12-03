;;; package --- enzo-uco.el ---
;;
;; Filename: enzo-uco.el
;; Description:
;; Author: Liu Enze
;; Maintainer:
;; Created: Wed Dec  3 11:05:44 2014 (+0800)
;; Version:
;; Package-Requires: ()
;; Last-Updated: Wed Dec  3 15:47:45 2014 (+0800)
;;           By: Liu Enze
;;     Update #: 3
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
(require-package 'helm)

(require 'helm)

(defun get-usaco-path ()
  "Get home path for usaco.  Consider in mac or linux."
  (let* ((prefix `((t . "~") (nil . "~/host")))
         (path (concat (cdr (assoc *is-a-mac* prefix)) "/Work/git/usacontext/" )))
    path))

(defun get-folder-last-modify-date (folder)
  "Return the FOLDER last modify date."
  (substring
   (shell-command-to-string (format "ls -ld %s | awk -F' '  '{ print $6 \" \"$7 }'" folder))
   0 -1))

(defun usaco-format (folder name type)
  "Given FOLDER, NAME, &KEY TYPE, return ((NAME . NAME) (TYPE . TYPE) (FOLDER . FOLDER))."
  (cons (concat name "-" (symbol-name type))
        `(("name" . ,name)
          ("folder" . ,folder)
          ("type" . ,type))))

(defun string/start-with (s begins)
  "Return non-nil if string S start with BEGINS."
  (cond ((>= (length s) (length begins))
         (string-equal (substring s 0 (length begins)) begins))
        (t nil)))

(defun list-sub-directory (path)
  "List all the directory below PATH.  Just the first level."
  (let ((res '()))
    (dolist (f (directory-files path))
      (let ((name (concat path "/" f)))
        (when (and (file-directory-p name)
                   (not (string/start-with f ".")))
          (setf res (push f res)))))
    res))

(defun get-done-project (path)
  "Get all done project by path.  The done project list in $PATH/done/."
  (let ((done-path (concat path "done/")))
    (mapcar #'(lambda (name) (usaco-format (concat done-path name) name :DONE))
            (list-sub-directory done-path))))

(defun get-unfinished-project (path)
  "Get all unfinished project by path.  The done project list in $PATH/done/."
  (let ((done-path path))
    (mapcar #'(lambda (name) (usaco-format (concat done-path name) name :TODO))
            (remove-if #'(lambda (name) (equal name "done")) (list-sub-directory done-path)))))

(defun usaco-lookup ()
  "Search for exsiting usaco programs and leave an add option."
  (let ((path (get-usaco-path)))
    (append
     (list (usaco-format path "undefined" :CREATE))
     (get-unfinished-project path)
     (get-done-project path))))

(defun actions-for-usaco (actions program)
  "Return ACTIONS for selecting a PROGRAM."
  (let ((type (cdr (assoc "type" program))))
    (cond ((equal type :CREATE)
           `(("CREATE" . uco-create)))
          ((equal type :TODO)
           `(("OPEN" . uco-display)
             ("MARK-DONE" . uco-done)
             ("REMOVE" . uco-remove)))
          (t `(("OPEN" . uco-display)
               ("MARK-UNDONE" . uco-undone))))))

(defvar uco-helm-source-search
  '((name . "USACO")
    (candidates-process . usaco-lookup)
    (action-transformer . actions-for-usaco)))

(defun uco ()
  "Use this to init the ${NAME} programming for usacontext."
  (interactive)
  (helm :sources '(uco-helm-source-search)
        :buffer "*usaco-search*"
        :candidate-number-limit 20))

(defun uco-create (name)
  "Create program in usaco for the input NAME."
  (interactive "s please input the program name you want to create: ")
  (let* ((sedcmd `((t . "sed -i '' ") (nil . "sed -i ")))
         (path (get-usaco-path))
         (folder (concat path name "/")))
    (unless (file-exists-p folder)
      (make-directory folder)
      (shell-command (concat  "cp " path  "sample/sample.cpp " folder name ".cpp && "
                              (cdr (assoc *is-a-mac* sedcmd)) "'s/#{name}/" name "/' " folder "*.cpp" )))
    (uco-display `(("folder" . ,folder) ("name" . ,name)))))

(defun uco-undone (program)
  "Mark this PROGRAM to be undone."
  (let* ((folder (cdr (assoc "folder" program)))
         (dest (concat folder "/../../"))
         (cmd (concat "mv " folder " " dest)))
    (shell-command cmd)))

(defun uco-remove(program)
  "Remove this PROGRAM."
  (let ((folder (cdr (assoc "folder" program))))
    (shell-command (concat "rm -rf " folder))))

(defun uco-done (program)
  "Mark this PROGRAM has been done."
  (let* ((folder (cdr (assoc "folder" program)))
         (dest (concat folder "/../done/"))
         (cmd (concat "mv " folder " " dest)))
    (shell-command cmd)))

(defun uco-display (program)
  "Display for the exsiting PROGRAM."
  (let* ((name (cdr (assoc "name" program)))
         (folder (concat (cdr  (assoc "folder" program)) "/"))
         (uco-cpp (concat folder name ".cpp"))
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
    (windmove-left)
    (toggle-frame-fullscreen)))

(provide 'enzo-uco)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; enzo-uco.el ends here
