;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; == Package Repository ==
;;

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(package-initialize)

(defvar my-packages '(cedet ecb flymake-easy flymake-easy flymake-cursor flymake-python-pyflakes flymake-php auctex php-mode jedi ess magit zenburn-theme yasnippet undo-tree)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))
      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; == General Settings ==
;;

;; Fonts and Colors
;(set-default-font "Terminus-10")
(set-default-font "Inconsolata-11")
;(load-file "~/.emacs.d/extensions/vibrant-ink-theme.el")
(load-theme 'wombat t)
;(load-theme 'zenburn t)

;; Editors
(column-number-mode t)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time-mode t)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq default-major-mode 'text-mode) 
(add-hook 'text-mode-hook  'turn-on-auto-fill)
(setq default-fill-column 80)

(global-font-lock-mode t)
(setq-default indent-tabs-mode nil)    ; use only spaces and no tabs
(setq default-tab-width 4)

;; Cursors and markers
(show-paren-mode t)
(setq show-paren-style 'parenthesis)
;(setq show-paren-style 'expression)
(setq track-eol t) ; move the cursor at the end of lines if it is there
;(setq-default cursor-type 'hollow)
;(setq-default cursor-type 'bar)
(setq-default cursor-type 'box)
(transient-mark-mode t)
(delete-selection-mode t)
(setq scroll-margin 0)
(setq scroll-conservatively 10000) ; avoiding jumps in scrolling
(set-cursor-color "#bbbbbb")
(global-hl-line-mode t)

;; Copy-and-paste
(setq x-select-enable-clipboard t)
(setq mouse-yank-at-point t)

;; Search
(setq search-highlight t)
(setq query-replace-highlight t)

;; Key-binding
; suggesting key binding in 1 second after M-x command
(setq suggest-key-bindings 1) 

;(global-set-key [(meta \up)] 'previous-buffer)  
;(global-set-key [(meta \down)] 'next-buffer)
;(global-set-key [(meta \left)] 'previous-multiframe-window)
;(global-set-key [(meta \right)] 'next-multiframe-window)

(global-set-key [(meta \left)] 'windmove-left)
(global-set-key [(meta \right)] 'windmove-right)
(global-set-key [(meta \up)] 'windmove-up)
(global-set-key [(meta \down)] 'windmove-down)

(defun up-slightly () (interactive) (scroll-up 3))
(defun down-slightly () (interactive) (scroll-down 3))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly) 

;(global-set-key (kbd "C-SPC") 'nil)
;(global-set-key [C-return] 'kill-this-buffer);
;(global-set-key [(control f10)] 'kill-buffer-and-window);

;; Compilation
(setq compilation-scroll-output t)

;; Saving convention
; disable saving *scratch*
(add-hook 'emacs-startup-hook
          (lambda ()
            (when (get-buffer "*scratch*")
              (with-current-buffer "*scratch*"
                (setq auto-save-mode nil)
                ))))

; disable saving compile
(setq compilation-ask-about-save nil)
; disable saging *anything*
(setq compilation-save-buffers-predicate '(lambda () nil))

;; Backup and auto-save
(setq make-backup-files t)
(setq version-control t)
(setq kept-old-versions 2)
(setq kept-new-versions 5)
(setq delete-old-versions t)
(setq dired-kept-versions 1)
(setq backup-directory-alist '(("." . "~/.emacs.d/tmp")))
(setq backup-by-copying t)

(setq backup-enable-predicate
      (lambda (name)
        (and (normal-backup-enable-predicate name)
             (not
              (let ((method (file-remote-p name 'method)))
                (when (stringp method)
                  (member method '("su" "sudo"))))))))

(defvar autosave-dir
  (concat temporary-file-directory "/emacs_autosaves/"))
(make-directory autosave-dir t)

(setq auto-save-file-name-transforms
      `((".*" ,autosave-dir t)))


;; Timestamp
(setq time-stamp-active t)
(setq time-stamp-warn-inactive t)
(setq time-stamp-format "%:u %04y-%02m-%02d %02H:%02M:%02S")
(setq time-stamp-end: "\n")
(add-hook 'write-file-hooks 'time-stamp)

;; Spell check and syntax check
;(setq-default ispell-program-name "aspell")
(setq ispell-program-name "aspell"
  ispell-extra-args '("--sug-mode=ultra"))

;; easy spell check
(global-set-key (kbd "<f8>") 'ispell-word)
(global-set-key (kbd "C-S-<f8>") 'flyspell-mode)
(global-set-key (kbd "C-M-<f8>") 'flyspell-buffer)
(global-set-key (kbd "C-<f8>") 'flyspell-check-previous-highlighted-word)
(defun flyspell-check-next-highlighted-word ()
  "Custom function to spell check next highlighted word"
  (interactive)
  (flyspell-goto-next-error)
  (ispell-word)
  )
(global-set-key (kbd "M-<f8>") 'flyspell-check-next-highlighted-word)

(add-hook 'flyspell-mode-hook 'flyspell-buffer)


;; Shell
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(setq ansi-color-for-comint-mode t)

;; Misc
(setq visible-bell nil)
(setq inhibit-startup-message t)
(setq gnus-inhibit-startup-message t)
(setq uniquify-buffer-name-style 'forward)
(setq stack-trace-on-error t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq confirm-nonexistent-file-or-buffer nil)
(auto-image-file-mode t)

(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if (display-graphic-p)
  (progn
    ;; use 120 char wide window for largeish displays
    ;; and smaller 80 column windows for smaller displays
    ;; pick whatever numbers make sense for you
    (if (> (x-display-pixel-width) 1600)
           (add-to-list 'default-frame-alist (cons 'width 200))
           (add-to-list 'default-frame-alist (cons 'width 80)))
    ;; for the height, subtract a couple hundred pixels
    ;; from the screen height (for panels, menubars and
    ;; whatnot), then divide by the height of a char to
    ;; get the height we want
    (add-to-list 'default-frame-alist 
         (cons 'height (/ (- (x-display-pixel-height) 200)
                             (frame-char-height)))))))

(set-frame-size-according-to-resolution)


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-default-highlight-face ((t (:background "RoyalBlue4"))))
 '(ecb-tag-header-face ((t (:background "SkyBlue4"))))
 '(error ((t (:background "#400000" :foreground "pink" :weight bold))))
 '(font-latex-sectioning-5-face ((t (:inherit variable-pitch :foreground "khaki" :weight bold))))
 '(hl-line ((t (:background "#353535"))))
 '(speedbar-tag-face ((t (:foreground "goldenrod"))))
 '(warning ((t (:background "#401000" :foreground "orange" :weight bold)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; == General Settings of Extensions ==
;;
;(add-to-list 'load-path "~/.emacs.d/extensions")


;; tramp
(require 'tramp)
;(setq tramp-backup-directory-alist backup-directory-alist)
(setq backup-enable-predicate
      (lambda (name)
        (and (normal-backup-enable-predicate name)
             (not
              (let ((method (file-remote-p name 'method)))
                (when (stringp method)
                  (member method '("su" "sudo"))))))))
(setq tramp-auto-save-directory autosave-dir)

; Multiple hops settings
;(set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%h:"))))

; Connect killdevil directly by "/ssh:killdevil.unc.edu" or "/ssh:sphuang@killdevil.unc.edu"
; This will first go through the proxy sphuang@csbio-desktop121.cs.unc.edu via ssh.
(add-to-list 'tramp-default-proxies-alist
             '("killdevil\\.unc\\.edu" nil "/ssh:sphuang@csbio-desktop121.cs.unc.edu:"))

; Connect csbio-server010.cs.unc.edu by "/sudo:root@csbio-server010.cs.unc.edu" 
; This will first ssh to sphuang@csbio-server010.cs.unc.edu and then sudo -s -u root.
(add-to-list 'tramp-default-proxies-alist
             '("csbio-server010\\.cs\\.unc\\.edu" "\\`root\\'" "/ssh:sphuang@csbio-server010.cs.unc.edu:"))


;; ido
(require 'ido)
(ido-mode t)
(ido-everywhere 1)
(setq ido-enable-flex-matching t)
(setq ido-create-new-buffer 'always)
;(setq ido-enable-tramp-completion nil)
(setq ido-enable-last-directory-history nil)
(setq ido-confirm-unique-completion nil) ;; wait for RET, even for unique?
(setq ido-show-dot-for-dired t) ;; put . as the first item
(setq ido-use-filename-at-point t) ;; prefer file names near point
;(setq ido-auto-merge-work-directories-length -1)


;; undo-tree
(require 'undo-tree)
(global-undo-tree-mode)
;(add-hook 'undo-tree-visualizer-mode-hook 
;(lambda ()                
;        (local-set-key [return] 'kill-this-buffer)
;        ))


;; Flymake
;;(require 'flymake)
;;(setq flymake-start-syntax-check-on-find-file nil)

(require 'flymake-python-pyflakes)
(setq flymake-python-pyflakes-executable "~/.emacs.d/extensions/flymake/pycheckers")
(require 'flymake-php)

(setq flymake-no-changes-timeout 5)

(eval-after-load "flymake"
  '(progn
    (defun flymake-after-change-function (start stop len)
      "Start syntax check for current buffer if it isn't already running."
      ;; Do nothing, don't want to run checks until I save.
      )))      


; yasnippet
(require 'yasnippet)
(yas-global-mode 1)


;; magit
(require 'magit)


;; ECB
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-layout-name "left3")
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--C-mouse-1))
 '(ecb-tip-of-the-day nil)
 '(ecb-tree-buffer-style (quote ascii-guides))
 '(ecb-windows-width 0.15))
 
(ecb-activate)
(ecb-toggle-ecb-windows 1)
(ecb-toggle-compile-window -1)
(split-window-right)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; == Python ==
;;

(setq py-indent-offset 4)
(setq python-indent-guess-indent-offset nil)
(setq python-indent 12)

;; Compile function
(defun my-compile ()
  "Use compile to run python programs"
  (interactive)
  ;(ecb-toggle-compile-window t)
  ;(custom-set-variables
  ;'(ecb-compile-window-height 8))
  (compile (concat "python " (buffer-name))))
(global-set-key "\C-c\C-c" 'my-compile)

(add-hook 'python-mode-hook 
      (lambda () 
        (local-set-key "\C-c\C-c" 'my-compile)
        ))

;; Python auto-indent after return
(add-hook 'python-mode-hook 
  '(lambda()
     (local-set-key "\r"
       '(lambda()                      
          (interactive)
          (insert "\n")
          (python-indent-line)))))


;; auto-complete for python
(setq jedi:setup-keys t)
(add-hook 'python-mode-hook 'auto-complete-mode)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
(setq jedi:setup-keys t)
(setq jedi:tooltip-method nil)
(require 'jedi)

;; Flymake for python             
(add-hook 'python-mode-hook 'flymake-python-pyflakes-load)
(add-hook 'python-mode-hook 
   (lambda () 
        (unless (eq buffer-file-name nil) (flymake-mode 1)) ;dont invoke flymake on temporary buffers for the interpreter
        (local-set-key [f2] 'flymake-goto-prev-error)
        (local-set-key [f3] 'flymake-goto-next-error)
        ))
        
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; == PHP ==
;;

(require 'php-mode)

;; Compile function
(defun my-php-compile ()
  "Use compile to run php programs"
  (interactive)
  ;(ecb-toggle-compile-window t)
  ;(custom-set-variables
  ;'(ecb-compile-window-height 8))
  (compile (concat "php " (buffer-name))))
;(global-set-key "\C-c\C-c" 'my-compile)

(add-hook 'php-mode-hook 
  (lambda () 
  (local-set-key "\C-c\C-c" 'my-php-compile)
        ))

;; Flymake for php
(add-hook 'php-mode-hook 'flymake-php-load)
(add-hook 'php-mode-hook 
   (lambda () 
        (unless (eq buffer-file-name nil) (flymake-mode 1)) ;dont invoke flymake on temporary buffers for the interpreter
        (local-set-key [f2] 'flymake-goto-prev-error)
        (local-set-key [f3] 'flymake-goto-next-error)
        ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; == Latex ==
;;

(add-to-list 'load-path "~/.emacs.d/extensions/auctex-11.87/")
(add-to-list 'load-path "~/.emacs.d/extensions/auctex-11.87/preview")
;(add-to-list 'load-path "~/.emacs.d/elpa/auctex-11.86/")
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-PDF-mode t)
;(setq-default TeX-master nil) ; Query for master file.
(setq TeX-source-correlate-start-server t)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(defun turn-on-flyspell () (flyspell-mode 1))
(add-hook 'LaTeX-mode-hook 'turn-on-flyspell)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)

(defun guess-TeX-master (filename)
      "Guess the master file for FILENAME from currently open .tex files."
      (let ((candidate nil)
            (filename (file-name-nondirectory filename)))
        (save-excursion
          (dolist (buffer (buffer-list))
            (with-current-buffer buffer
              (let ((name (buffer-name))
                    (file buffer-file-name))
                (if (and file (string-match "\\.tex$" file))
                    (progn
                      (goto-char (point-min))
                      (if (re-search-forward (concat "\\\\input{" filename "}") nil t)
                          (setq candidate file))
                      (if (re-search-forward (concat "\\\\include{" (file-name-sans-extension filename) "}") nil t)
                          (setq candidate file))))))))
        (if candidate
            (message "TeX master document: %s" (file-name-nondirectory candidate)))
        candidate))

(add-hook 'LaTeX-mode-hook 
          '(lambda ()
             (setq TeX-master (guess-TeX-master (buffer-file-name)))
             ))

