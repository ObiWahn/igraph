# Creates a ctags-compatible tags file from a set of XML files by extracting
# the IDs found in the XML files.
#
# Parameters of the script:
#
# - INPUT_FILES: list of input files to process, with absolute pathnames
# - OUTPUT_FILE: the output file to write the tags into

string(REPLACE " " ";" INPUT_FILE_LIST "${INPUT_FILES}")

set(EXTRACTED_IDS "")

foreach(INPUT_FILE ${INPUT_FILE_LIST})
  file(READ "${INPUT_FILE}" CONTENTS)

  # Replace newlines with semicolons. This is a hack and we should escape
  # semicolons first if we wanted to do this properly; however, here we are
  # only interested in XML IDs and they don't have semicolons
  string(REPLACE "\n" ";" LINES "${CONTENTS}")
  foreach(_line ${LINES})
    string(REGEX MATCHALL "id=\"[^-\"]*\"" MATCH_RESULT "${_line}")
    if(MATCH_RESULT)
      foreach(MATCH ${MATCH_RESULT})
        string(REGEX REPLACE "id=\"(.*)\"" "\\1" EXTRACTED_ID "${MATCH}")
        list(APPEND EXTRACTED_IDS "${EXTRACTED_ID}")
      endforeach()
    endif()
  endforeach()
endforeach()

list(SORT EXTRACTED_IDS)
string(REPLACE ";" "\t\t\n" TAGS_OUTPUT "${EXTRACTED_IDS}")
string(APPEND TAGS_OUTPUT "\t\t\n")
file(WRITE "${OUTPUT_FILE}" "${TAGS_OUTPUT}")
