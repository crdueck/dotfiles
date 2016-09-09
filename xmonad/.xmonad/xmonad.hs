{-# LANGUAGE RecordWildCards #-}

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Fullscreen
import XMonad.Layout.ResizableTile
import XMonad.Layout.TwoPane
import XMonad.Util.Cursor
import XMonad.Util.Run

import System.Exit (exitSuccess)
import System.IO (Handle)

import qualified Data.Map as M
import qualified XMonad.StackSet as W

rofi :: String
rofi = "rofi -show run -hide-scrollbar"

tmux :: String
tmux  = "urxvtc -e /bin/zsh -c '(tmux -q has && tmux att -t 0) || tmux new'"

main :: IO ()
main = do
    xmobar <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
    xmonad $ def
        { terminal           = "urxvtc"
        , startupHook        = return ()
        , focusFollowsMouse  = False
        , normalBorderColor  = "#101010"
        , focusedBorderColor = "#101010"
        , modMask            = mod1Mask
        , layoutHook         = xLayout
        , logHook            = xLogHook xmobar
        , workspaces         = xWorkspaces
        , manageHook         = manageDocks
        , handleEventHook    = docksEventHook
        , keys               = xKeys
        }

xLogHook :: Handle -> X ()
xLogHook hdl = dynamicLogWithPP def
    { ppCurrent         = xmobarColor "#7cafc2" "#101010" . pad
    , ppHidden          = xmobarColor "#f8f8f8" "#101010" . pad
    , ppHiddenNoWindows = xmobarColor "#383838" "#101010" . pad
    , ppUrgent          = xmobarColor "#ab4642" "#101010" . pad
    , ppSep             = xmobarColor "#757575" "#101010" ""
    , ppWsSep           = ""
    , ppTitle           = xmobarColor "#f8f8f8" "#101010" . takeNWords 5
    , ppLayout          = const ""
    , ppOrder           = take 1
    , ppOutput          = hPutStrLn hdl
    }

takeNWords :: Int -> String -> String
takeNWords n = unwords . take n . words

xWorkspaces :: [String]
xWorkspaces = map fontawesome
    [ "\xf269" -- web
    , "\xf121" -- dev
    , "\xf19d" -- edu
    , "\xf0e0" -- mail
    , "\xf11b" -- game
    ] where fontawesome = wrap "<fn=1>" "</fn>"

xLayout = avoidStruts resizableTall ||| avoidStruts twoPane ||| fullscreenFull Full
    where resizableTall = ResizableTall 1 (3/100) (3/5) []
          twoPane = TwoPane (3/100) (1/2)

winMask :: KeyMask
winMask = mod4Mask

xKeys :: XConfig l -> M.Map (KeyMask, KeySym) (X ())
xKeys XConfig{..} = M.fromList $
    [
    -- close focused window
      ((modMask .|. shiftMask, xK_c        ), kill)
    -- rotate through the available layout algorithms
    , ((modMask,               xK_space    ), sendMessage NextLayout)
    -- move focus to the next window
    , ((modMask,               xK_t        ), windows W.focusDown)
    -- move focus to the previous window
    , ((modMask,               xK_n        ), windows W.focusUp)
    -- move focus to the master window
    , ((modMask,               xK_m        ), windows W.focusMaster)
    -- swap the focused window and the master window
    , ((modMask .|. shiftMask, xK_m        ), windows W.swapMaster)
    -- swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_t        ), windows W.swapDown)
    -- swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_n        ), windows W.swapUp)
    -- shrink the master area
    , ((modMask,               xK_h        ), sendMessage Shrink)
    -- expand the master area
    , ((modMask,               xK_s        ), sendMessage Expand)
    -- shrink the slave area
    , ((modMask .|. shiftMask, xK_h        ), sendMessage MirrorShrink)
    -- expand the slave area
    , ((modMask .|. shiftMask, xK_s        ), sendMessage MirrorExpand)
    -- sink floating window
    , ((modMask,               xK_f        ), withFocused (windows . W.sink))
    -- restart xmonad/xmobar
    , ((modMask .|. shiftMask, xK_r        ), spawn "killall xmobar && xmonad --recompile && xmonad --restart")
    -- kill xmonad and X11
    , ((modMask .|. shiftMask, xK_q        ), liftIO exitSuccess)
    -- move to next workspace
    , ((winMask,               xK_Return   ), nextWS)
    -- move to previous workspace
    , ((winMask,               xK_BackSpace), prevWS)
    -- take window to next workspace
    , ((winMask .|. shiftMask, xK_Return   ), shiftToNext >> nextWS)
    -- take window to previous workspace
    , ((winMask .|. shiftMask, xK_BackSpace), shiftToPrev >> prevWS)
    -- media bindings
    , ((0, 0x1008ff11), spawn "amixer set Master 5- toggle unmute")
    , ((0, 0x1008ff13), spawn "amixer set Master 5+ toggle unmute")
    , ((0, 0x1008ff14), spawn "mpc toggle")
    , ((0, 0x1008ff16), spawn "mpc prev")
    , ((0, 0x1008ff17), spawn "mpc next")
    -- program bindings
    , ((modMask, xK_comma), spawn terminal)
    , ((modMask, xK_p), spawn rofi)
    , ((modMask, xK_i), spawn tmux)
    ] ++
    -- win-[1..9]: switch to workspace N
    -- win-shift-[1..9]: move client to workspace N
    [((m .|. winMask, k), windows (f i)) |
        (i, k) <- zip workspaces [xK_1 .. xK_9],
        (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    ]
