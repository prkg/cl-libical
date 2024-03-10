(in-package #:cl-libical)

(defcenum icalrecurrencetype_frequency
  (:secondly_recurrence 0)
  (:minutely_recurrence 1)
  (:hourly_recurrence 2)
  (:daily_recurrence 3)
  (:weekly_recurrence 4)
  (:monthly_recurrence 5)
  (:yearly_recurrence 6)
  (:no_recurrence 7))

(defcenum icalrecurrencetype_weekday
  (:no_weekday 0)
  (:sunday_weekday 1)
  (:monday_weekday 2)
  (:tuesday_weekday 3)
  (:wednesday_weekday 4)
  (:thursday_weekday 5)
  (:friday_weekday 6)
  (:saturday_weekday 7))

(defcenum icalrecurrencetype_skip
  (:skip_backward 0)
  (:skip_forward 1)
  (:skip_omit 2)
  (:skip_undefined 3))

(defcstruct (%icalrecurrencetype :class icalrecurrencetype)
  (freq icalrecurrencetype_frequency)
  (until (:struct %icaltimetype))
  (count :int)
  (interval :short)
  (week_start icalrecurrencetype_weekday)
  (by_second :short :count 62)
  (by_minute :short :count 61)
  (by_hour :short :count 25)
  (by_day :short :count 386)
  (by_month_day :short :count 32)
  (by_year_day :short :count 386)
  (by_week_no :short :count 56)
  (by_month :short :count 14)
  (by_set_pos :short :count 386)
  (rscale (:pointer :char))
  (skip icalrecurrencetype_skip))

(defmethod translate-from-foreign (pointer (type icalrecurrencetype))
  (with-foreign-slots ((freq until count interval week_start by_second by_minute by_hour by_day by_month_day by_year_day by_week_no by_month by_set_pos rscale skip) pointer (:struct %icalrecurrencetype))
    `( freq ,freq
       until ,until
       count ,count
       interval ,interval
       week_start ,week_start
       by_second ,(foreign-array-to-lisp-vector by_second :short 62)
       by_minute ,(foreign-array-to-lisp-vector by_minute :short 61)
       by_hour ,(foreign-array-to-lisp-vector by_hour :short 25)
       by_day ,(foreign-array-to-lisp-vector by_day :short 386)
       by_month_day ,(foreign-array-to-lisp-vector by_month_day :short 32)
       by_year_day ,(foreign-array-to-lisp-vector by_year_day :short 386)
       by_week_no ,(foreign-array-to-lisp-vector by_week_no :short 56)
       by_month ,(foreign-array-to-lisp-vector by_month :short 14)
       by_set_pos ,(foreign-array-to-lisp-vector by_set_pos :short 386)
       rscale ,rscale
       skip ,skip
       )))

(defmethod translate-into-foreign-memory (object (type icalrecurrencetype) pointer)
  (with-foreign-slots ((freq until count interval week_start by_second by_minute by_hour by_day by_month_day by_year_day by_week_no by_month by_set_pos rscale skip) pointer (:struct %icalrecurrencetype))
    (setf freq (getf object 'freq))
    (setf until (convert-to-foreign (getf object 'until) '(:struct %icaltimetype)))
    (setf count (getf object 'count))
    (setf interval (getf object 'interval))
    (setf week_start (getf object 'week_start))
    (lisp-vector-to-foreign-array (getf object 'by_second) by_second :short 62)
    (lisp-vector-to-foreign-array (getf object 'by_minute) by_minute :short 61)
    (lisp-vector-to-foreign-array (getf object 'by_hour) by_hour :short 25)
    (lisp-vector-to-foreign-array (getf object 'by_day) by_day :short 386)
    (lisp-vector-to-foreign-array (getf object 'by_month_day) by_month_day :short 32)
    (lisp-vector-to-foreign-array (getf object 'by_year_day) by_year_day :short 386)
    (lisp-vector-to-foreign-array (getf object 'by_week_no) by_week_no :short 56)
    (lisp-vector-to-foreign-array (getf object 'by_month) by_month :short 14)
    (lisp-vector-to-foreign-array (getf object 'by_set_pos) by_set_pos :short 386)
    (setf rscale (getf object 'rscale))
    (setf skip (getf object 'skip))))

(defcfun ("icalrecurrencetype_from_string" icalrecurrencetype-from-string)
    (:struct %icalrecurrencetype)
  (str :string))

(defcfun ("icalrecurrencetype_as_string" %icalrecurrencetype-as-string)
    (:pointer :char)
  (recur (:pointer (:struct %icalrecurrencetype))))

(defcfun ("icalrecur_iterator_new" icalrecur-iterator-new)
    (:pointer)
  (rule (:struct %icalrecurrencetype))
  (dtstart (:struct %icaltimetype)))

(defcfun ("icalrecur_iterator_next" icalrecur-iterator-next)
    (:struct %icaltimetype)
  (icalrecur_iterator :pointer))

(defcfun ("icalrecur_iterator_free" icalrecur-iterator-free)
    :void
  (icalrecur_iterator :pointer))

(defun icalrecurrencetype-as-string (rule)
  (with-foreign-object (ptr '(:struct %icalrecurrencetype))
    (setf (mem-aref ptr '(:struct %icalrecurrencetype)) rule)
    (foreign-string-to-lisp (%icalrecurrencetype-as-string ptr))))

(defmacro with-icalrecur-iterator ((next rule dtstart) &body body)
  (let ((rule-var (gensym "RULE"))
	(dtstart-var (gensym "DTSTART"))
	(iter-var (gensym "ITER"))
	(next-var (gensym "NEXT")))
    `(let* ((,rule-var (icalrecurrencetype-from-string ,rule))
	    (,dtstart-var (icaltime-from-string ,dtstart))
	    (,iter-var (icalrecur-iterator-new ,rule-var ,dtstart-var)))
       (labels ((,next ()
		  (let ((,next-var (icalrecur-iterator-next ,iter-var)))
		    (unless (null-time-p ,next-var)
		      ,next-var))))
	 (unwind-protect
	      (progn ,@body)
	   (icalrecur-iterator-free ,iter-var))))))
