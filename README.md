# cl-libical
Common Lisp bindings for [libical](https://github.com/libical/libical), an implementation of iCalendar protocols and data formats.

Requires `libical` and `libffi`. Tested with SBCL and libical-3.0.17.
    
## Usage 

Bindings are currently limited to RFC 5545 recurrence rules and time functions, see `src/package.lisp` for a full list of exported functions.

```lisp
;; Monthly on the second Monday at 8:30 AM
(let ((rule "FREQ=MONTHLY;BYDAY=2MO;BYHOUR=8;BYMINUTE=30")
      (dtstart "20240208T100000"))
  (with-icalrecur-iterator (next rule dtstart)
    (dotimes (n 4)
      (print (icaltime-as-ical-string (next))))))
```

```
"20240212T083000" 
"20240311T083000" 
"20240408T083000" 
"20240513T083000" 
```

## Installation

Not currently available in quicklisp or other package repositories. Clone the repository to your ASDF source registry.

For nix users, there is an SBCL overlay provided. See [example/flake.nix](example/flake.nix).
