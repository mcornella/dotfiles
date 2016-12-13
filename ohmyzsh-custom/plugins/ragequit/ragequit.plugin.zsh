fuck() {
	emulate -L zsh
	local action="$1"
	local process="$2"

	# Force kill if 'fuck off'
	local -a flags
	case $action in
		off) flags+=("-9") ;;
		you) : ;;
	esac

	local -A flip_table
	flip_table=(
		"a" "ɐ"    "b" "q"    "c" "ɔ"    "d" "p"    "e" "ǝ"    "f" "ɟ"    "g" "ƃ"
		"h" "ɥ"    "i" "ı"    "j" "ɾ"    "k" "ʞ"    "l" "|"    "m" "ɯ"    "n" "u"
		"o" "o"    "p" "d"    "q" "b"    "r" "ɹ"    "s" "s"    "t" "ʇ"    "u" "n"
		"v" "ʌ"    "w" "ʍ"    "x" "x"    "y" "ʎ"    "z" "z"    "A" "ɐ"    "B" "q"
		"C" "ɔ"    "D" "p"    "E" "ǝ"    "F" "ɟ"    "G" "ƃ"    "H" "ɥ"    "I" "ı"
		"J" "ɾ"    "K" "ʞ"    "L" "|"    "M" "ɯ"    "N" "u"    "O" "o"    "P" "d"
		"Q" "b"    "R" "ɹ"    "S" "s"    "T" "ʇ"    "U" "n"    "V" "ʌ"    "W" "ʍ"
		"X" "x"    "Y" "ʎ"    "Z" "z"    "," "'"    "'" ","    '"' ","    ";" "؛"
		"." "˙"    "(" ")"    "{" "}"    "[" "]"    "⁅" "⁆"    "<" ">"    "‿" "⁀"
		"_" "‾"    "?" "¿"    '!' "¡"    "∴" "∵"    "\r" "\n"  " " " "
	)

	local reversed_process flipped_process char
	# split into array and reverse it
	reversed_process=(${(s::Oa)process})
	# replace each character with its flipped version, unless there isn't one
	for char ($reversed_process); do
		flipped_process+=${flip_table[$char]:-$char}
	done

	# Kill the process and print the pertinent message
	if command killall $flags "$process" >/dev/null 2>&1; then
		cat <<-EOF

			 (╯°□°）╯︵$flipped_process

		EOF
	else
		cat <<-'EOF'

			 (；￣Д￣) . o O( It's not very effective... )

		EOF
	fi
}

_fuck() {
	local expl
	local curcontext="$curcontext" state line
	local -A opt_args

	_arguments -C ':who:(you off)' '*:process:->process'

	case $state in
	process)
		COMPREPLY=( $(\ps axc --no-headers | \grep -Ev ' ps$| grep$' \
			| \awk '{ print $5 }' | \sort -u | \grep -v "^[\-\(]" \
			| \grep -i "^$cur")
		)
		_values -s ' ' 'apps' $COMPREPLY
		;;
	esac
}

compdef _fuck fuck
