#!/usr/bin/env bash
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$root"
source_md="BROCHURE.md"
word_html="BROCHURE_WORD.html"
capture_plan="CAPTURE_PLAN.md"

for required in "$source_md" "$word_html" "$capture_plan" "CLAIMS_LEDGER.md" "captures/README.md"; do
  [ -s "$required" ] || { printf 'ERROR: %s/%s is missing or empty.\n' "$root" "$required" >&2; exit 1; }
done

image_refs=$(grep -oE '\]\(captures/[^)#?[:space:]]+\)' "$source_md" | sed 's/^](//; s/)$//' | sort -u)
[ -n "$image_refs" ] || { printf '%s\n' "ERROR: BROCHURE.md must reference captures/." >&2; exit 1; }
planned_ids=$(grep -oE 'CAP-[0-9]+' "$capture_plan" | sort -u)

while IFS= read -r id; do
  printf '%s\n' "$image_refs" | grep -Eq "captures/$id\\.(svg|png|jpg|jpeg)$" || { printf 'ERROR: planned %s is not referenced.\n' "$id" >&2; exit 1; }
  grep -Fq "$id" "captures/README.md" || { printf 'ERROR: %s missing from captures/README.md.\n' "$id" >&2; exit 1; }
done <<EOF
$planned_ids
EOF

status="final"
while IFS= read -r image; do
  [ -s "$image" ] || { printf 'ERROR: missing capture: %s/%s\n' "$root" "$image" >&2; exit 1; }
  grep -Fq "$image" "$word_html" || { printf 'ERROR: HTML does not reference %s.\n' "$image" >&2; exit 1; }
  case "$image" in
    *.svg) grep -Eq '<svg([[:space:]]|>)' "$image" || { printf 'ERROR: invalid SVG: %s\n' "$image" >&2; exit 1; }; status="draft" ;;
    *.png) [ "$(od -An -tx1 -N8 "$image" | tr -d ' \n')" = "89504e470d0a1a0a" ] || exit 1 ;;
    *.jpg|*.jpeg) [ "$(od -An -tx1 -N3 "$image" | tr -d ' \n')" = "ffd8ff" ] || exit 1 ;;
    *) printf 'ERROR: unsupported capture: %s\n' "$image" >&2; exit 1 ;;
  esac
done <<EOF
$image_refs
EOF

if [ "$status" = draft ]; then
  docx="BROCHURE_DRAFT.docx"; pdf="BROCHURE_DRAFT.pdf"
  [ ! -e BROCHURE.docx ] && [ ! -e BROCHURE.pdf ] || { printf '%s\n' "ERROR: final-named output exists while placeholders remain." >&2; exit 1; }
  printf '%s\n' "Capture status: DRAFT (SVG placeholders remain)."
else
  docx="BROCHURE.docx"; pdf="BROCHURE.pdf"
  printf '%s\n' "Capture status: FINAL."
fi

has_pandoc=false; has_rsvg=false; has_libreoffice=false; libreoffice_cmd=""
command -v pandoc >/dev/null 2>&1 && has_pandoc=true
command -v rsvg-convert >/dev/null 2>&1 && has_rsvg=true
if command -v libreoffice >/dev/null 2>&1; then has_libreoffice=true; libreoffice_cmd=libreoffice; elif command -v soffice >/dev/null 2>&1; then has_libreoffice=true; libreoffice_cmd=soffice; fi
printf 'Pandoc: %s\nrsvg-convert: %s\nLibreOffice/soffice: %s\n' "$has_pandoc" "$has_rsvg" "$has_libreoffice"

if [ "$has_pandoc" = true ]; then
  [ "$status" != draft ] || [ "$has_rsvg" = true ] || { printf '%s\n' "ERROR: rsvg-convert is required for SVG-backed DOCX." >&2; exit 1; }
  [ ! -e "$docx" ] || { printf 'ERROR: refusing to overwrite %s.\n' "$docx" >&2; exit 1; }
  log=$(mktemp "${TMPDIR:-/tmp}/brochure-pandoc.XXXXXX")
  trap 'rm -f "$log"' EXIT HUP INT TERM
  pandoc "$source_md" --standalone --from=gfm --to=docx --output="$docx" 2>"$log" || { [ ! -s "$log" ] || cat "$log" >&2; rm -f "$docx"; exit 1; }
  if grep -Eiq '(warning|could not|cannot|failed).*(image|resource|svg|png|jpe?g)|(image|resource|svg|png|jpe?g).*(warning|could not|cannot|failed)' "$log"; then cat "$log" >&2; rm -f "$docx"; exit 1; fi
  [ -s "$docx" ] || { printf 'ERROR: %s is empty.\n' "$docx" >&2; exit 1; }
  rm -f "$log"; trap - EXIT HUP INT TERM
  printf 'Created: %s/%s\n' "$root" "$docx"
else
  printf '%s\n' "Pandoc unavailable; use BROCHURE_WORD.html in Word and Save As DOCX."
fi

if [ "$has_libreoffice" = true ]; then
  [ ! -e "$pdf" ] || { printf 'ERROR: refusing to overwrite %s.\n' "$pdf" >&2; exit 1; }
  input="$word_html"; [ -s "$docx" ] && input="$docx"
  temp=$(mktemp -d "${TMPDIR:-/tmp}/brochure.XXXXXX")
  trap 'rm -rf "$temp"' EXIT HUP INT TERM
  "$libreoffice_cmd" --headless --convert-to pdf --outdir "$temp" "$input" >/dev/null
  generated="$temp/${input%.*}.pdf"; [ -s "$generated" ] || { printf '%s\n' "ERROR: PDF export failed." >&2; exit 1; }
  cp "$generated" "$pdf"; [ -s "$pdf" ] || exit 1
  printf 'Created: %s/%s\n' "$root" "$pdf"
else
  printf '%s\n' "LibreOffice is unavailable; PDF was not exported. Open $docx or $word_html in Word and export as PDF."
fi

printf '%s\n' "Visual QA is still required before publishing."
