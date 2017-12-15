# AC_MAKE_ABSOLUTE(VAR, [PATH])
# ------------------------------
# If VAR is not already an absolute path, search for it in PATH
# (default $PATH) and make VAR absolute.

AC_DEFUN([AC_MAKE_ABSOLUTE],
[case $$1 in
  (/*) ;;
  (*) AC_PATH_PROG($1, $$1, $2) ;;
esac])
