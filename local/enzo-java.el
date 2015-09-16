;;; Code:

;;=============================================================================
;; tomacat
(require-package 'log4j-mode)
(defvar tomcat-process nil "Process running tomcat")
(defvar tomcat-buffer nil "Buffer containing tomcat-process")
(defvar tomcat-is-running nil "Is tomcat running ?")

(defun tomcat-script ()
  "Script to start or stop tomcat"
  (let* ((catalina-home (getenv "CATALINA_HOME"))
         ;; or set `default-directory' variable
         (catalina-bin (expand-file-name "bin" catalina-home)))
    (expand-file-name (if (eq system-type 'windows-nt)
                          "catalina.bat"
                        "catalina.sh")
                      catalina-bin)))

(defun tomcat-start ()
  (switch-to-buffer "*tomcat*")
  (setq tomcat-buffer (current-buffer))
  (erase-buffer)
  (log4j-mode)
  (setq tomcat-process
        (start-process "tomcat" (current-buffer)
                       (tomcat-script) "run"))
  (setq tomcat-is-running t)
  (beginning-of-buffer)
  (message "Tomcat started."))

(defun tomcat-stop ()
  (message "Stopping Tomcat ...")
  (save-excursion
    (switch-to-buffer "*tomcat*")
    (goto-char (point-max)))
  (call-process (tomcat-script) nil "*tomcat-stop*" t "stop")
  (setq tomcat-is-running nil)
  (kill-buffer "*tomcat-stop*")
  (message "Tomcat stopped"))

(defun tomcat-toggle()
  "Stop or start Tomcat"
  (interactive)
  (if tomcat-is-running
      (tomcat-stop)
    (tomcat-start)))

;;=============================================================================

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

(defmacro maven-def-task (name command)
  `(defun ,name ()
     (interactive)
     (cd (projectile-project-root))
     (compile ,command t)))

(maven-def-task maven-compile "mvn compile")
(maven-def-task maven-clean "mvn clean")
(maven-def-task maven-package "mvn package")
(maven-def-task maven-all "mvn clean install")

(defun enzo-mvn-deploy-and-start ()
  "Deploy war to tomcat."
  (interactive)
  (if tomcat-is-running
      (tomcat-stop))
  (let* ((project (projectile-project-root))
         (default-directory (concat (getenv "CATALINA_HOME") "/bin/")))
    (shell-command (concat "deploy " project))
    (tomcat-start)))

(require-package 'hydra)
(require 'hydra)
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
  _C_: Compile              _D_: Deploy

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
  ("D"   enzo-mvn-deploy-and-start)
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
  (dolist (var '("JAVA_HOME"  "CATALINA_HOME"))
    (add-to-list 'exec-path-from-shell-variables var)))

(provide 'enzo-java)
