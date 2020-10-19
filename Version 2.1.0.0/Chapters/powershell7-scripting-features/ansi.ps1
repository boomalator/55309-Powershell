#requires -version 7.0

return "This is a snippets file"

<#
escape sequence
"`e["

or 
"$([char]0x1b)["
#>

"`e[36mHello World`e[0m"

"$([char]0x1b)[36mHello World$([char]0x1b)[0m"

