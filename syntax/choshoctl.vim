syntax match choshoctlComment "^;.\+$"
syntax match choshoctlString "^調書名=.\+$"
syntax region choshoctlKeyword start="\[" end="\]"

highlight default link choshoctlComment Comment
highlight default link choshoctlString String
highlight default link choshoctlKeyword Keyword
