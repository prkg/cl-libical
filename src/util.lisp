(in-package #:cl-libical)

(defcenum icalrecurrence_array_max_values
  (:recurrence_array_max 32639)
  (:recurrence_array_max_byte 127))

(defun foreign-array-to-lisp-vector (foreign-array type size)
  (let ((sentinel (foreign-enum-value 'icalrecurrence_array_max_values :recurrence_array_max))
	(lisp-vector (convert-from-foreign foreign-array `(:array ,type ,size))))
    (subseq lisp-vector 0 (position sentinel lisp-vector))))

(defun lisp-vector-to-foreign-array (lisp-vector foreign-array type size)
  (let ((sentinel (foreign-enum-value 'icalrecurrence_array_max_values :recurrence_array_max)))
    (loop for i from 0 below size do
      (setf (mem-aref foreign-array type i)
	    (if (< i (length lisp-vector))
		(aref lisp-vector i)
		sentinel)))))

(defun null-time-p (plist)
  (and (null-pointer-p (getf plist 'zone))
       (every #'zerop (mapcar (lambda (key) (getf plist key))
                              '(is_daylight is_date second minute
				hour day month year)))))
