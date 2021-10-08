;; Put this file in ~/ or make a link
;; Also make a link of .emacs.d in ~/

;; Some env variables
(defvar user-name (getenv "USER"))

;; grep the slime version
(setq grep-slime-version 
      (concat
       "slimever=`ls /opt/ | grep \"slime\" "
       "| awk -F'-' '{print $2}'`\n"
       "echo $slimever\n"))

;; get the slime version
(defvar slime-folder-name
  (concat "slime-" 
	  (substring
	   (shell-command-to-string 
	    (format "bash -c %s" 
		    (shell-quote-argument 
		     grep-slime-version))) 
	   0 -1)))

;; slime settings by ramgorur
;; get the slime folder name
(defvar slime-folder 
  (concat "/opt/" slime-folder-name "/"))
(defvar sbcl-bin "/usr/local/bin/sbcl")

;; Now load them
(if (and (file-exists-p slime-folder) 
	 (file-exists-p sbcl-bin))
    (progn
      ;; some debug messages
      (message "*** Loading slime from: %s" 
	       slime-folder)
      (add-to-list 'load-path slime-folder) ;; your SLIME directory
      (setq inferior-lisp-program sbcl-bin) ;; your Lisp system
      (require 'slime)
      (slime-setup '(slime-fancy)))
  (message "*** Error loading slime: \'%s\' not found !!" 
	   slime-folder))

;; color theme settings, by ramgorur
;; see the color-theme.el file for a list of themes
;; better dark themes are like --
;; color-theme-hober
;; color-theme-midnight etc
(defvar color-theme-file 
  "/usr/share/emacs24/site-lisp/emacs-goodies-el/color-theme.el")
(defvar color-themes-folder
  (concat "/home/" user-name "/.emacs.d/color-themes"))
;; Now load them
  (if (and 
       (file-exists-p color-theme-file)
       (file-exists-p color-themes-folder))
      (progn
	;; some debug messages
	(message "*** Loading color themes from:")
	(message "*** \t\t%s\n*** \t\t%s" 
		 color-theme-file
		 color-themes-folder)
	(add-to-list 'load-path color-theme-file)
	(add-to-list 'load-path color-themes-folder)
	(require 'color-theme)
	(require 'zenburn)
	(eval-after-load "color-theme"
	  '(progn
	     (color-theme-initialize)
	     (color-theme-zenburn))))
    (progn
      (message "*** Error loading color themes !!")
      (message "*** Error locating these files:")
      (message "\t\t%s\n\t\t%s" 
	       color-theme-file
	       color-themes-folder)))
;;
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  ;;
  ;; this is done by ramgorur to move the scrollbar to right
 (custom-set-variables
  '(scroll-bar-mode (quote right))))
;;
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;; This is for default c indentation style
(setq c-default-style "bsd")

;; Set custom fonts, I am currently using Luculent 
;; http://eastfarthing.com/luculent/
(set-default-font "Luculent 11")

;; auto reload all buffers when the file contents are changed
(global-auto-revert-mode t)
