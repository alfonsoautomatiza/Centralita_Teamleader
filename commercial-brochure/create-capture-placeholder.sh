#!/usr/bin/env bash
set -eu
[ "$#" -ge 2 ] && [ "$#" -le 4 ] || { printf '%s\n' "Usage: $0 CAP-NN instruction [width] [height]" >&2; exit 2; }
id=$1; instruction=$2; width=${3:-1600}; height=${4:-900}
case "$id" in CAP-[0-9][0-9]) ;; *) printf '%s\n' "ERROR: use CAP-NN." >&2; exit 2;; esac
case "$width:$height" in *[!0-9:]*|:*|*:) exit 2;; esac
[ "$width" -gt 0 ] && [ "$height" -gt 0 ] || exit 2
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd); mkdir -p "$root/captures"; out="$root/captures/$id.svg"
[ ! -e "$out" ] || { printf 'ERROR: refusing to overwrite %s.\n' "$out" >&2; exit 1; }
escaped=$(printf '%s' "$instruction" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
cat >"$out" <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="$width" height="$height" viewBox="0 0 $width $height" role="img" aria-labelledby="title desc">
  <title id="title">$id capture placeholder</title><desc id="desc">$escaped</desc>
  <rect width="100%" height="100%" fill="#eef2f5"/><rect x="24" y="24" width="$(($width - 48))" height="$(($height - 48))" rx="16" fill="none" stroke="#567086" stroke-width="4" stroke-dasharray="16 12"/>
  <text x="50%" y="46%" text-anchor="middle" fill="#17324d" font-family="Arial, sans-serif" font-size="64" font-weight="700">$id</text>
  <text x="50%" y="56%" text-anchor="middle" fill="#425b70" font-family="Arial, sans-serif" font-size="28">$escaped</text>
</svg>
EOF
[ -s "$out" ] && printf 'Created: %s\n' "$out"
