#n
/[[:blank:]]*<date>\(.*\)<\/date>[[:blank:]]*/ {
	s--\1-p
}
