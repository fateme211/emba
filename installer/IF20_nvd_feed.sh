#!/bin/bash

# EMBA - EMBEDDED LINUX ANALYZER
#
# Copyright 2020-2023 Siemens Energy AG
#
# EMBA comes with ABSOLUTELY NO WARRANTY. This is free software, and you are
# welcome to redistribute it under the terms of the GNU General Public License.
# See LICENSE file for usage of this software.
#
# EMBA is licensed under GPLv3
#
# Author(s): Michael Messner

# Description: Installs the NVD data feed for CVE identification in EMBA (F20)

IF20_nvd_feed() {
  module_title "${FUNCNAME[0]}"

  if [[ "${LIST_DEP}" -eq 1 ]] || [[ "${IN_DOCKER}" -eq 1 ]] || [[ "${DOCKER_SETUP}" -eq 1 ]] || [[ "${CVE_SEARCH}" -eq 1 ]] || [[ "${FULL}" -eq 1 ]]; then

    print_git_info "NVD JSON data feed" "EMBA-support-repos/nvd-json-data-feeds" "The NVD data feed is JSON database to facilitate search and processing of CVEs."

    if [[ "${LIST_DEP}" -eq 1 ]] || [[ "${IN_DOCKER}" -eq 1 ]] ; then
      ANSWER=("n")
    else
      echo -e "\\n""${MAGENTA}""${BOLD}""NVD JSON data feed will be downloaded, installed and populated!""${NC}"
      ANSWER=("y")
    fi

    case ${ANSWER:0:1} in
      y|Y )

        cd "${HOME_PATH}" || ( echo "Could not install EMBA component NVD JSON data feed" && exit 1 )

        echo -e "\\n""${MAGENTA}""Check if the NVD JSON data feed is already installed and populated.""${NC}"
        if [[ "${GH_ACTION}" -eq 1 ]]; then
          echo "[*] Github action - not installing NVD database"
          echo "GH_action:true" > ./config/gh_action || true
          return
        fi
        if [[ -d external/nvd-json-data-feeds ]]; then
          cd external/nvd-json-data-feeds || ( echo "Could not install EMBA component NVD JSON data feed" && exit 1 )
          git pull
          cd "${HOME_PATH}" || ( echo "Could not install EMBA component NVD JSON data feed" && exit 1 )
        else
          git clone --depth 1 -b main https://github.com/EMBA-support-repos/nvd-json-data-feeds.git external/nvd-json-data-feeds
        fi
        if [[ $(grep -l -E "cpe.*busybox:" external/nvd-json-data-feeds/* -r 2>/dev/null | wc -l) -gt 18 ]]; then
          echo -e "\\n""${GREEN}""NVD JSON data feed is already installed - no further action performed.""${NC}"
        else
          echo -e "\\n""${MAGENTA}""NVD JSON data feed is not ready.""${NC}"
        fi

        cd "${HOME_PATH}" || ( echo "Could not install EMBA component NVD JSON data feed" && exit 1 )
      ;;
    esac
  fi
}
