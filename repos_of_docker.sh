
#!/usr/bin/env bash
set -euo pipefail

echo "------------------------------------------"
echo "  Docker Hub Repository & Tags Viewer (Amazon Linux)"
echo "------------------------------------------"

# ====== jq install (if missing) ======
if ! command -v jq &> /dev/null; then
  echo "[INFO] jq not found. Installing via yum..."
  sudo yum install -y jq >/dev/null
fi

# ====== USERNAME selection ======
echo ""
echo "Select Docker Hub username:"
echo "  1) srinuas"
echo "  2) shaikmustafa"
echo "  3) Enter another username"
read -p "Enter choice (1/2/3): " USER_CHOICE

case "${USER_CHOICE}" in
  1) USERNAME="srinuas" ;;
  2) USERNAME="shaikmustafa" ;;
  3) read -p "Type your Docker Hub username: " USERNAME ;;
  *) echo "Invalid choice. Exiting."; exit 1 ;;
esac
export USERNAME

# ====== TOKEN (Personal Access Token / Password) ======
# NOTE: For 2FA-enabled accounts, use a Docker Hub Personal Access Token.
echo ""
read -s -p "Enter your Docker Hub Personal Access Token (input hidden): " TOKEN
echo ""
if [[ -z "${USERNAME:-}" || -z "${TOKEN:-}" ]]; then
  echo "ERROR: USERNAME/TOKEN సెటప్ కాలేదు. దయచేసి మళ్లీ రన్ చేయండి."
  exit 1
fi

# ====== Repo visibility choice ======
echo ""
echo "1) View ALL repositories (Public + Private)"
echo "2) View ONLY Private repositories"
echo "3) View ONLY Public repositories"
read -p "Enter choice (1/2/3): " CHOICE

API_URL="https://hub.docker.com/v2/repositories/${USERNAME}/?page_size=100"

echo ""
echo "Fetching repositories for user: ${USERNAME} ..."
echo ""

# --- Fetch all repos with pagination ---
REPOS_JSON="[]"
URL="$API_URL"
while [[ -n "${URL}" && "${URL}" != "null" ]]; do
  PAGE=$(curl -fsS -u "${USERNAME}:${TOKEN}" "${URL}" || true)
  if [[ -z "${PAGE}" ]]; then
    echo "ERROR: Repositories fetch కాలేదు. Network/credentials చెక్ చేయండి."
    exit 1
  fi

  # accumulate results
  PAGE_RESULTS=$(echo "${PAGE}" | jq '.results // []')
  REPOS_JSON=$(jq -s '.[0] + .[1]' <(echo "${REPOS_JSON}") <(echo "${PAGE_RESULTS}"))
  URL=$(echo "${PAGE}" | jq -r '.next // empty')
done

# filter based on choice
case "${CHOICE}" in
  1)
    FILTERED=$(echo "${REPOS_JSON}")
    TITLE="Your Repositories (All)"
    ;;
  2)
    FILTERED=$(echo "${REPOS_JSON}" | jq '[.[] | select(.is_private == true)]')
    TITLE="Your Private Repositories"
    ;;
  3)
    FILTERED=$(echo "${REPOS_JSON}" | jq '[.[] | select(.is_private != true)]')
    TITLE="Your Public Repositories"
    ;;
  *)
    echo "Invalid input!"; exit 1 ;;
esac

COUNT=$(echo "${FILTERED}" | jq 'length')
if [[ "${COUNT}" -eq 0 ]]; then
  echo "No repositories found for this selection."
  exit 0
fi

echo "${TITLE}:"
echo "--------------------------------------------"
# numbered list
echo "${FILTERED}" | jq -r 'to_entries[] | "\(.key+1)) \(.value.name)\t[private=\(.value.is_private)]"'

# ask user to pick repo
echo ""
read -p "పైన ఉన్న లిస్టులో నుండి ఒక Repo నంబర్ ఎంచుకోండి: " REPO_IDX

# validate
if ! [[ "${REPO_IDX}" =~ ^[0-9]+$ ]]; then
  echo "Invalid number."
  exit 1
fi
if (( REPO_IDX < 1 || REPO_IDX > COUNT )); then
  echo "Number out of range."
  exit 1
fi

# get repo name
REPO_NAME=$(echo "${FILTERED}" | jq -r ".[$((REPO_IDX-1))].name")
echo ""
echo "మీరు ఎంచుకున్న Repo: ${REPO_NAME}"
echo "Tags తెస్తున్నాం..."
echo ""

# --- Fetch tags for the selected repo (with pagination) ---
TAGS_URL="https://hub.docker.com/v2/repositories/${USERNAME}/${REPO_NAME}/tags/?page_size=100"
ALL_TAGS="[]"
while [[ -n "${TAGS_URL}" && "${TAGS_URL}" != "null" ]]; do
  TPAGE=$(curl -fsS -u "${USERNAME}:${TOKEN}" "${TAGS_URL}" || true)
  if [[ -z "${TPAGE}" ]]; then
    echo "ERROR: Tags fetch కాలేదు. Network/credentials చెక్ చేయండి."
    exit 1
  fi
  TRES=$(echo "${TPAGE}" | jq '.results // []')
  ALL_TAGS=$(jq -s '.[0] + .[1]' <(echo "${ALL_TAGS}") <(echo "${TRES}"))
  TAGS_URL=$(echo "${TPAGE}" | jq -r '.next // empty')
done

TCOUNT=$(echo "${ALL_TAGS}" | jq 'length')
if [[ "${TCOUNT}" -eq 0 ]]; then
  echo "ఈ repo లో ఏ tags లేవు."
  exit 0
fi

echo "Tags (మొత్తం: ${TCOUNT}):"
echo "--------------------------------------------"
# Print table-like output: name, digest(short), last_updated, sizeMB
echo "${ALL_TAGS}" | jq -r '
  .[] | {
    name: .name,
    digest: (
      ( .images | arrays | .[0]?.digest // .digest // "" )
      | sub("^sha256:";"") | .[0:12]
    ),
    last_updated: (.last_updated // ""),
    sizeMB: ( ( .full_size // 0 ) / 1024 / 1024 | floor )
  } | "\(.name)\t dig:\(.digest)\t updated:\(.last_updated)\t size:\(.sizeMB)MB"
'

echo ""
echo "Done!"

