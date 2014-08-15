(require-package 'evil)
(require-package 'evil-leader)
(require-package 'projectile)

(global-evil-leader-mode)

(evil-leader/set-key
  "e" 'find-file
  "b" 'switch-to-buffer
  "k" 'kill-buffer
  "w" 'save-buffer
  "q" 'save-buffers-kill-terminal)

(evil-leader/set-leader ",")

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

(add-hook 'emacs-startup-hook
          (lambda ()
            (evil-mode)))

(add-hook 'emacs-startup-hook
          (lambda ()
            (projectile-global-mode)))

(provide 'init-local)
