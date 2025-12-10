#!/usr/bin/env bash
set -euo pipefail

# Download core dictionary assets into data/raw/<source>/.
# Large corpora are provided as commented stubs; uncomment if needed.
# Requirements: curl, tar, unzip, and ~10GB free space for core assets.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_DIR="${ROOT}/data/raw"

mkdir -p "${DATA_DIR}"

download() {
  # Usage: download <url> <output_path>
  local url="$1"
  local output="$2"
  local tmp="${output}.part"
  mkdir -p "$(dirname "${output}")"
  if [ -s "${output}" ]; then
    echo "✔ Already downloaded: ${output}"
    return 0
  fi
  echo "↓ Fetching ${url}"
  curl -L --fail --retry 3 --retry-delay 2 --continue-at - \
    -o "${tmp}" "${url}"
  mv "${tmp}" "${output}"
  echo "✔ Saved to ${output}"
}

echo "Downloading core dictionary datasets into ${DATA_DIR}"

# ---------------------------------------------------------------------------
# Kaikki.org Wiktionary (Ru -> En definitions, JSONL)
# ---------------------------------------------------------------------------
download "https://kaikki.org/dictionary/Russian/kaikki.org-dictionary-Russian.jsonl" \
  "${DATA_DIR}/kaikki/kaikki.org-dictionary-Russian.jsonl"

# ---------------------------------------------------------------------------
# OpenCorpora morphology (XML, CC BY-SA 3.0)
# ---------------------------------------------------------------------------
download "http://opencorpora.org/files/export/dict/dict.opcorpora.xml.bz2" \
  "${DATA_DIR}/opencorpora/dict.opcorpora.xml.bz2"

# ---------------------------------------------------------------------------
# V.K. Muller (Mueller7 GPL Ru-En)
# Note: SourceForge may redirect; curl follows via -L.
# ---------------------------------------------------------------------------
download "https://downloads.sourceforge.net/project/mueller-dict/mueller-dict/2.4.2/stardict-mueller7accentgpl-2.4.2.tar.bz2" \
  "${DATA_DIR}/mueller/stardict-mueller7accentgpl-2.4.2.tar.bz2"

# ---------------------------------------------------------------------------
# Dal & Ushakov DSL bundles (historical + Soviet strata)
# The mail.ru link contains DSL archives referenced in research notes.
# ---------------------------------------------------------------------------
download "https://cloud.mail.ru/public/QeAV/ei7xfEPGi" \
  "${DATA_DIR}/dal_ushakov/dal_ushakov_bundle.zip"

# Ushakov alternate mirror (Google Drive StarDict)
download "https://docs.google.com/uc?id=1WFbt3PsmwyOn6ccy-H6mmZt6fTreX9gq&export=download" \
  "${DATA_DIR}/ushakov/ushakov_stardict.zip"

# ---------------------------------------------------------------------------
# Zalizniak 2010 (gramdict, paradigms) - CC BY-NC
# ---------------------------------------------------------------------------
download "https://github.com/gramdict/zalizniak-2010/archive/refs/heads/master.zip" \
  "${DATA_DIR}/zalizniak/zalizniak-2010-master.zip"

# ---------------------------------------------------------------------------
# Lurkmore XML dump (slang/subculture, CC BY-SA)
# ---------------------------------------------------------------------------
download "https://archive.org/download/wiki-lurkmorewtf/wiki-lurkmorewtf_wiki.tar.gz" \
  "${DATA_DIR}/lurkmore/wiki-lurkmorewtf_wiki.tar.gz"


# ---------------------------------------------------------------------------
# OPTIONAL
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Teenslang (youth slang) - link not provided in research; placeholder for future.
# ---------------------------------------------------------------------------
# download "<TEENSLANG_DOWNLOAD_URL>" "${DATA_DIR}/teenslang/teenslang_dataset.zip"

# ---------------------------------------------------------------------------
# OpenRussian paradigms + stress (CSV, CC BY-SA 4.0)
# ---------------------------------------------------------------------------
# download "https://raw.githubusercontent.com/Badestrand/russian-dictionary/master/nouns.csv" \
#   "${DATA_DIR}/openrussian/nouns.csv"
# download "https://raw.githubusercontent.com/Badestrand/russian-dictionary/master/verbs.csv" \
#   "${DATA_DIR}/openrussian/verbs.csv"
# download "https://raw.githubusercontent.com/Badestrand/russian-dictionary/master/adjectives.csv" \
#   "${DATA_DIR}/openrussian/adjectives.csv"

# ---------------------------------------------------------------------------
# Tatoeba (Ru sentences with translations, CC BY 2.0) - curated examples
# ---------------------------------------------------------------------------
# download "https://downloads.tatoeba.org/exports/sentences.tar.bz2" \
#  "${DATA_DIR}/tatoeba/sentences.tar.bz2"
# download "https://downloads.tatoeba.org/exports/links.tar.bz2" \
#  "${DATA_DIR}/tatoeba/links.tar.bz2"


# ---------------------------------------------------------------------------
# OpenSubtitles sample (monolingual RU; full corpus is huge)
# ---------------------------------------------------------------------------
# download "https://object.pouta.csc.fi/OPUS-OpenSubtitles/v2018/mono/ru.txt.gz" \
#   "${DATA_DIR}/opensubtitles/ru.txt.gz"

# ---------------------------------------------------------------------------
# OPTIONAL - Giant Files
# Uncomment if you truly need full-scale corpora (tens to hundreds of GB).
# ---------------------------------------------------------------------------

# Full OpenSubtitles (20B+ sentence pairs, OPUS)
# download "https://opus.nlpl.eu/download.php?f=OpenSubtitles/en-ru.txt.zip" \
#   "${DATA_DIR}/opensubtitles/open_subtitles_en_ru.txt.zip"

# KDE4 localization corpus (OPUS)
# download "https://object.pouta.csc.fi/OPUS-KDE4/v2/mono/ru.txt.gz" \
#   "${DATA_DIR}/kde4/ru.txt.gz"

# GNOME localization corpus (OPUS)
# download "https://object.pouta.csc.fi/OPUS-GNOME/v1/mono/ru.txt.gz" \
#   "${DATA_DIR}/gnome/ru.txt.gz"

# natasha/corus aggregated corpora (launcher repo only; actual data sizable)
# download "https://github.com/natasha/corus/archive/refs/heads/master.zip" \
#   "${DATA_DIR}/corus/corus-master.zip"

echo "Done. Core downloads are in ${DATA_DIR}."

