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

(evil-leader/set-key
  "e" 'find-file
  "b" 'switch-to-buffer
  "k" 'kill-buffer
  "w" 'save-buffer
  "q" 'save-buffers-kill-terminal)

(evil-leader/set-leader ",")

(require 'evil)
(define-key evil-insert-state-map "j" #'cofi/maybe-exit)

(evil-define-command cofi/maybe-exit ()
                     :repeat change
                     (interactive)
                     (let ((modified (buffer-modified-p)))
                       (insert "j")
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
  (setq ac-sources (append '(ac-source-clang) ac-sources)))
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
;;;AC Config End

(desktop-save-mode 0)
(setq slime-contribs '(slime-repl slime-fuzzy slime-scratch))
(auto-save-mode 0)
(setq auto-save-default nil)
(setq require-final-newline t)
(setq-default make-backup-files nil)
(setq scroll-margin 3
       scroll-conservatively 10000)

(setq visible-bell nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (evil-mode)))

(add-hook 'emacs-startup-hook
          (lambda ()
            (projectile-global-mode)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(provide 'init-local)

;;; init-local.el ends here
