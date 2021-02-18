------------------
-- Imports --  {{{
------------------
-- XMONAD
import XMonad
-- Systems
import System.IO
import System.Exit
import System.Posix.Unistd (nodeName, getSystemID)
import System.Process
-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (avoidStruts, docks, ToggleStruts (ToggleStruts), docksStartupHook)
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.EwmhDesktops as E -- ewmh function impliments all ewmh capabilities
import XMonad.Hooks.ScreenCorners
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.DebugKeyEvents
-- Layouts
import XMonad.Layout.Fullscreen -- hiding (fullscreenEventHook)
import XMonad.Layout.NoBorders
import XMonad.Layout.Named
import XMonad.Layout.Spacing
import XMonad.Layout.PerWorkspace
import XMonad.Layout.IM
import XMonad.Layout.Gaps
import qualified XMonad.Layout.GridVariants as G
import XMonad.Layout.Reflect
import XMonad.Layout.TrackFloating
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
-- Actions
import XMonad.Actions.UpdatePointer
import XMonad.Actions.SpawnOn
import XMonad.Actions.CycleWS
import XMonad.Actions.WithAll
import XMonad.Actions.Submap as SM
import XMonad.Actions.Volume -- requires xmonad-extras installed
import XMonad.Actions.CopyWindow
import qualified XMonad.Actions.Search as S
import qualified XMonad.Actions.FlexibleResize as Flex
import XMonad.Actions.FloatKeys
import XMonad.Actions.Navigation2D
import XMonad.Actions.GridSelect
-- Utilities, other
import XMonad.Util.Paste
import XMonad.Util.Run
import XMonad.Util.NamedWindows
import XMonad.Util.Dzen as D
import XMonad.Util.WorkspaceCompare
import XMonad.Util.NamedScratchpad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import XMonad.Util.EZConfig
import Data.List (isPrefixOf)
-- Prompts
import XMonad.Prompt as P
import XMonad.Prompt.Shell
import XMonad.Prompt.Ssh
import XMonad.Prompt.Window
import XMonad.Prompt.Pass
-- TESTING
import XMonad.Prompt.MPD
import qualified Network.MPD as MPD
-- ENDTESTING
-- }}}
------------------
-- MAIN -- {{{
------------------
main = do
 hostname <- fmap nodeName getSystemID
 xmproc <- spawnPipe myDzenStatus
 xmonad $ withUrgencyHookC myUrgentHook myUrgencyConfig -- working
-- xmonad $ withUrgencyHookC BorderUrgencyHook { urgencyBorderColor = (colorLook Red 0) } urgencyConfig { suppressWhen = XMonad.Hooks.UrgencyHook.Never } -- working
-- xmonad $ withUrgencyHookC LibNotifyUrgencyHook myUrgencyConfig -- working
        $ withNavigation2DConfig def
-- xmonad $ withUrgencyHook myUrgentHook
-- xmonad $ withUrgencyHook LibNotifyUrgencyHook
        $ docks $ ewmh def {
          terminal = myTerminal
          , focusFollowsMouse = myFocusFollowsMouse
          , clickJustFocuses = myClickJustFocuses
          , borderWidth = myBorderWidth
          , modMask = myModMask
          , workspaces = myWorkspaces
          , normalBorderColor = myNormalBorderColor
          , focusedBorderColor = myFocusedBorderColor
          , layoutHook = smartBorders (myLayoutHook)
          , handleEventHook = myEventHook
          , manageHook = composeAll [
                     manageSpawn
                     , myManageHook
                     , namedScratchpadManageHook myScratchPads
          ]
          , startupHook = composeAll [
                     myStartupHook
                     , docksStartupHook
                     , setWMName "LG3D"
                     , myCaseHook hostname -- pass hostname variable
                     , myDzenStartup
          ]
          , logHook = composeAll [
                    myDzenLogHook xmproc
                    , myLogHook
          ]
 } `additionalKeys` myKeys hostname `additionalMouseBindings` myMouseBindings hostname -- pass hostname variable
-- }}}
------------------
-- Custom Apps -- {{{
------------------
-- if reference in several places then i add here. just in case an update changes the syntax
myXTerminal     = "xterm"
--myTerminal    = "urxvt"
myTerminal      = "roxterm" -- roxterm-gtk2
myInternet      = "google-chrome-stable"
--myInternet      = "chromium"
myBackground    = "~/.xmonad/bin/wallpaper.sh"
myBackgrdcolor  = "~/.xmonad/bin/background-set.sh"
myScreenshot    = "scrot ~/Pictures/screen_%Y-%m-%d-%H-%M-%S.png -d 1 && sleep 1 && notify-send \"ScreenShot Done\""
myScreenshotW   = "sleep 1; scrot -u ~/Pictures/screen_%Y-%m-%d-%H-%M-%S.png -d 1 && sleep 1 && notify-send \"ScreenShot Done\""
myMouseshot     = "sleep 0.2; scrot -s ~/Pictures/screen_%Y-%m-%d-%H-%M-%S.png -d 1 && sleep 1 && notify-send \"ScreenShot Done\""
myRdesktop      = "~/.xmonad/bin/remote-rdp.sh "
myMpd           = "~/.xmonad/bin/tmux-Ncmpcpp.sh"
myMpdterm       = myTerminal ++ " -T mpd -e ~/.xmonad/bin/tmux-Ncmpcpp.sh"
myMpdKill       = "pkill mpd; pkill ncmpcpp; pkill Ncmpcpp"
myMpdPrev       =  "mpc prev"; myMpdToggle =  "mpc toggle"; myMpdNext =  "mpc next"; myMpdStop = "mpc stop"
myConkympd      = "~/.xmonad/bin/conky_mpd_cover.sh"
myMonitors      = "~/.xmonad/bin/xrandr-monitors.sh"
myClearclip     = "xclip -i /dev/null; xclip -selection clipboard /dev/null && pkill xclip"
myXconfigs      = myXTerminal ++ " -title Xconfigs -e ~/.xmonad/bin/vim-Xconfigs.sh"
myXmonadKill    = "~/.xmonad/bin/xmonad-restart.sh"
myDzenbar1      = "~/.xmonad/bin/start_dzen1.sh"
myDzenbar2      = "~/.xmonad/bin/start_dzen2.sh"
myScreenLock    = "~/.xmonad/bin/my-hacky-screensaver.sh "
myMsg           = "~/.xmonad/bin/mymsg.sh"
myVol           = "~/.xmonad/bin/volume.sh"
-- }}}
------------------
-- Workspaces & Clickable WS -- {{{
------------------
-- The default number of workspaces (virtual screens) and their names.
--myWorkspaces = map show [1..9] ++ ["0","NSP","NSP1","DEV1","DEV2"]
myExtraWSs = ["0","NSP","NSP1","DEV1","DEV2"]
myWorkspaces = map show [1..9] ++ myExtraWSs

--myWorkspaces = clickable $ ["1","2","3","4","5","6","7","8","9"] ++ ["NSP"]
-- where clickable l = ["^ca(1,xdotool key super+" ++ show (n) ++ ")" ++ ws ++ "^ca()" | (i,ws) <- zip [1..9] l, let n = i ]
-- where clickable l = ["^ca(1,xdotool key super+" ++ show (n) ++ ")" ++ ws ++ "^ca()" | (i,ws) <- zip nums l, let n = i ]
-- }}}
------------------
-- Window rules/ManageHook -- {{{
------------------
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- resource (also known as appName) is the first element in WM_CLASS(STRING)
-- className is the second element in WM_CLASS(STRING)
-- title is WM_NAME(STRING)
-- ALSO
-- xdotool selectwindow getwindowname
--
myManageHook ::  ManageHook
myManageHook = composeAll . concat $
    [
      [ isDialog --> doCenterFloat ]
    , [ isFullscreen --> doFullFloat ]
    , [(className =? c <||> title =? c <||> resource =? c) --> doIgnore | c <- bars ]
    , [(className =? c <||> title =? c <||> resource =? c) --> doFloat | c <- float ]
    , [(className =? c <||> title =? c <||> resource =? c) --> doCenterFloat | c <- cfloat ]
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift "0" | c <- ws0 ] -- 0
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 0) | c <- ws1 ] -- i
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 1) | c <- ws2  ] -- ii
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 2) | c <- ws3 ] --iii
    , [ fmap (c `isPrefixOf`) className <||> fmap (c `isPrefixOf`) title <||> fmap (c `isPrefixOf`) resource  --> doShift (myWorkspaces !! 3) | c <- ws4 ] -- iv
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 4) | c <- ws5 ] -- v
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 5) | c <- ws6 ] -- vi
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 6) | c <- ws7 ] -- vii
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 7) | c <- ws8 ] -- viii
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift (myWorkspaces !! 8) | c <- ws9 ] -- ix
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift "NSP" | c <- nsp ] -- nsp
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift "NSP1" | c <- nsp1 ] -- nsp1
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift "DEV1" | c <- dev1 ] -- dev1
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift "DEV2" | c <- dev2 ] -- dev2
    , [role =? c --> doFloat | c <- im ] -- place roles on im
   ]
   where
     bars    = ["dzen2","desktop_window"]
     float   = ["feh","conky_mpd"]
     cfloat  = ["Xmessage","Gxmessage","Eog","xclock"]
            ++ ["SimpleScreenRecorder","Evolution-alarm-notify","Evolution","Gns3","Mtpaint","Calculator","world-clock","wifi-qrcode","agenda-term","arandr"]
            ++ ["xeyes","pinentry","zoiper"]
     ws0     = ["nothing"]
     ws1     = ["Wine"]
     ws2     = ["google-chrome","chromium"]
     ws3     = ["libreoffice-calc","libreoffice-writer","VirtualBox Manager","VirtualBox Machine","libreoffice","Firefox","firefox"]
     ws4     = ["xfreerdp","rdesktop"]
     ws5     = ["Xpdf","zoiper"]
     ws6     = ["Chiaki"]
     ws7     = ["Gvim","Xconfigs","TeamViewer"]
     ws8     = ["Pithos","Gimp","Ario","vlc","retroarch","google-meet-desktop"]
     ws9     = ["Hexchat","Pidgin","Skype","Microsoft Teams","Microsoft Teams - Preview","zoom","Slack"]
     nsp     = ["nothing","sendtonsp"]
     nsp1    = ["GNS3"]
     dev1    = ["nothing"]
     dev2    = ["nothing"]
     im      = ["browser-window"] -- teams
     role    = stringProperty "WM_WINDOW_ROLE" -- example
-- }}}
------------------
-- Layouts --  {{{
------------------
mySpacing bs = spacingRaw True (uniformBorder bs) True (uniformBorder bs) True
   where
       uniformBorder n = Border n n n n

gapper s = (gaps [(U, s), (R, s), (L, s), (D, s)]) . mySpacing (toInteger s)
grid orientation s = gapper s $ G.SplitGrid orientation 1 1 (1/2) (16/9) (5/100)

--myLayoutHook = (avoidStruts (standardLayouts) ||| fullscreen)
myLayoutHook = onWorkspace (myWorkspaces !! 8) (avoidStruts (tabbedLayout) ||| avoidStruts (imLayout) ||| avoidStruts (standardLayouts))
             $ onWorkspace (myWorkspaces !! 7) (avoidStruts (gimpLayout) ||| avoidStruts (standardLayouts)) 
             $ onWorkspace (myWorkspaces !! 3) (avoidStruts (tabbedLayout) ||| avoidStruts (standardLayouts)) 
             $ onWorkspace (myWorkspaces !! 1) (avoidStruts (chatLayout) ||| avoidStruts (standardLayouts)) 
             $ onWorkspaces ["DEV1","DEV2"] (avoidStruts (threeLayout) ||| avoidStruts (standardLayouts))
             $ avoidStruts (standardLayouts) ||| fullscreen
  where
    standardLayouts = 
                    named "+" (mySpacing (toInteger myBorderSpace) $ reflectVert $ G.Grid (16/10)) -- grid -- reflectvert spawns windows on the left
                    ||| named "TT" (grid G.B myBorderSpace) -- grid ; bottom ; spacing
                    ||| named "=[]" (grid G.L myBorderSpace) -- grid ; left ; spacing
                    ||| named "_+_" (grid G.T myBorderSpace) -- grid ; Top ; spacing
                    ||| named "[]=" (grid G.R myBorderSpace) -- grid ; right ; spacing
    tabbedLayout = named "Tab" $ (simpleTabbed)
    fullscreen = named "[_]" (noBorders (fullscreenFull Full)) -- full
    imLayout = named "IML" $ gridIM (1/5) (Title "Buddy List") -- for pidgin
    chatLayout = named "IML" $ withIM 0.4 (Role "pop-up") $ reflectHoriz $ withIM 0.3 (Role "pop-up") (trackFloating (grid G.T 0)) -- pop-up is WhatApp and Google Hangouts; whoever opens first
    gimpLayout = named "GimpL" $ withIM 0.2 (Role "gimp-dock") $ reflectVert $ withIM 0.3 (Role "gimp-dock") (trackFloating (grid G.T 0)) -- Gimp Layout -- reflectvert spawns windows at the bottom
    threeLayout = named "|||" $ (ThreeColMid 1 (3/100) (1/3))
-- }}}
------------------
-- Config Functions, Colors, Borders, Mouse Focus, Fonts -- {{{
------------------
myXPConfig :: P.XPConfig
myXPConfig = P.def
 { P.font        = myFont 8
 , P.bgColor     = (colorLook Hue 1)
 , P.fgColor     = (colorLook White 1)
 , P.borderColor = (colorLook Red 0)
 , P.promptBorderWidth = 1
 , P.position    = P.Bottom
 , P.height      = 15
 --, P.autoComplete = Just 500000
 , P.historySize = 10 }
-- colors
type Hex = String
type ColorCode = (Hex,Hex)
type ColorMap = M.Map Colors ColorCode

data Colors = Black | Red | Green | Yellow | Blue | Orange | Magenta | Cyan | White | Purple | BG | Hue
    deriving (Ord,Show,Eq)

colorLook :: Colors -> Int -> Hex
colorLook color n =
    case M.lookup color colors of
        Nothing -> "#000000"
        Just (c1,c2) -> if n == 0 then c1 else c2

colors :: ColorMap
colors = M.fromList
    [ (Black , ("#000000", "#121212")) -- black and gray7
    , (Red , ("#ff0000", "#f21835")) -- 
    , (Green , ("#0dd40d", "#006400")) --
    , (Yellow , ("#FFFF00", "#C3C32D")) --
    , (Blue , ("#000040", "#80c0ff")) --
    , (Orange , ("#ff8C00", "#ce260b")) --
    , (Magenta , ("#6f4484", "#915eaa")) --
    , (Cyan , ("#2B7694", "#47959E")) --
    , (White , ("#D6D6D6", "#A3A3A3")) --
    , (Purple , ("#9B30FF", "#7D26CD")) --
    , (BG , ("#000000", "#444444")) --
    , (Hue , ("#0e2f44", "#262b56")) --
    ]
myBorderWidth  = 4
myBorderSpace  = 5
myNormalBorderColor  = (colorLook Black 0)
myFocusedBorderColor = (colorLook Green 1)
-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
-- True if want to mimic MSWindows Env. 
myClickJustFocuses :: Bool
myClickJustFocuses = False
-- fonts
myGSFont  = "xft:Noto Sans CJK KR:bold:pixelsize=10" -- used in gridselect
myFont sz = "Fixed:size=" ++ (show sz) ++ ":antialias=false" -- used in XPConfig and UrgentHook
myTitleFont sz = "Fixed:size=" ++ (show sz) ++ ":antialias=true" -- used for dzen bar, since use Dice font
myEmptyTitleFont sz = "Fixed:size=" ++ (show sz) ++ ":antialias=true" -- used for dzen bar, since use Dice font
myDiceFont sz = "Dice:size=" ++ (show sz) ++ ":antialias=true" -- used in dzen bar for NSP1

-- | A synthwave monochrome colorizer
myColorizer :: a -> Bool -> X (String, String)
myColorizer _ True = return ("#783e57", "#ffffff") -- #bg-active, #fg-active
myColorizer _ False = return ("#312e39", "#c0a79a") -- #bg-inactive, #fg-inactive
-- gridselect gsconfig
myGSConfig :: t -> GSConfig Window
myGSConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 30
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_colorizer = myColorizer
    , gs_font         = myGSFont
    }
-- spawnSelected Redefine
spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 30
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_colorizer = myColorizer
                   , gs_font         = myGSFont
                  }
-- custom apps for spawnSelected
myCustomAppsGrid = [
        ("MPD Conky Album"          , "~/.xmonad/bin/conky_mpd_cover.sh " )
        , ("GA-B"                    , "~/bin/get-totp.sh 1"      )
        , ("GA-W"                    , "~/bin/get-totp.sh 2"      )
        , ("GA-BM"                    , "~/bin/get-totp.sh 3"     )
        ]
-- apps for spawnSelected
myAppGrid = [
        ( "Ario - MPD GUI"           , "ario"                     )
        , ("Calculator"              , "xcalc"                    )
        , ("Chiaki PS4 Remote"       , "chiaki"                   )
        , ("Gimp"                    , "gimp"                     )
        , ("Google Chrome"           , "google-chrome-stable"     )
        , ("Google Meets"            , "google-meet-desktop"     )
        , ("Firefox"                 , "firefox"                  )
        , ("Gvim"                    , "gvim"                     )
        , ("Hexchat"                 , "hexchat"                  )
        , ("LibreOffice Calc"        , "libreoffice --calc"       )
        , ("LibreOffice Writer"      , "libreoffice --writer"     )
        , ("LibreOffice Impress"     , "libreoffice --impress"    )
        , ("Pithos"                  , "pithos"                   )
        , ("Roxterm"                 , "roxterm"                  )
        , ("Slack"                   , "slack -s"                 )
        , ("Teams"                   , "teams"                    )
        , ("Teamviewer"              , "teamviewer"               )
        , ("Virtualbox"              , "virtualbox"               )
        , ("Vlc"                     , "vlc"                      )
        , ("Xterm"                   , "xterm"                    )
        , ("Zoiper"                  , "zoiper"                   )
        , ("Zoom"                    , "zoom"                     )
        ]
-- }}}
------------------
-- KeyNumList, ProfileList -- {{{
------------------
-- These lists should correspond to the total number of WS and in the order in which you want to used them
-- Non-numeric num pad keys, sorted by number
numPadKeys = [ xK_KP_End,  xK_KP_Down,  xK_KP_Page_Down -- 1, 2, 3
 , xK_KP_Left, xK_KP_Begin, xK_KP_Right     -- 4, 5, 6
 , xK_KP_Home, xK_KP_Up,    xK_KP_Page_Up ]   -- 7, 8, 9
 ++
 [xK_KP_Insert , xK_KP_Subtract, xK_KP_Add] -- 0, subtrack, add; WSs 0 NSP NSP1 respectively; keypad zero/minus = Default/Defaultr profiles respectively
 ++
 [xK_KP_Divide, xK_KP_Multiply] -- WSs dev1  dev2
numKeys = [ xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9 ] ++ [ xK_0, xK_minus, xK_equal ] ++ [ xK_bracketleft, xK_bracketright ] -- [ = dev1; ] = dev2
nums = map show [1..9] ++ ["0","-","="]
myTermProfiles = ["AMER","EMEA","APAC","AMERc","EMEAc","APACc","AMERr","EMEAr","APACr"] ++ ["Default","Defaultr"] -- roxterm profiles
myLTermProfiles = ["AMER-L","EMEA-L","APAC-L","AMER-Lc","EMEA-Lc","APAC-Lc","AMER-Lr","EMEA-Lr","APAC-Lr"] ++ ["Default","Defaultr"] -- roxterm profiles
myTATermProfiles = ["TAhap","TAhis","TAdbm","TAdbs1","TAdbs2","TAdbs3","TAdbs4","TAdbb","TAsrv1"] ++ ["TAzabb","Default"] -- roxterm profiles for work
myLTATermProfiles = ["TAhap-L","TAhis-L","TAdbm-L","TAdbs1-L","TAdbs2-L","TAdbs3-L","TAdbs4-L","TAdbb-L","TAsrv1-L"] ++ ["TAzabb-L","Default"] -- roxterm profiles for work
-- }}}
------------------
-- SearchEngince --  {{{
searchEngineMap method = M.fromList $
 [ 
 ((0, xK_a), method S.amazon)
 , ((0, xK_d), method S.dictionary)
 , ((0, xK_e), method S.ebay)
 , ((0, xK_g), method S.google)
 , ((0, xK_i), method S.images)
 , ((0, xK_j), method $ S.searchEngine "Jira" "https://teamamericany.atlassian.net/browse/")
 , ((0, xK_m), method S.maps)
 , ((0, xK_w), method S.wikipedia)
 , ((0, xK_y), method S.youtube)
 ]
-- }}}
------------------
-- Scratchpads --  {{{
myScratchPads = [ NS "scratchterm" spawnTerm  findTerm  manageTerm -- Named scratchpad
                , NS "scratchmpd" spawnMpd findMpd manageMpd -- Mpd scratchpad
                ]
  where
    spawnMpd = myMpd ++ " roxterm"
    findMpd = title =? "scratchpadmpd"
    manageMpd = customFloating $ W.RationalRect l t w h
      where
        h = 0.90 -- terminal height
        w = 0.95 -- terminal width
        t = 0.05 -- distance from top edge
        l = 0.025 -- distance from left edge

    spawnTerm  = myTerminal ++ " -T scratchpad" -- launch my terminal
    findTerm   = title  =? "scratchpad" -- its window will be named "scratchpad" (see above)
    manageTerm = customFloating $ W.RationalRect l t w h -- and I'd like it fixed using the geometry below
      where
        h = 0.1 -- height, 10%
        w = 1 -- width, 100%
        t = 1 - h -- distance from top edge
        l = (1 - w)/2 -- distance from left edge
-- }}}
------------------
-- LibNotify -- {{{
------------------
-- to evoke urgent bell on terminal run:
-- sleep 2; echo -e '\a'
-- on a non visible workspace. make sure terminal has urgent on
data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)
instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name     <- getName w
        Just idx <- fmap (W.findTag w) $ gets windowset
        safeSpawn "notify-send" [show name, "" ++ idx]
-- }}}
------------------
-- DzenVol --  {{{
showVol = dzenConfig centered . show . round
centered = onCurr (center 150 66)
    >=> D.font "-*-helvetica-*-r-*-*-64-*-*-*-*-*-*-*"
    >=> D.addArgs ["-fg", (colorLook Blue 1)]
    >=> D.addArgs ["-bg", (colorLook Blue 0)]
-- }}}
------------------
-- UrgentHook --  {{{
myUrgentHook = dzenUrgencyHook
 { args = 
  [ "-fg", (colorLook Orange 0)
  , "-bg", (colorLook Green 1)
  , "-title-name", "UrgentDzen"
  , "-xs", "1"
  , "-x", "0"
  , "-y", "-1"
  , "-fn", myFont 8] }
--myUrgencyConfig = urgencyConfig {suppressWhen= Visible, remindWhen = (Every (minutes 1.0))}
--myUrgencyConfig = urgencyConfig {suppressWhen= XMonad.Hooks.UrgencyHook.Never, remindWhen = Every 30}
-------myUrgencyConfig = UrgencyConfig XMonad.Hooks.UrgencyHook.Never (Every 1)
-------myUrgencyConfig = UrgencyConfig {suppressWhen=XMonad.Hooks.UrgencyHook.Never}
--myUrgencyConfig = UrgencyConfig {remindWhen = Every 30}
myUrgencyConfig = UrgencyConfig {suppressWhen = XMonad.Hooks.UrgencyHook.Never, XMonad.Hooks.UrgencyHook.remindWhen = Every 7}
-- }}}
------------------
-- Startup/Event Hooks -- {{{
------------------
myStartupHook = do
 addScreenCorners [ 
   (SCLowerRight, spawn myTerminal)
--   , (SCUpperRight, nextWS)
--   , (SCUpperLeft, something)
--   , (SCLowerLeft,  spawn myTerminal)
   ]
 --spawnHere "conky -c ~/.config/conky/stats_circle/greatcircle" -- use cool conky circle
 --spawnHere "xplanet -utclabel -pango -transparency --projection merc -config ~/.xplanet/default -wait 1800"
 --spawnHere myBackground -- feh wallpaper script; with APOD
 --spawnHere $ myBackgrdcolor ++ " \"" ++ (colorLook Hue 0) ++ "\"" -- using xmonad variable as bash argument, pretty cool
 spawnHere myClearclip -- clear clipboard
 spawnHere myMonitors -- script to see # of monitors and which ones
 return ()

myDzenStartup = do
 spawnHere myDzenbar2
 return ()

myCaseHook :: String -> X ()
myCaseHook hostname = case hostname of
  "ARCHLAP" -> return ()
  "ARCHOLD" -> return ()
  "ARCHWORK" -> return ()
  _         -> return ()
--  _       -> do { spawnHere myTerminal ;
--          -- do something else
--           }

myEventHook = screenCornerEventHook
 <+> E.fullscreenEventHook
 <+> debugKeyEvents -- see ~/.xsession-errors
-- <+> docksEventHook
-- }}}
------------------
-- LogHook & Bars -- {{{
------------------
myLogHook :: X ()
myLogHook = updatePointer (0.5, 0.5) (0, 0) -- moves pointer to center of focused window
 <+> fadeInactiveLogHook fadeAmount
       where fadeAmount = 0.8

myDzenStatus = myDzenbar1
myDzenLogHook h = do
    copies <- wsContainingCopies
    let check ws | ws `elem` copies = dzenColor (colorLook Black 0) (colorLook Purple 0) $ ws | otherwise = ws -- color of WS with copied clients
    dynamicLogWithPP dzenPP { 
      ppOutput = hPutStrLn h
      , ppHidden = dzenColor (colorLook White 1) "" . wrap "" "" . check . noScratch
      , ppHiddenNoWindows = noScratchPad
      , ppSort = getSortByXineramaRule
      , ppSep = " "
      , ppWsSep = " "
      , ppTitle = dzenColor "" "" . 
                               (\x -> if null x -- If there are actually no clients here, display the following ...
                                then "^fn(" ++ myEmptyTitleFont 8 ++ ")" ++ "^fg(" ++ (colorLook Green 0) ++ ")" ++ ""
                                -- ... and the focused windows' title with a maximum length of 100 chars and trailing dots otherwise:
                                else "^fn(" ++ myTitleFont 10 ++ ")" ++ "^fg(" ++ (colorLook Green 0) ++ ")" ++ shorten 100 x ++ ""
                               ) . dzenEscape
                               -- . wrap "^ca(2,xdotool key super+shift+c)" "^ca()" . shorten 100
      , ppCurrent = dzenColor (colorLook Black 0) (colorLook Yellow 0) .
                               (\ x -> case x of
                                "NSP" -> "^i("++iconsdir++"workspace-nsp.xbm)"
                                "NSP1" -> "^fn(" ++ myTitleFont 10 ++ ")" ++ x ++ "^fn(" ++ myDiceFont 10 ++ ")" -- dont have xbm file so change font then change back to dice font
                                "DEV1"  -> "^fn(" ++ myTitleFont 10 ++ ")" ++ x ++ "^fn(" ++ myDiceFont 10 ++ ")"
                                "DEV2"  -> "^fn(" ++ myTitleFont 10 ++ ")" ++ x ++ "^fn(" ++ myDiceFont 10 ++ ")"
                                _  -> x
                               )
      , ppVisible = dzenColor (colorLook Black 0) (colorLook Cyan 1) .
                               (\ x -> case x of
                                "NSP" -> "^i("++iconsdir++"workspace-nsp.xbm)"
                                "NSP1" -> "^fn(" ++ myTitleFont 10 ++ ")" ++ x ++ "^fn(" ++ myDiceFont 10 ++ ")" -- dont have xbm file so change font then change back to dice font
                                "DEV1"  -> "^fn(" ++ myTitleFont 10 ++ ")" ++ x ++ "^fn(" ++ myDiceFont 10 ++ ")"
                                "DEV2"  -> "^fn(" ++ myTitleFont 10 ++ ")" ++ x ++ "^fn(" ++ myDiceFont 10 ++ ")"
                                _  -> x
                               )
      , ppUrgent = dzenColor (colorLook Black 0) (colorLook Red 0) .
                               (\ x -> case x of
                                "NSP" -> "^i("++iconsdir++"workspace-nsp.xbm)"
                                "NSP1" -> "^fn(" ++ myTitleFont 10 ++ ")" ++ x ++ "^fn(" ++ myDiceFont 10 ++ ")" -- dont have xbm file so change font then change back to dice font
                                "DEV1"  -> "^fn(" ++ myTitleFont 10 ++ ")" ++ x ++ "^fn(" ++ myDiceFont 10 ++ ")"
                                "DEV2"  -> "^fn(" ++ myTitleFont 10 ++ ")" ++ x ++ "^fn(" ++ myDiceFont 10 ++ ")"
                                _  -> x
                               )
      , ppLayout = dzenColor (colorLook Orange 0) "" .
                               (\ x -> case x of
                                "+"   -> "^i("++iconsdir++"layout-grid.xbm)"
                                "TT" -> "^i("++iconsdir++"layout-mirror-top.xbm)"
                                "=[]" -> "^i("++iconsdir++"layout-tall-right.xbm)"
                                "_+_"  -> "^i("++iconsdir++"layout-mirror-bottom.xbm)"
                                "[]=" -> "^i("++iconsdir++"layout-tall-left.xbm)"
                                "[_]" -> "^i("++iconsdir++"layout-full.xbm)"
                                "IML" -> "^i("++iconsdir++"layout-im.xbm)"
                                "Tab" -> "^i("++iconsdir++"layout-mirror-top.xbm)"
                                "GimpL" -> "^i("++iconsdir++"layout-gimp.xbm)"
                                "|||" -> "^i("++iconsdir++"layout-threecol.xbm)"
                                _  -> "^fg(" ++ (colorLook Red 0) ++ ")" ++ "^i("++iconsdir++"flag20n.xbm)" -- red flag for unknown layout name
                                --_  -> "^fn(" ++ myTitleFont 10 ++ ")" ++ "^fg(" ++ (colorLook Red 0) ++ ")" ++ x -- if want to see the actual name of the layout
                               ) 
                               -- . wrap "^ca(1,xdotool key super+space)^ca(3,xdotool key super+shift+space)" "^ca()^ca()"
    }
  where
    noScratch ws = if ws == "0" || ws == "NSP" || ws == "NSP1" || ws == "DEV1" || ws == "DEV2" then "" else ws  -- if WS with client, then dont show
    noScratchPad ws = if ws == "0" || ws == "NSP" || ws == "NSP1" || ws == "DEV1" || ws == "DEV2" then "" else ""  -- dont show specific WS at all
    iconsdir = ("/home/dmacias/.xmonad" ++ "/icons/") -- ~/.xmonad/icons

-- }}}
------------------
-- Key Bindings -- {{{
------------------
-- modMask lets you specify which modkey you want to use. The default is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The "windows key" is usually mod4Mask.
-- FOR MULTIMEDIA KEYS RUN: (if a key is binded then escape it using ctrl+key)
-- xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'
-- Then look in /usr/include/X11/XF86keysym.h and look for the name and code or xmodmap -pk
myModMask = mod4Mask
modalt=mod1Mask
myKeys (hostname) =  [
-- "Standard" Overwritten keybindings --
 ((mod4Mask .|. shiftMask, xK_Return), spawn myXTerminal)
 , ((mod4Mask, xK_q), spawn myXmonadKill) -- restart xmond using custom script

-- Custom Keybindings --
-- Window movement
 , ((mod4Mask .|. shiftMask, xK_Up), windows . W.shift =<< findWorkspace getSortByIndexNoWSList Next EmptyWS 1) -- send window to next empty WS except WSlist
 , ((mod4Mask .|. shiftMask, xK_Down), windows . W.shift =<< findWorkspace getSortByIndexNoWSList Prev EmptyWS 1) -- send window to prev empty WS except WSlist
 , ((mod4Mask .|. shiftMask, xK_Page_Up), (windows . W.shift =<< findWorkspace getSortByIndexNoWSList Next EmptyWS 1) >> (windows . W.greedyView =<< findWorkspace getSortByIndexNoWSList Next NonEmptyWS 1) ) -- same but follow focus to next WS except WSlist
 , ((mod4Mask .|. shiftMask, xK_Page_Down), (windows . W.shift =<< findWorkspace getSortByIndexNoWSList Prev EmptyWS 1) >> (windows . W.greedyView =<< findWorkspace getSortByIndexNoWSList Prev NonEmptyWS 1) ) -- same but follow focus to prev WS except WSlist
-- Swap workspaces on adjacent screens
 , ((mod4Mask .|. shiftMask, xK_Left), screenSwap L False)
 , ((mod4Mask .|. shiftMask, xK_Right), screenSwap R False)
 , ((mod4Mask .|. shiftMask, xK_h), screenSwap L False) -- mimic vim
 , ((mod4Mask .|. shiftMask, xK_l), screenSwap R False) -- mimic vim
-- Workspace Navigation
 , ((mod4Mask, xK_Up), windows . W.greedyView =<< findWorkspace getSortByIndexNoWSList Next HiddenNonEmptyWS 1) -- move to next WS except WSlist
 , ((mod4Mask, xK_Down), windows . W.greedyView =<< findWorkspace getSortByIndexNoWSList Prev HiddenNonEmptyWS 1) -- move to prev WS except WSlist
 , ((mod4Mask, xK_Page_Up), windows . W.greedyView =<< findWorkspace getSortByIndexNoWSList Next EmptyWS 1) -- move to next WS except WSlist
 , ((mod4Mask, xK_Page_Down), windows . W.greedyView =<< findWorkspace getSortByIndexNoWSList Prev EmptyWS 1) -- move to prev WS except WSlist
 , ((mod4Mask, xK_BackSpace), focusUrgent) -- move to URGENT WS
 , ((mod4Mask, xK_z), toggleWS) -- move to prev visible WS
 , ((modalt, xK_j), windowGo U False)
 , ((modalt, xK_k), windowGo D False)
 , ((modalt, xK_h), windowGo L False)
 , ((modalt, xK_l), windowGo R False)
 -- Screen Naviation
 , ((mod4Mask, xK_Left), screenGo L True) -- move to left neigh
 , ((mod4Mask, xK_Right), screenGo R True) -- move to right neigh
-- Apps
 , ((mod4Mask, xK_g), goToSelected  $ myGSConfig myColorizer)
 , ((mod4Mask, xK_y), spawnSelected' myAppGrid)
 , ((mod4Mask, xK_u), spawnSelected' myCustomAppsGrid)
 , ((mod4Mask .|. controlMask, xK_i), spawn myInternet)
 --, ((mod4Mask .|. controlMask, xK_n), (windows $ W.greedyView (myWorkspaces !! 7)) >> spawn "sleep 2" >> spawn myMpdterm) -- workaround for tmux
 , ((mod4Mask .|. controlMask, xK_n), namedScratchpadAction myScratchPads "scratchmpd") -- now using scratchpad for mpd spawn
 , ((mod4Mask .|. controlMask .|. shiftMask, xK_n), spawn myConkympd)
 , ((mod4Mask .|. shiftMask, xK_KP_Enter), spawn myXTerminal) -- open terminal
 , ((mod4Mask .|. controlMask, xK_Return), spawn myTerminal) -- open terminal
 , ((mod4Mask .|. controlMask, xK_KP_Enter), spawn myTerminal) -- open terminal
 -- Remote Desktop RDP; dependent on script
 , (((mod4Mask .|. controlMask), xK_r), submap . M.fromList $
   [ ((0, k), spawn (myRdesktop ++ " " ++ show i))
   | (i,k) <- (zip nums numKeys ++ zip nums numPadKeys)
   ] )
-- Misc
 , ((mod4Mask .|. shiftMask, xK_q), spawn (myMsg ++ " q") >> io (exitWith ExitSuccess))
 , ((mod4Mask .|. shiftMask, xK_c), kill1) -- kill a window so it only removes it from the current workspace, if it's present elsewhere
 , ((mod4Mask .|. controlMask, xK_Delete), withFocused $ \w -> spawn ("xkill -id " ++ show w))   -- xkill focused -- testing
 , ((mod4Mask .|. shiftMask, xK_BackSpace), clearUrgents) -- as it says
 , ((mod4Mask .|. shiftMask, xK_n), spawn myMpdKill) -- kill mpd
 , ((mod4Mask .|. shiftMask, xK_s), SM.submap $ searchEngineMap $ S.selectSearchBrowser myInternet) -- clipboard web browser search
 , ((mod4Mask .|. shiftMask, xK_t), sinkAll) -- pushes all floating windows on the current workspace back into tiling
 , ((mod1Mask .|. shiftMask, xK_c), killAll :: X ()) -- kill all windows in WS
 , ((mod4Mask .|. controlMask .|. shiftMask, xK_c), killAllOtherCopies) -- kill all copies of window
 , ((mod4Mask, xK_c), spawn myClearclip ) -- clear clipboard
 , ((mod4Mask .|. shiftMask, xK_Delete), kill)       -- behaves similarly to xkill focused -- testing
 , ((mod4Mask, xK_Delete), safeSpawn "xkill" [])     -- xkill interactive. right-click to cancel -- testing
 , ((mod4Mask, xK_Print), spawn myMouseshot) -- mouse select screenshot
 , ((mod4Mask, xK_F12), spawn "eject -T") -- eject tray
 , ((0, 0x1008FF2C), spawn "eject -T") -- eject tray
 , ((mod4Mask, xK_F11), spawn (myXconfigs ++ " F11")) -- open xmonad.hs file
 , ((mod4Mask, xK_F10), spawn (myXconfigs ++ " F10")) -- open bar config file
 , ((mod4Mask, xK_F9), spawn (myXconfigs ++ " F9")) -- open second bar config file
 , ((mod4Mask, xK_b), sendMessage ToggleStruts) -- hide bar
 , ((0, 0x1008FF2F), spawn myScreenLock) -- screensaver lock
 , ((0, xK_Print), spawn myScreenshot)
 , ((mod1Mask, xK_Print), spawn myScreenshotW)
 --, ((0, xK_Insert), pasteSelection) -- uses getSelection from XMonad.Util.XSelection and so is heir to its flaws
 , ((0, xK_Insert), spawn "xdotool click 2") -- paste x primary, simulates middle click
 , ((0, xK_Scroll_Lock), namedScratchpadAction myScratchPads "scratchterm") -- open scratchpad
 , ((shiftMask, xK_Insert), spawn "xdotool click 2") -- paste x primary, simulates middle click
-- Xprompts
 , ((mod4Mask .|. controlMask, xK_s), sshPrompt myXPConfig) -- ssh prompt
 , ((mod4Mask .|. controlMask, xK_x), prompt (myTerminal ++ " -T sendtonsp -e") myXPConfig) -- run command using prompt
 , ((mod4Mask .|. shiftMask, xK_b), windowPrompt myXPConfig Bring allWindows ) -- bring window client
 , ((mod4Mask .|. shiftMask, xK_g), windowPrompt myXPConfig Goto allWindows) -- go to window client in WS
 , ((mod4Mask, xK_s), SM.submap $ searchEngineMap $ S.promptSearchBrowser myXPConfig myInternet ) -- prompt search
 , ((mod4Mask, xK_p), passPrompt myXPConfig) -- $ pass show -c group/name
 , ((mod4Mask .|. mod1Mask, xK_p), passGeneratePrompt myXPConfig) -- $ gpg --full-gen-key ; pass init <last8digitsofkey> ; pass insert group/name 
 , ((mod4Mask .|. controlMask  .|. shiftMask, xK_p), passRemovePrompt myXPConfig) -- $ pass rm group/name
-- Help Messege
 , ((mod4Mask .|. shiftMask, xK_slash ), spawn ("cat " ++ help_default_keybindings ++ " | gxmessage -geometry 900x700 -font monospace -file -")) -- show messege of default xmonad keybindings
 , ((mod4Mask, xK_slash), spawn ("cat " ++ help_custom_keybindings ++ " | gxmessage -geometry 900x700 -font monospace -file -")) -- show messege of default xmonad keybindings
-- Window resizing
 --, ((mod4Mask .|. controlMask .|. shiftMask, xK_KP_Multiply), withFocused (keysAbsResizeWindow (500, 8) (0, 0))) -- make window larger
 --, ((mod4Mask .|. controlMask .|. shiftMask, xK_KP_Divide), withFocused (keysAbsResizeWindow (-100, 8) (0, 0))) -- make window smaller
 , ((mod4Mask .|. controlMask .|. shiftMask, xK_KP_Multiply), withFocused (keysResizeWindow (500, 8) (0, 0))) -- make window larger
 , ((mod4Mask .|. controlMask .|. shiftMask, xK_KP_Divide), withFocused (keysResizeWindow (0, 8) (0, 0))) -- make window smaller
-- Media keys volume
-- , ((0, 0x1008FF13), raiseVolume 2 >> spawn "pkill osd_cat" >> getVolume >>= flip osdCat (osdCatOpts "Volume")) -- requires xmonad-extras installed
-- , ((0, 0x1008FF11), lowerVolume 2 >> spawn "pkill osd_cat" >> getVolume >>= flip osdCat (osdCatOpts "Volume")) -- requires xmonad-extras installed
 , ((0, 0x1008FF13), raiseVolume 2 >>= showVol ) -- requires xmonad-extras installed
 , ((0, 0x1008FF11), lowerVolume 2 >>= showVol ) -- requires xmonad-extras installed
 , ((mod4Mask, 0x1008FF13), raiseVolume 50 >> spawn "pkill osd_cat" >> getVolume >>= flip osdCat (osdCatOpts "Volume")) -- requires xmonad-extras installed
 , ((mod4Mask, 0x1008FF11), lowerVolume 50 >> spawn "pkill osd_cat" >> getVolume >>= flip osdCat (osdCatOpts "Volume")) -- requires xmonad-extras installed
 , ((0, 0x1008FF12), toggleMute >> spawn (myVol ++ " dzen")) -- requires xmonad-extras installed
-- Media keys playback
 , ((0, 0x1008FF16), spawn myMpdPrev)
 , ((0, 0x1008FF14), spawn myMpdToggle)
 , ((0, 0x1008FF17), spawn myMpdNext)
 , ((0, 0x1008FF15), spawn myMpdStop)
 , ((0, 0x1008FF02), spawn "xbacklight -inc 10") -- brightness up
 , ((0, 0x1008FF03), spawn "xbacklight -dec 10") -- brightness down
 , ((0, 0x1008FF1D), spawn "xcalc") -- invoke calculator
 , ((0, 0x1008FF30), spawnSelected' myAppGrid) -- function key XF86Favorites
 , ((0, 0x1008FF59), spawn "arandr") -- funciton key XF86Display

-- TESTING
 --, ((mod4Mask, xK_y), pickPlayListItem RunMPD myXPConfig)
-- ENDTESTING
-- Monitor controls
 , (((mod4Mask .|. controlMask .|. shiftMask), xK_Print), submap . M.fromList $
 -- sort of finiky. had to run command in reverse twice
   [ ((0, xK_a), spawn "xrandr --auto --output $(cat /tmp/second) --primary --right-of $(cat /tmp/first); xrandr --auto --output $(cat /tmp/first) --primary --left-of $(cat /tmp/second)") -- my dual mornitor on
   , ((0, xK_p), spawn "xrandr --output $(cat /tmp/first) --off") -- my primary mornitor off
   , ((0, xK_s), spawn "xrandr --output $(cat /tmp/second) --off") -- my secondary moritor off
   ] )
-- System power controls; cant seem to get away from ctrl-alt-del
 , (((mod1Mask .|. controlMask ), xK_Delete), submap . M.fromList $ -- requires sudo priveledges. see arch wiki "allow users to shutdown"
   [ ((0, xK_s), spawn myScreenLock) -- screensaver lock
   , ((0, xK_q), spawn (myMsg ++ " q") >> io (exitWith ExitSuccess)) -- logout
   , ((0, xK_r), spawn "sudo systemctl reboot") -- reboot system
   , ((0, xK_p), spawn "sudo systemctl poweroff") -- poweroff system
   ] )
 ]
 ++
 (case hostname of
   "ARCHLAP" -> [
        (((mod4Mask .|. controlMask), xK_space), submap . M.fromList $
         [ ((0, k), spawn (myTerminal ++ " -p " ++ show i)) | (i,k) <- (zip myLTermProfiles numKeys ++ zip myLTermProfiles numPadKeys) ] -- mod-ctrl-t,[0..9] or [numPad0..9]
        )
        , (((mod4Mask .|. modalt), xK_space), submap . M.fromList $
         [ ((0, k), spawn (myTerminal ++ " -p " ++ show i)) | (i,k) <- (zip myLTATermProfiles numKeys ++ zip myLTATermProfiles numPadKeys) ] -- mod-ctrl-t,[0..9] or [numPad0..9]
        )
     ]
   "ARCHOLD" -> [
        (((mod4Mask .|. controlMask), xK_space), submap . M.fromList $
         [ ((0, k), spawn (myTerminal ++ " -p " ++ show i)) | (i,k) <- (zip myLTermProfiles numKeys ++ zip myLTermProfiles numPadKeys) ] -- mod-ctrl-t,[0..9] or [numPad0..9]
        )
        , (((mod4Mask .|. modalt), xK_space), submap . M.fromList $
         [ ((0, k), spawn (myTerminal ++ " -p " ++ show i)) | (i,k) <- (zip myLTATermProfiles numKeys ++ zip myLTATermProfiles numPadKeys) ] -- mod-ctrl-t,[0..9] or [numPad0..9]
        )
     ]
   "ARCHWORK" -> [
        (((mod4Mask .|. controlMask), xK_space), submap . M.fromList $
         [ ((0, k), spawn (myTerminal ++ " -p " ++ show i)) | (i,k) <- (zip myLTermProfiles numKeys ++ zip myLTermProfiles numPadKeys) ] -- mod-ctrl-t,[0..9] or [numPad0..9]
        )
        , (((mod4Mask .|. modalt), xK_space), submap . M.fromList $
         [ ((0, k), spawn (myTerminal ++ " -p " ++ show i)) | (i,k) <- (zip myTATermProfiles numKeys ++ zip myTATermProfiles numPadKeys) ] -- mod-ctrl-t,[0..9] or [numPad0..9]
        )
     ]
   _  -> [ 
        (((mod4Mask .|. controlMask), xK_space), submap . M.fromList $
         [ ((0, k), spawn (myTerminal ++ " -p " ++ show i)) | (i,k) <- (zip myTermProfiles numKeys ++ zip myTermProfiles numPadKeys) ] -- mod-ctrl-t,[0..9] or [numPad0..9]
        )
        , (((mod4Mask .|. modalt), xK_space), submap . M.fromList $
         [ ((0, k), spawn (myTerminal ++ " -p " ++ show i)) | (i,k) <- (zip myLTATermProfiles numKeys ++ zip myLTATermProfiles numPadKeys) ] -- mod-alt-t,[0..9] or [numPad0..9]
        )
     ]
 )
 ++
 [ ((m .|. mod4Mask, k), windows $ f i)
   | (i, k) <- (zip myWorkspaces numKeys ++ zip myWorkspaces numPadKeys) -- minus and KP_Subtract go to NSP WS; = and KP_add go to NSP1; KP_/ to DEV1 ; KP_* to DEV2
   , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask), (copy, shiftMask .|. controlMask)]
 ]
 where
  osdCatOpts s mute = " --outline=3 --align=center -cgreen --pos=middle --delay=1 --text=" ++ s
  getSortByIndexNoWSList = fmap (. filter (\(W.Workspace tag _ _) -> not (tag `elem` myExtraWSs))) getSortByIndex
-- }}}
------------------
-- Mouse Bindings -- {{{
------------------
-- xev | grep -A2 --line-buffered '^ButtonRelease' | sed -n '/button /s/^.*button \([0-9]*\).*/\1/p'
-- Mouse Bindings
myMouseBindings (hostname) = [
 -- Custom Mouse Bindings
  ((mod1Mask .|. controlMask, button1), (\w -> focus w >> spawn (myMpd ++ " mpc")))     -- just spawn mpc
  , ((mod1Mask .|. controlMask, button4), (\w -> focus w >> raiseVolume 2 >>= showVol )) -- requires xmonad-extras installed
  , ((mod1Mask .|. controlMask, button5), (\w -> focus w >> lowerVolume 2 >>= showVol )) -- requires xmonad-extras installed
  , ((mod1Mask .|. controlMask, 6), (\w -> focus w >>  spawn myMpdPrev))
  , ((mod1Mask .|. controlMask, 7), (\w -> focus w >>  spawn myMpdNext))
  , ((mod1Mask .|. shiftMask, button1), (\w -> focus w >> spawn myMpdKill))
  , ((mod4Mask .|. shiftMask, button2), (\w -> focus w >> kill))
  , ((mod4Mask .|. shiftMask, button4), (\w -> windows . W.shift =<< findWorkspace getSortByIndexNoWSList Next EmptyWS 1))
  , ((mod4Mask .|. shiftMask, button5), (\w -> windows . W.shift =<< findWorkspace getSortByIndexNoWSList Prev EmptyWS 1))
  , ((mod4Mask, button4), (\w -> windows . W.greedyView =<< findWorkspace getSortByIndexNoWSList Next HiddenNonEmptyWS 1))
  , ((mod4Mask, button5), (\w -> windows . W.greedyView =<< findWorkspace getSortByIndexNoWSList Prev HiddenNonEmptyWS 1))
  , ((mod1Mask, button2), (\w -> focus w >> spawn myMpdToggle))
  , ((mod1Mask, button4), (\w -> focus w >> spawn myMpdNext))
  , ((mod1Mask, button5), (\w -> focus w >> spawn myMpdPrev))
  , ((mod4Mask, 8), (\w -> windows . W.greedyView =<< findWorkspace getSortByIndexNoWSList Next HiddenEmptyWS 1))
  , ((mod4Mask, 9), (\w -> windows . W.greedyView =<< findWorkspace getSortByIndexNoWSList Prev HiddenEmptyWS 1))
 ]
 where
  getSortByIndexNoWSList = fmap (. filter (\(W.Workspace tag _ _) -> not (tag `elem` myExtraWSs))) getSortByIndex
-- }}}
------------------
-- Finally, a copy of the default bindings in a simple text file -- {{{
------------------
-- Xmonad Default. Note: mod=mod4Mask or windows key --
help_default_keybindings="~/.xmonad/help_default_keybindings.txt"
-- Custom Key bindings  --
help_custom_keybindings="~/.xmonad/help_custom_keybindings.txt"
-- }}} 
