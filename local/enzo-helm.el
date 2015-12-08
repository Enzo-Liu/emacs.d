(require 'helm-config)
;;; Enable Modes (This is loading nearly everything).
;;
(require 'helm)

(helm-mode 1)
;;(helm-adaptative-mode 1)
;; (helm-autoresize-mode 1)
(helm-push-mark-mode 1)

(require 'projectile)
(require-package 'helm-projectile)
(require 'helm-projectile)
(helm-projectile-on)

;;; Helm-command-map
;;
;;
(define-key helm-command-map (kbd "g")   'helm-apt)
(define-key helm-command-map (kbd "w")   'helm-psession)
(define-key helm-command-map (kbd "z")   'helm-complex-command-history)
(define-key helm-command-map (kbd "w")   'helm-w3m-bookmarks)
(define-key helm-command-map (kbd "x")   'helm-firefox-bookmarks)
(define-key helm-command-map (kbd "#")   'helm-emms)
(define-key helm-command-map (kbd "I")   'helm-imenu-in-all-buffers)

;;; Global-map
;;
;;
(global-set-key (kbd "M-x")                          'undefined)
(global-set-key (kbd "M-x")                          'helm-M-x)
(global-set-key (kbd "M-y")                          'helm-show-kill-ring)
(global-set-key (kbd "C-c f")                        'helm-recentf)
(global-set-key (kbd "C-x C-f")                      'helm-find-files)
(global-set-key (kbd "C-c <SPC>")                    'helm-all-mark-rings)
(global-set-key (kbd "C-x r b")                      'helm-filtered-bookmarks)
(global-set-key (kbd "C-h r")                        'helm-info-emacs)
(global-set-key (kbd "C-:")                          'helm-eval-expression-with-eldoc)
(global-set-key (kbd "C-,")                          'helm-calcul-expression)
(global-set-key (kbd "C-h i")                        'helm-info-at-point)
(global-set-key (kbd "C-x C-d")                      'helm-browse-project)
(global-set-key (kbd "<f1>")                         'helm-resume)
(global-set-key (kbd "C-h C-f")                      'helm-apropos)
(global-set-key (kbd "<f5> s")                       'helm-find)
(global-set-key (kbd "<f2>")                         'helm-execute-kmacro)
(global-set-key (kbd "C-c g")                        'helm-gid)
(global-set-key (kbd "C-c i")                        'helm-imenu-in-all-buffers)
(define-key global-map [remap jump-to-register]      'helm-register)
(define-key global-map [remap list-buffers]          'helm-buffers-list)
(define-key global-map [remap dabbrev-expand]        'helm-dabbrev)
(define-key global-map [remap find-tag]              'helm-etags-select)
(define-key global-map [remap xref-find-definitions] 'helm-etags-select)
(define-key global-map (kbd "M-g a")                 'helm-do-grep-ag)

;; Shell bindings
(define-key shell-mode-map (kbd "M-p")               'helm-comint-input-ring) ; shell history.

;;; Helm-variables
;;
;;
(setq helm-net-prefer-curl                       t
      helm-kill-ring-threshold                   1
      helm-raise-command                         "wmctrl -xa %s"
      helm-scroll-amount                         4
      helm-idle-delay                            0.01
      helm-input-idle-delay                      0.01
      helm-ff-search-library-in-sexp             t
      helm-default-external-file-browser         "thunar"
      helm-pdfgrep-default-read-command          "evince --page-label=%p '%f'"
      helm-ff-auto-update-initial-value          t
      helm-grep-default-command                  "ack -Hn --smart-case --no-group %e %p %f"
      helm-grep-default-recurse-command          "ack -H --smart-case --no-group %e %p %f"
      helm-reuse-last-window-split-state         t
      helm-always-two-windows                    t
      helm-buffers-favorite-modes                (append helm-buffers-favorite-modes
                                                         '(picture-mode artist-mode))
      helm-ls-git-status-command                 'magit-status-internal
      helm-M-x-requires-pattern                  0
      helm-dabbrev-cycle-threshold               5
      helm-surfraw-duckduckgo-url                "https://duckduckgo.com/?q=%s&ke=-1&kf=fw&kl=fr-fr&kr=b&k1=-1&k4=-1"
      helm-boring-file-regexp-list               '("\\.git$" "\\.hg$" "\\.svn$" "\\.CVS$" "\\._darcs$" "\\.la$" "\\.o$" "\\.i$")
      helm-buffer-skip-remote-checking           t
      helm-apropos-fuzzy-match                   t
      helm-M-x-fuzzy-match                       t
      helm-lisp-fuzzy-completion                 t
      helm-completion-in-region-fuzzy-match      t
      helm-move-to-line-cycle-in-source          t
      ido-use-virtual-buffers                    t             ; Needed in helm-buffers-list
      helm-tramp-verbose                         6
      helm-buffers-fuzzy-matching                t
      helm-locate-command                        "locate %s -e -A --regex %s"
      helm-org-headings-fontify                  t
      helm-autoresize-max-height                 80 ; it is %.
      helm-autoresize-min-height                 20 ; it is %.
      helm-buffers-to-resize-on-pa               '("*helm apropos*" "*helm ack-grep*"
                                                   "*helm grep*" "*helm occur*"
                                                   "*helm multi occur*" "*helm git-grep*"
                                                   "*helm imenu*" "*helm imenu all*"
                                                   "*helm gid*" "*helm semantic/imenu*")
      fit-window-to-buffer-horizontally          1
      helm-open-github-closed-issue-since        7
      helm-search-suggest-action-wikipedia-url
      "https://wikipedia.org/wiki/Special:Search?search=%s"
      helm-wikipedia-suggest-url
      "https://wikipedia.org/w/api.php?action=opensearch&search="
      helm-wikipedia-summary-url
      "https://wikipedia.org/w/api.php?action=parse&format=json&prop=text&section=0&page=")


;;; fuzzy match config
(setq helm-M-x-fuzzy-match t)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)
(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match    t)

(provide 'enzo-helm)
