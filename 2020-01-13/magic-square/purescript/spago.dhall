{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "my-project"
, dependencies =
    [ "console"
    , "debug"
    , "effect"
    , "functions"
    , "matrices"
    , "newtype"
    , "psci-support"
    , "quickcheck"
    , "quickcheck-laws"
    , "react"
    , "react-basic"
    , "react-dom"
    , "refined"
    , "sized-matrices"
    , "stringutils"
    , "test-unit"
    , "vectors"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs"]
}
