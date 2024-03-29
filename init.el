(require 'package)

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
  ;; and `package-pinned-packages`. Most users will not need or want to do this.
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  )
(package-initialize)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes '(tsdh-dark))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(mu4e-query-fragments mu4e-overview json-mode gdscript-mode zones company-irony projectile-git-autofetch projectile magit clang-format+ clang-format git cmake-mode glsl-mode fireplace column-enforce-mode company-rtags rtags rtags-xref flycheck eyebrowse ctags-update auto-complete-clang-async))
 '(send-mail-function 'mailclient-send-it))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;;------------------------------------------------------------------------------------------
;;; Commentary: MY OWN ADDITIONS
;;-------------------------------------------------------------------------------------------

;;; Code:


;; Add the hidden directory in emacs home directory to load any plain
;; lisp scripts
 (push '"/home/dustin/.emacs_scripts" load-path)

;; Clang stuff
(require 'clang-format)
(setq clang-format-style "file")
(global-set-key [C-M-tab] 'clang-format-region)
(add-hook 'c++-mode-hook 'clang-format+-mode)
(add-hook 'c-mode-common-hook #'clang-format+-mode)

(add-hook 'c++-mode-hook 
	  (lambda () (define-key c-mode-base-map (kbd "C-c C-l") 'compile)))
(add-hook 'c-mode-common-hook 
(lambda () (define-key c-mode-base-map (kbd "C-c C-l") 'compile)))
;; Always have auto-complete mode on
;; Auto-complet-mode may interfere with company-mode autocomplete, so disable it
;;(add-hook 'after-init-hook 'global-company-mode)

;; Set some possible directories for ff-find-other-file to search in
(setq cc-search-directories '("." ".." "include" "src" "../include" "../src"))

;; Have linum-mode turn on in any programming mode
(add-hook 'prog-mode-hook 'linum-mode)

;;(add-hook 'prog-mode-hook 'column-enforce-mode)

;; Allows for switching quickly between source code header and definition files
(global-set-key (kbd "C-x p") 'ff-find-other-file)

;; For syntax checking
;;(add-hook 'after-init-hook #'global-flycheck-mode)

;; enable semantic mode for source code editing
;;(global-ede-mode 1)
;;(add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)
;;(semantic-mode 1)
;;(require 'semantic/sb)
;;(require 'semantic/ia)
;;(require 'semantic/bovine/gcc)

;; Expands the minibuffer, showing options
(ivy-mode)


;; For rtags
;;-----------
;; (add-hook 'c-mode-hook 'rtags-start-process-unless-running)
;; (add-hook 'c++-mode-hook 'rtags-start-process-unless-running)
;; (add-hook 'objc-mode-hook 'rtags-start-process-unless-running)


;; (defun rtags-peek-definition ()
;;   "Peek at definition at point using rtags."
;;   (interactive)
;;   (let ((func (lambda ()
;;                 (rtags-find-symbol-at-point)
;;                 (rtags-location-stack-forward))))
;;     (rtags-start-process-unless-running)
;;     (make-peek-frame func)))

;; (defun make-peek-frame (find-definition-function &rest args)
;;   "Make a new frame for peeking definition"
;;   (when (or (not (rtags-called-interactively-p)) (rtags-sandbox-id-matches))
;;     (let (summary
;;           doc-frame
;;           x y
;;           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;           ;; 1. Find the absolute position of the current beginning of the symbol at point, ;;
;;           ;; in pixels.                                                                     ;;
;;           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;           (abs-pixel-pos (save-excursion
;;                            (beginning-of-thing 'symbol)
;;                            (window-absolute-pixel-position))))
;;       (setq x (car abs-pixel-pos))
;;       ;; (setq y (cdr abs-pixel-pos))
;;       (setq y (+ (cdr abs-pixel-pos) (frame-char-height)))

;;       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;       ;; 2. Create a new invisible frame, with the current buffer in it. ;;
;;       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;       (setq doc-frame (make-frame '((minibuffer . nil)
;;                                     (name . "*RTags Peek*")
;;                                     (width . 80)
;;                                     (visibility . nil)
;;                                     (height . 15))))

;;       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;       ;; 3. Position the new frame right under the beginning of the symbol at point. ;;
;;       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;       (set-frame-position doc-frame x y)

;;       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;       ;; 4. Jump to the symbol at point. ;;
;;       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;       (with-selected-frame doc-frame
;;         (apply find-definition-function args)
;;         (read-only-mode)
;;         (when semantic-stickyfunc-mode (semantic-stickyfunc-mode -1))
;;         (recenter-top-bottom 0))

;;       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;       ;; 5. Make frame visible again ;;
;;       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;       (make-frame-visible doc-frame))))

;; (global-set-key (kbd "C-c p") 'rtags-peek-definition)
;; (global-set-key (kbd "C-c j") 'rtags-find-symbol-at-point)
;; (global-set-key [f12] 'delete-frame)


;; ensure that we use only rtags checkingz
;; https://github.com/Andersbakken/rtags#optional-1
;; (defun setup-flycheck-rtags ()
;;   (interactive)
;;   (flycheck-select-checker 'rtags)
;;   ;; RTags creates more accurate overlays.
;;   (setq-local flycheck-highlighting-mode nil)
;;   (setq-local flycheck-check-syntax-automatically nil))

;; only run this if rtags is installed
;; (when (require 'rtags nil :noerror)
;;   ;; make sure you have company-mode installed
;;   (require 'company)
;;   (define-key c-mode-base-map (kbd "M-.")
;;     (function rtags-find-symbol-at-point))
;;   (define-key c-mode-base-map (kbd "M-,")
;;     (function rtags-find-references-at-point))
;;   ;; disable prelude's use of C-c r, as this is the rtags keyboard prefix
;;   ;;(define-key prelude-mode-map (kbd "C-c r") nil)
;;   ;; install standard rtags keybindings. Do M-. on the symbol below to
;;   ;; jump to definition and see the keybindings.
;;   (rtags-enable-standard-keybindings)
;;   ;; comment this out if you don't have or don't use helm
;;   ;;(setq rtags-use-helm t)
;;   ;; company completion setup
;;   (setq rtags-autostart-diagnostics t)
;;   (rtags-diagnostics)
;;   (setq rtags-completions-enabled t)
;;   (push 'company-rtags company-backends)
;;   (global-company-mode)
;;   (define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))
;;   ;; use rtags flycheck mode -- clang warnings shown inline
;;   (require 'flycheck-rtags)
;;   ;; c-mode-common-hook is also called by c++-mode
;;   (add-hook 'c-mode-common-hook #'setup-flycheck-rtags))

;; irony mode for auto-complete
;; (add-hook 'c++-mode-hook 'irony-mode)
;; (add-hook 'c-mode-hook 'irony-mode)
;; (add-hook 'objc-mode-hook 'irony-mode)
;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)


;; For syntax highlighting of GLSL files
(autoload 'glsl-mode "glsl-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.glsl\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.vert\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.frag\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.geom\\'" . glsl-mode))



;;; Org mode agenda stuff:
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(setq org-agenda-files (list "~/org/home.org"
			"~/org/work.org"
			"~/org/school.org"
			"~/Documents/school/2021 Spring/math342/notes.org"
			"~/Documents/school/2021 Spring/csc482B/notes.org"
			"~/Documents/school/2021 Spring/astr102/notes.org"
			))
(setq visible-bell 1)

;;; Magic launch
(global-set-key (kbd "C-x G") 'magit-status)
(global-set-key (kbd "C-x g") 'magit-status-here)

;;; For Godot mode
(require 'gdscript-mode)

;; Enable auto-revert mode for all buffer (if the file changes, then the buffer reloads it)
(global-auto-revert-mode t)

;; Enable line-wrapping in at least org-mode
(add-hook 'org-mode-hook 'visual-line-mode)

;; shortcut to compiling things
(require 'cc-mode)
(define-key c-mode-base-map "\C-cb" 'compile)

