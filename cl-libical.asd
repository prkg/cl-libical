(defsystem "cl-libical"
  :version "0.0.1"
  :description "Common Lisp bindings for libical"
  :author "prkg"
  :license "MIT"
  :depends-on (:cffi :cffi-libffi)
  :serial t
  :pathname "src"
  :components ((:file "package")
	       (:file "util")
	       (:file "icaltime")
	       (:file "icalrecur"))
  :in-order-to ((test-op (test-op "cl-libical/tests"))))

(defsystem "cl-libical/tests"
  :description "Test cl-libical"
  :author "prkg"
  :license "MIT"
  :depends-on (:cl-libical)
  :pathname "tests"
  :components ((:file "main"))
  :perform (test-op (o c) (symbol-call :cl-libical-tests 'test-suite)))
