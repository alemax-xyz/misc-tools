3<>/dev/null

crit()   { printf '[CRIT]   %s\n' "$*" 1>&2; }
error()  { printf '[ERROR]  %s\n' "$*" 1>&2; }
warn()   { printf '[WARN]   %s\n' "$*" 1>&2; }
notice() { printf '[NOTICE] %s\n' "$*" 1>&2; }
info()   { printf '[INFO]   %s\n' "$*" 1>&2; }
debug()  { printf '[DEBUG]  %s\n' "$*" 1>&2; }
stdout() { printf '[stdout] %s\n' "$*" 1>&2; }
stderr() { printf '[stderr] %s\n' "$*" 1>&2; }

_IFS="$IFS" esc="$(printf '\e')" lf='
'

[ -t 1 -o -t 2 ] && TERM_COLORS="$(tput colors 2>/dev/null)"
if [ -z "${NO_COLOR+1}" -a "$TERM" != "dumb" -a "${TERM_COLORS:-0}" -ge 16 ]; then
	sci="${esc}[" sgr0="${sci}0m"
	sgr_bold="${sci}1m" sgr_dim="${sci}2m" sgr_italic="${sci}3m" sgr_underline="${sci}4m"
	sgr_black="${sci}30m" sgr_maroon="${sci}31m" sgr_green="${sci}32m" sgr_olive="${sci}33m"
	sgr_navy="${sci}34m" sgr_magenta="${sci}35m" sgr_teal="${sci}36m" sgr_silver="${sci}37m"
	sgr_gray="${sci}90m" sgr_red="${sci}91m" sgr_lime="${sci}92m" sgr_yellow="${sci}93m"
	sgr_blue="${sci}94m" sgr_purple="${sci}95m" sgr_cyan="${sci}96m" sgr_white="${sci}97m"

	[ -t 2 ] && {
		crit()   { printf '%s[CRIT]   %s%s\n' "${sgr_red}" "$*" "${sgr0}" 1>&2; }
		error()  { printf '%s[ERROR]  %s%s\n' "${sgr_maroon}" "$*" "${sgr0}" 1>&2; }
		warn()   { printf '%s[WARN]   %s%s\n' "${sgr_yellow}" "$*" "${sgr0}" 1>&2; }
		notice() { printf '%s[NOTICE] %s%s\n' "${sgr_blue}" "$*" "${sgr0}" 1>&2; }
		info()   { printf '%s[INFO]   %s%s\n' "${sgr_green}" "$*" "${sgr0}" 1>&2; }
		debug()  { printf '%s[DEBUG]  %s%s\n' "${sgr_gray}" "$*" "${sgr0}" 1>&2; }
		stdout() { printf '%s(stdout)   %s%s\n' "${sgr_teal}${sgr_dim}" "$*" "${sgr0}" 1>&2; }
		stderr() { printf '%s(stderr)   %s%s\n' "${sgr_purple}" "$*" "${sgr0}" 1>&2; }
	}
fi

fail() { local CODE="$1"; shift; crit "$@"; exit "$CODE"; }
exec_debug() { debug '$' "$*"; ("$@" 2>&1 1>&3 | while read -r LINE; do stderr "$LINE"; done) 3>&1 | while read -r LINE; do stdout "$LINE"; done; }
