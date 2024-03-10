(in-package #:cl-libical)

(defcstruct (%icaltimetype :class icaltimetype)
  (year :int)
  (month :int)
  (day :int)
  (hour :int)
  (minute :int)
  (second :int)
  (is_date :int)
  (is_daylight :int)
  (zone :pointer))

(defcfun ("icaltime_from_string" %icaltime-from-string)
    (:struct %icaltimetype)
  (str :string))

(defcfun ("icaltime_as_ical_string" %icaltime-as-ical-string)
    (:pointer :char)
  (recur (:struct %icaltimetype)))

(defun icaltime-from-string (str)
  (let ((icaltime (%icaltime-from-string str)))
    (unless (null-time-p icaltime)
      icaltime)))

(defun icaltime-as-ical-string (icaltime)
  (when icaltime
    (foreign-string-to-lisp (%icaltime-as-ical-string icaltime))))
