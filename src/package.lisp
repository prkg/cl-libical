(in-package #:cl-user)

(defpackage #:cl-libical
  (:nicknames #:libical)
  (:use #:cl #:cffi)
  (:export #:icaltime-from-string
	   #:icaltime-as-ical-string
	   #:icalrecurrencetype-from-string
	   #:icalrecurrencetype-as-string
	   #:icalrecur-iterator-new
	   #:icalrecur-iterator-next
	   #:icalrecur-iterator-free
	   #:with-icalrecur-iterator))

(in-package #:cl-libical)

(define-foreign-library libical
  (t (:default "libical")))

(use-foreign-library libical)
