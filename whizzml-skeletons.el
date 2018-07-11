;;; whizzml-skeletons.el --- Skeletons for auto-insertion of metadata JSON

;; Copyright (c) 2017, 2018 BigML, Inc

;; Author: Jose Antonio Ortega Ruiz <jao@bigml.com>
;; Package-Requires: ((emacs "24.4"))
;; Version: 0.1
;; Keywords: languages, lisp


;; This file is not part of GNU Emacs.

;; whizzml-skeletons.el is free software: you can redistribute it
;; and/or modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation, either version 3 of
;; the License, or (at your option) any later version.

;; whizzml-mode is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <http://www.gnu.org/licenses/>.


;;; Commentary:
;;
;; This package provide skeloton definitions to auto-insert
;; boilerplate in metadata.json files accompanying the definition of
;; WhizzML scripts and libraries.  See https://bigml.com/whizzml for
;; more on WhizzML, a DSL for Machine Learning workflows.
;;
;; You can use either of the three defined skeletons as interactive
;; commands (with M-x):
;;
;;   - whizzml-library-skeleton
;;   - whizzml-script-skeleton
;;   - whizzml-package-skeleton
;;
;;  or you can also simply call `whizzml-skeletons-insert-skeleton',
;;  which will ask for the template to insert.
;;
;;  If you want emacs to automatically offer you the choice of
;;  skeleton insertion when creating a file named `metadata.json',
;;  just invoke `whizzml-skeletons-activate' in your .emacs:
;;
;;     require 'whizzml-skeletons) ;; needed only if you don't use ELPA
;;     (whizzml-skeletons-activate)
;;


;;; Code:


(require 'skeleton)
(require 'autoinsert)

(defun whizzml-skeletons-print-list (lst)
  (when (car lst) (insert "\"" (car lst) "\""))
  (dolist (l (cdr lst))
  (indent-according-to-mode)
  (insert ",\n\"" l "\""))
  (indent-according-to-mode))

(defun whizzml-skeletons-read-list (thing &optional acc)
  (let ((new (read-string (format "New %s (RET for no more): " thing))))
    (if (string-blank-p new)
        (whizzml-skeletons-print-list (reverse acc))
      (whizzml-skeletons-read-list thing (cons new acc)))))

(define-skeleton whizzml-parameter-skeleon
  "Skeleton for an input/output parameter"
  "Name: "
  "{" \n
  > "\"name\": \"" str "\"," \n
  > "\"type\": \"" (read-string "Type: ") "\"," \n
  > "\"description\": \"" (read-string "Description: ") "\"" \n
  "}" >)

(defun whizzml-skeletons-read-params (&optional prefix)
  (let ((name (read-string "New parameter name (RET for no more): ")))
    (when (not (string-blank-p name))
      (when prefix (insert ",\n"))
      (indent-according-to-mode)
      (whizzml-parameter-skeleon name)
      (whizzml-skeletons-read-params t))))

;;;###autoload
(define-skeleton whizzml-package-skeleton
  "Skeleton for a whizzml package definition"
  "Package name: "
  "{" \n
  > "\"name\": \"" str "\"," \n
  > "\"kind\": \"package\"," \n
  > "\"description\": \"" (read-string "Description: ") "\"," \n
  > "\"components\":[" \n > (whizzml-skeletons-read-list "component") "]" \n
  "}" >)

;;;###autoload
(define-skeleton whizzml-library-skeleton
  "Skeleton for a whizzmml library definition"
  "Libary name: "
  "{" \n
  > "\"name\": \"" str "\"," \n
  > "\"kind\": \"library\"," \n
  > "\"description\": \"" (read-string "Description: ") "\"," \n
  > "\"imports\":[" \n > (whizzml-skeletons-read-list "import") "]," \n
  > "\"source_code\": \"library.whizzml\"" \n
  "}" >)

;;;###autoload
(define-skeleton whizzml-script-skeleton
  "Skeleton for a whizzmml script definition"
  "Script name: "
  "{" \n
  > "\"name\": \"" str "\"," \n
  > "\"kind\": \"script\"," \n
  > "\"description\": \"" (read-string "Description: ") "\"," \n
  > "\"source_code\": \"script.whizzml\"," \n
  > "\"imports\":[" \n > (whizzml-skeletons-read-list "import") "]," \n
  > "\"inputs\":[" \n > (whizzml-skeletons-read-params) "]," \n
  > "\"outputs\":[" \n > (whizzml-skeletons-read-params) "]" \n
  "}" >)

;;;###autoload
(defun whizzml-skeletons-insert-skeleton ()
  "Choose one of the possible metadata types (library, script or
  package), and insert an skeleton for it."
  (interactive)
  (let ((k (completing-read "WhizzML resource: "
                            '("library" "script" "package")
                            nil
                            t
                            nil
                            'whizzml-skeletons--insert-history
                            "script")))
    (cond ((string= k "library") (whizzml-library-skeleton))
          ((string= k "script") (whizzml-script-skeleton))
          (t (whizzml-package-skeleton)))))

;;;###autoload
(defun whizzml-skeletons-activate ()
  "Calling this function will install the whizzml skeletons
  for candidates to auto-insertion in files named metadata.json"
  (interactive)
  (define-auto-insert '("metadata\.json$" . "WhizzML metadata")
    'whizzml-skeletons-insert-skeleton))


(provide 'whizzml-skeletons)
