(require-package 'emacs-eclim)
(require 'eclim)
(require 'eclimd)

(if (eq system-type 'darwin)
    (custom-set-variables
     '(eclim-eclipse-dirs '("/Users/liuenze/work_soft/Eclipse.app/Contents/Eclipse"))
     '(eclim-executable "/Users/liuenze/work_soft/Eclipse.app/Contents/Eclipse/eclim")
     '(eclimd-executable "/Users/liuenze/work_soft/Eclipse.app/Contents/Eclipse/eclimd")
     '(eclimd-default-workspace "~/workspace"))
  (custom-set-variables
   '(eclim-eclipse-dirs '("~/work_soft/eclipse"))
   '(eclim-executable "~/work_soft/eclipse/eclim")
   '(eclimd-executable "~/work_soft/eclipse/eclimd")
   '(eclimd-default-workspace "~/workspace")))
(setq eclimd-wait-for-process nil)


(require-package 'ag)
(require 'ag)
(defun enzo-projectile-find-todo ()
  (interactive)
  (projectile-ag "TODO:"))

(require-package 'hydra)

(defhydra hydra-eclim (:color teal
                              :hint nil)
  "
Eclim:
 ╭─────────────────────────────────────────────────────┐
 │ Java                                                │       Problems
╭┴─────────────────────────────────────────────────────┴────────────────────────────────────╯
  _d_: Show Doc             _i_: Implement (Override)          _p_: Show Problems
  _g_: Make getter/setter  _fd_: Find Declarations             _c_: Show Corrections
  _o_: Organize Imports    _fr_: Find References               _r_: Buffer Refresh
  _h_: Hierarchy            _R_: Refactor                      _t_: Find Todo
  _C_: Compile

Project                            Android
─────────────────────────────────────────────────────────
_j_: Jump to proj           _a_: Start Activity
_b_: Create                 _m_: Clear/Build/Install
_k_: Import Proj            _e_: Start Emulator
                          ^_l_: Logcat
"
  ("d"   eclim-java-show-documentation-for-current-element)
  ("g"   eclim-java-generate-getter-and-setter)
  ("o"   eclim-java-import-organize)
  ("h"   eclim-java-call-hierarchy)
  ("i"   eclim-java-implement)
  ("fd"  eclim-java-find-declaration)
  ("fr"  eclim-java-find-references)
  ("R"   eclim-java-refactor-rename-symbol-at-point)
  ("p"   eclim-problems)
  ("c"   eclim-problems-correct)
  ("r"   eclim-problems-buffer-refresh)
  ("t"   enzo-projectile-find-todo)
  ("C"   (lambda () (interactive)
           (let ((compilation-read-command nil)
                 (projectile-project-compilation-cmd "mvn clean install"))
             (projectile-compile-project nil))))
  ("j"   eclim-project-goto)
  ("b"   eclim-project-create)
  ("k"   eclim-project-import)
  ("a"   android-start-app)
  ("m"   my-clean-debug-install)
  ("e"   android-start-emulator)
  ("l"   android-logcat)
  ("q"   nil "cancel" :color blue))

(define-key eclim-mode-map (kbd "C-c e") 'hydra-eclim/body)

;; (require-package 'ensime)
;; (require-package 'sbt-mode)
;; (require-package 'scala-mode2)

(add-hook 'java-mode-hook
          (lambda ()
            ;; regular auto-complete initialization
            (require 'auto-complete-config)
            (ac-config-default)
            ;; add the emacs-eclim source
            (require 'ac-emacs-eclim-source)
            (ac-emacs-eclim-config)
            (eclim-mode t)
            (setq c-basic-offset 4)))

(after-load 'exec-path-from-shell
  (dolist (var '("JAVA_HOME"))
    (add-to-list 'exec-path-from-shell-variables var)))

(provide 'enzo-eclim)
