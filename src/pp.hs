infixr 5 :<|>
infixr 6 :<>
infixr 6 <>

data DOC = NIL
         | DOC :<> DOC
         | NEST Int DOC
         | TEXT String
         | LINE
         | DOC :<|> DOC
data Doc = Nil
         | Text String Doc
         | Line Int Doc


nil = NIL
x <> y = x :<> y
nest i x = NEST i x
text s = TEXT s
line = LINE
group x = flatten x :<|> x

flatten NIL       = NIL
flatten (x :<> y) = flatten x :<> flatten y
flatten (NEST i x)= NEST i (flatten x)
flatten (TEXT s)  = TEXT s
flatten LINE      = TEXT " "
flatten (x :<|> y)= flatten x

layout Nil = ""
layout (Text s x) = s ++ layout x
layout (Line i x) = '\n' : copy i ' ' ++ layout x

copy i x = [ x | _ <- [1..i] ]

best w k x = be w k [(0,x)]


be w k []               = Nil
be w k ((i,NIL):z)      = be w k z
be w k ((i,x :<> y):z)  = be w k ((i,x):(i,y):z)
be w k ((i,NEST j x):z) = be w k ((i+j,x):z)
be w k ((i,TEXT s):z)   = Text s $ be w (k+length s) z
be w k ((i,LINE):z)     = Line i $ be w i z
be w k ((i,x :<|> y):z) =  better w k (be w k ((i,x):z)) (be w k ((i,y):z))


better w k x y = if fits (w-k) x then x else y


fits w x | w < 0    = False
fits w Nil          = True
fits w (Text s x) = fits (w - length s) x
fits w (Line i x) = True

pretty w x = layout (best w 0 x)

-- Utility
--
x <+> y = x <> text " " <> y
x </> y = x <> line <> y

folddoc f [] = nil
folddoc f [x] = x
folddoc f (x:xs) = f x (folddoc f xs)

spread = folddoc (<+>)
stack = folddoc (</>)
bracket l x r = group (text l <>
               nest 2 (line <> x) <>
              line <> text r)

x <+/> y = x <> (text " " :<|> line) <> y

fillwords = folddoc (<+/>) . map text . words

fill [] = nil
fill [x] = x
fill (x:y:zs) = (flatten x <+> fill (flatten y : zs)) :<|> (x </> fill (y : zs))

-- Tree

data Tree = Node String [Tree]
showTree (Node s ts) = group (text s <> nest (length s) (showBracket ts))
showBracket [] = nil
showBracket ts = text "[" <> nest 1 (showTrees ts) <> text "]"
showTrees [t] = showTree t
showTrees (t:ts) = showTree t <> text "," <> line <> showTrees ts
showTree' (Node s ts) = text s <> showBracket' ts
showBracket' [] = nil
showBracket' ts = bracket "[" (showTrees' ts) "]"
showTrees' [t] = showTree t
showTrees' (t:ts) = showTree t <> text "," <> line <> showTrees ts


tree = Node "aaa" [ Node "bbbbb" [ Node "ccc" [], Node "dd" [] ], Node "eee" [], Node "ffff" [ Node "gg" [], Node "hhh" [], Node "ii" [] ] ]
