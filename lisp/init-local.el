;;; init-local.el --- local init for emacs

;;; Commentary:
;;


;;; Code:
(require-package 'evil)
(require-package 'evil-leader)
(require-package 'projectile)
(require-package 'auto-complete-clang)
(require-package 'emacs-eclim)

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
(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-insert-state-map (kbd "C-u")
  (lambda ()
    (interactive)
    (evil-delete (point-at-bol) (point))))
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
(require 'eclim)
(global-eclim-mode)
(custom-set-variables
  '(eclim-eclipse-dirs '("~/eclipse"))
  '(eclim-executable "~/eclipse/eclim"))
(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)
(help-at-pt-set-timer)
(require 'ac-emacs-eclim-source)
(add-hook 'java-mode-hook 'ac-emacs-eclim-java-setup)
;;;Eclim Config End

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

(if (not (display-graphic-p))
    (add-hook 'after-init-hook
              (lambda ()
                (xterm-mouse-mode 1) ; Mouse in a terminal (Use shift to paste with middle button)
                (when (fboundp 'mwheel-install)
                  (mwheel-install)))))


(provide 'init-local)

;;; init-local.el ends here
