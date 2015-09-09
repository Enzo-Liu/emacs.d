(require-package 'emacs-eclim)
(require 'eclim)
(require 'eclimd)

(if (eq system-type 'darwin)
    (custom-set-variables
     '(eclim-eclipse-dirs '("/Users/liuenze/work_soft/Eclipse.app/Contents/Eclipse"))
     '(eclim-executable "/Users/liuenze/work_soft/Eclipse.app/Contents/Eclipse/eclim")
     '(eclimd-executable "/Users/liuenze/work_soft/Eclipse.app/Contents/Eclipse/eclimd"))
  (custom-set-variables
   '(eclim-eclipse-dirs '("~/work_soft/eclipse"))
   '(eclim-executable "~/work_soft/eclipse/eclim")
   '(eclimd-executable "~/work_soft/eclipse/eclim/eclimd")))

;; (require-package 'ensime)
;; (require-package 'sbt-mode)
;; (require-package 'scala-mode2)

(add-hook 'java-mode-hook
          (lambda ()
            ;; regular auto-complete initialization
            (require 'auto-complete-config)
            (ac-config-default)
            (setq-local ac-sources '(ac-source-emacs-eclim))
            ;; add the emacs-eclim source
            (require 'ac-emacs-eclim-source)
            (ac-emacs-eclim-config)
            (setq-local ac-auto-start t)
            (setq-local ac-delay 1)
            (eclim-mode t)
            (setq c-basic-offset 4)))

(after-load 'exec-path-from-shell
  (dolist (var '("JAVA_HOME"))
    (add-to-list 'exec-path-from-shell-variables var)))

(provide 'enzo-eclim)
