#n
/[[:blank:]]*<version>\(.*\)<\/version>[[:blank:]]*/ {
	s--\1-p
}
