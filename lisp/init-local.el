;;; init-local.el --- local init for emacs

;;; Commentary:
;;


;;; Code:
(require-package 'evil)
(require-package 'evil-leader)
(require-package 'projectile)
(require-package 'auto-complete-clang)

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
                 "
/usr/include/c++/4.8
/usr/include/x86_64-linux-gnu/c++/4.8
/usr/include/c++/4.8/backward
/usr/lib/gcc/x86_64-linux-gnu/4.8/include
/usr/local/include
/usr/lib/gcc/x86_64-linux-gnu/4.8/include-fixed
/usr/include/x86_64-linux-gnu
/usr/include
")))
  (setq ac-sources (append '(ac-source-clang) ac-sources)))
(add-hook 'c-mode-hook 'my-ac-cc-mode-setup)
(add-hook 'c++-mode-hook 'my-ac-cc-mode-setup)

;;;AC Config End
;;;
;;;Eclim Config Start
(defun setup-eclim ()
  "Eclim setup, include auto complete,but just use this in linux."
  (require-package 'emacs-eclim)
  (require 'eclim)
  (global-eclim-mode)
  (custom-set-variables
   '(eclim-eclipse-dirs '("~/eclipse"))
   '(eclim-executable "~/eclipse/eclim"))
  (setq help-at-pt-display-when-idle t)
  (setq help-at-pt-timer-delay 0.1)
  (help-at-pt-set-timer)
  (require 'ac-emacs-eclim-source)
  (add-hook 'java-mode-hook 'ac-emacs-eclim-java-setup))
(unless *is-a-mac* (setup-eclim))
;;;Eclim Config End

(desktop-save-mode 0)
(setq slime-contribs '(slime-repl slime-fuzzy slime-scratch))
(auto-save-mode 0)
(setq auto-save-default nil)
(setq require-final-newline t)
(setq-default make-backup-files nil)
(setq scroll-margin 3
      scroll-conservatively 10000)

(setq ring-bell-function 'ignore)

(add-hook 'emacs-startup-hook
          (lambda ()
            (evil-mode)))

(add-hook 'emacs-startup-hook
          (lambda ()
            (projectile-global-mode)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(defun uco (name)
  "Use this to init the ${NAME} programming for usacontext."
  (interactive "sinput the program name you want to open or create: ")
  (let* ((prefix `((t . "~") (nil . "~/host")))
         (sedcmd `((t . "sed -i '' ") (nil . "sed -i ")))
         (path (concat (cdr (assoc *is-a-mac* prefix)) "/Work/git/usacontext/" ))
         (folder (concat path name "/")))
    (unless (file-exists-p folder)
      (make-directory folder)
      (shell-command (concat  "cp " path  "sample/sample.cpp " folder name ".cpp && "
                              (cdr (assoc *is-a-mac* sedcmd)) "'s/#{name}/" name "/' " folder "*.cpp" )))
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

(provide 'init-local)

;;; init-local.el ends here
