;;
;; Most of this init.el file is an adaptation of Daniel Mai's configuration file
;; https://github.com/danielmai/.Emacs.d/blob/master/init.el
;;

(setq gc-cons-threshold 400000000)

(menu-bar-mode -1)

(when window-system
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1))

(setq inhibit-startup-message t)

;; Set up package
(require 'package)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        )
      )
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;
;; MORE CUSTOMIZATIONS
;;
;;
(setq custom-file (expand-file-name "inits/custom.el" user-emacs-directory))
(load custom-file)

;; Load the config
(org-babel-load-file (expand-file-name "inits/repp.org" user-emacs-directory))

(setq gc-cons-threshold 800000)
