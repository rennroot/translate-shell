####################################################################
# Script.awk                                                       #
####################################################################

# Load options from the initialization script.
function loadOptions(script,    i, j, tokens, name, value) {
    tokenize(tokens, script)

    for (i in tokens) {
        if (tokens[i] ~ /^:/) {
            name = substr(tokens[i], 2)
            value = tokens[i + 1]

            if (value ~ /^[+-]?((0|[1-9][0-9]*)|[.][0-9]*|(0|[1-9][0-9]*)[.][0-9]*)([Ee][+-]?[0-9]+)?$/) {
                # Decimal number
                delete Option[name]
                Option[name] = value
            } else if (value == "false" || value == "true") {
                # Boolean
                delete Option[name]
                Option[name] = yn(value)
            } else if (value ~ /^".*"$/) {
                # String
                delete Option[name]
                Option[name] = literal(value)
            } else if (value == "[") {
                # List of strings
                delete Option[name]
                for (j = 1; tokens[i + j + 1] && tokens[i + j + 1] != "]"; j++) {
                    if (tokens[i + j + 1] ~ /^".*"$/)
                        Option[name][j] = literal(tokens[i + j + 1])
                    else {
                        e("[ERROR] Malformed configuration.")
                        return
                    }
                }
            } else {
                e("[ERROR] Malformed configuration.")
                return
            }
        }
    }
}