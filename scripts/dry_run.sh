#!/bin/bash
# Check what would happen if the ansible provision script was run.
#
# To run on a single plc, e.g. a bsd test plc:
#
#   $ ./dry_run.sh plc-tst-bsd1
#
# To run on a group of plcs, e.g. all of the tst plcs:
#
#   $ ./dry_run.sh tst_all
#
# Groups are defined in the inventory file.
if [ -z "${1}" ]; then
  echo "Ansible target required"
  exit 1
fi

TARGET="${1}"
shift

THIS_SCRIPT="$(realpath "${0}")"
THIS_DIR="$(dirname "${THIS_SCRIPT}")"

# Register the ssh key with the ssh agent if needed.
source "${THIS_DIR}/ssh_agent_helper.sh"

echo "Running provision_plc.sh in dry-run mode (--check, --diff)"
"${THIS_DIR}"/provision_plc.sh "${TARGET}" --check --diff "$@"

# TODO stop the ssh agent if we started it here
